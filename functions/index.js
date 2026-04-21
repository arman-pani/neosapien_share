// @ts-check
'use strict';

const { onDocumentWritten }     = require('firebase-functions/v2/firestore');
const { onSchedule }            = require('firebase-functions/v2/scheduler');
const { initializeApp }         = require('firebase-admin/app');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');
const { getStorage }            = require('firebase-admin/storage');
const { getMessaging }          = require('firebase-admin/messaging');
const { setGlobalOptions }      = require('firebase-functions/v2');
const logger                    = require('firebase-functions/logger');

// Set global region to asia-south1 to match the project default
setGlobalOptions({ region: 'asia-south1' });

initializeApp();

// =============================================================================
// Offline-recipient / TTL design
// =============================================================================
//
// Transfers have a 72-hour TTL enforced via expiresAt in Firestore.
//
// Status flow:
//   uploading → queued   (upload done, recipient has no FCM token / is offline)
//   uploading → ready    (upload done, FCM push sent successfully)
//   ready     → delivered (recipient acknowledged download via Firestore update)
//   *         → expired  (cleanup job: expiresAt passed, set by cleanupExpiredTransfers)
//   *         → cancelled (sender cancelled mid-upload)
//
// The Flutter recipient listener filters: status == "ready" AND expiresAt > now.
// When the recipient comes online and the transfer is still "queued", the Cloud
// Function sends the FCM push at that point (not yet — that requires a user
// presence trigger). Instead, the Firestore real-time listener on the recipient
// side catches "queued" transfers too, since the Flutter filter includes both
// "ready" and "queued" for the real-time listener.
//
// cleanupExpiredTransfers runs every 6 hours and:
//   1. Sets status = "expired" on any transfer where expiresAt <= now.
//   2. Deletes all Storage files for that transfer.
// =============================================================================

// ---------------------------------------------------------------------------
// Helper: send FCM and return the push success boolean
// ---------------------------------------------------------------------------

/**
 * @param {import('firebase-admin/firestore').Firestore} db
 * @param {string} transferId
 * @param {string} recipientCode
 * @param {string} senderCode
 * @param {number} fileCount
 * @param {number} totalBytes
 * @returns {Promise<boolean>} true if push was sent successfully
 */
async function sendFcmPush(db, transferId, recipientCode, senderCode, fileCount, totalBytes) {
  try {
    const userSnap = await db.collection('users').doc(recipientCode).get();
    if (!userSnap.exists) {
      logger.warn(`[${transferId}] User doc not found for code: ${recipientCode}`);
      return false;
    }

    const fcmToken = userSnap.data()?.fcmToken;
    if (!fcmToken) {
      logger.info(`[${transferId}] No FCM token for ${recipientCode} — transfer queued.`);
      return false;
    }

    const message = {
      token: fcmToken,
      data: {
        type:       'incoming_transfer',
        transferId: transferId,
        senderCode: senderCode,
        fileCount:  String(fileCount),
        totalBytes: String(totalBytes),
      },
      android: { priority: 'high' },
      apns: {
        headers: { 'apns-priority': '10', 'apns-push-type': 'background' },
        payload: { aps: { 'content-available': 1 } },
      },
    };

    const response = await getMessaging().send(message);
    logger.log(`[${transferId}] FCM sent to ${recipientCode}: ${response}`);
    return true;
  } catch (err) {
    logger.error(`[${transferId}] FCM send failed:`, err);
    if (err?.code === 'messaging/registration-token-not-registered') {
      await db.collection('users').doc(recipientCode).update({ fcmToken: null }).catch(e => {
        logger.error(`[${transferId}] Failed to clear stale token:`, e);
      });
      logger.info(`[${transferId}] Stale token marked for removal for ${recipientCode}`);
    }
    return false;
  }
}

// ---------------------------------------------------------------------------
// onTransferReady — fires whenever a transfer doc is written
// ---------------------------------------------------------------------------
// When status transitions to "ready":
//   • Try to send FCM push.
//   • If FCM succeeds → status stays "ready".
//   • If FCM fails (no token, stale token) → set status to "queued".
//
// "queued" transfers are still surfaced to the recipient via the Firestore
// real-time listener in the Flutter app (which filters queued|ready).

exports.onTransferReady = onDocumentWritten(
  'transfers/{transferId}',
  async (event) => {
    const transferId = event.params.transferId;
    const db = getFirestore();

    try {
      const afterSnap = event.data?.after;
      if (!afterSnap?.exists) return;

      const afterData  = afterSnap.data();
      const beforeData = event.data?.before?.data();

      const beforeStatus = beforeData?.status ?? null;
      const afterStatus  = afterData?.status  ?? null;

      // Only act on the transition to "ready".
      if (afterStatus !== 'ready' || beforeStatus === 'ready') return;

      // IDEMPOTENCY GUARD: Don't send push if already sent.
      if (afterData.notificationSent === true) {
        logger.info(`[${transferId}] Push already sent, skipping.`);
        return;
      }

      const recipientCode = afterData.recipientCode;
      const senderCode    = afterData.senderId ?? '';

      if (!recipientCode) {
        logger.error(`[${transferId}] Missing recipientCode.`);
        return;
      }

      // Aggregate file metadata for the push payload.
      const filesSnap = await db
        .collection('transfers')
        .doc(transferId)
        .collection('files')
        .get();

      const fileCount  = filesSnap.size;
      const totalBytes = filesSnap.docs.reduce(
        (sum, d) => sum + (d.data()?.size ?? 0),
        0,
      );

      const pushed = await sendFcmPush(
        db, transferId, recipientCode, senderCode, fileCount, totalBytes,
      );

      // If FCM could not be sent, mark as "queued" so the sender's listener
      // can display "Queued — recipient offline" instead of "Delivered".
      if (!pushed) {
        await db.collection('transfers').doc(transferId).update({
          status: 'queued',
        });
        logger.info(`[${transferId}] Status set to 'queued' (recipient offline).`);
      } else {
        // Mark as sent to prevent duplicates if the doc is updated again.
        await db.collection('transfers').doc(transferId).update({
          notificationSent: true,
        });
      }
    } catch (err) {
      logger.error(`[${transferId}] Error in onTransferReady:`, err);
    }
  },
);

// ---------------------------------------------------------------------------
// cleanupExpiredTransfers — runs every 6 hours
// ---------------------------------------------------------------------------
// Finds all transfers where expiresAt <= now and:
//   1. Deletes all Storage files under transfers/{transferId}/.
//   2. Sets status = "expired" (sender's listener will react).
//
// This function is safe to re-run: already-expired docs are idempotent.

exports.cleanupExpiredTransfers = onSchedule(
  { schedule: 'every 6 hours', timeoutSeconds: 300 },
  async (_context) => {
    const db      = getFirestore();
    const storage = getStorage();

    try {
      const now = Timestamp.now();

      // Query for any non-expired, non-cancelled transfers that are past TTL.
      const snapshot = await db
        .collection('transfers')
        .where('expiresAt', '<=', now)
        .where('status', 'not-in', ['expired', 'cancelled'])
        .get();

      if (snapshot.empty) {
        logger.info('cleanupExpiredTransfers: nothing to expire.');
        return;
      }

      logger.info(`cleanupExpiredTransfers: expiring ${snapshot.size} transfer(s).`);

      const bucket = storage.bucket();

      await Promise.all(
        snapshot.docs.map(async (doc) => {
          const transferId = doc.id;

          // 1. Delete all Storage files under transfers/{transferId}/
          try {
            const [files] = await bucket.getFiles({
              prefix: `transfers/${transferId}/`,
            });
            await Promise.all(files.map((f) => f.delete()));
            logger.log(`[${transferId}] Deleted ${files.length} Storage file(s).`);
          } catch (err) {
            logger.error(`[${transferId}] Storage deletion error:`, err);
          }

          // 2. Mark transfer as expired in Firestore.
          try {
            await doc.ref.update({ status: 'expired' });
            logger.log(`[${transferId}] Status → expired.`);
          } catch (err) {
            logger.error(`[${transferId}] Firestore update error:`, err);
          }
        }),
      );
    } catch (err) {
      logger.error('Error in cleanupExpiredTransfers:', err);
    }
  },
);
