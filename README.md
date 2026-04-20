# NeoSapien Share

Peer-to-peer file transfer over Firebase. Users are identified by a 6-character short code. Files are encrypted in transit via HTTPS and stored in Firebase Storage. Transfers expire after 72 hours.

---

## Architecture

| Layer | Technology |
|---|---|
| State | Riverpod 2 (`AsyncNotifier`, `StreamNotifier`, `StateNotifier`) |
| Navigation | `go_router` |
| Backend | Cloud Firestore + Firebase Storage |
| Notifications | FCM (push) + `flutter_local_notifications` (foreground) |
| Download | `dio` — byte-streaming, no full-file in memory |
| Integrity | SHA-256 (computed in a separate isolate via `flutter/compute`) |

---

## Push Notifications

### How it works

1. **Identity provisioning** — when the app first launches (or after re-install), it provisions a 6-character short code and writes it to `users/{shortCode}` in Firestore along with the FCM token.

2. **Token refresh** — `FirebaseMessaging.instance.onTokenRefresh` is subscribed at startup. Every rotation writes the new token to `users/{shortCode}.fcmToken` via `IdentityRepository.refreshFcmToken`.

3. **Cloud Function** — `functions/index.js` exports `onTransferReady`, a Firestore `onDocumentWritten` trigger on `transfers/{transferId}`. When `status` transitions to `"ready"` it:
   - Looks up `users/{recipientCode}.fcmToken`
   - Aggregates file count and total bytes from the `files` sub-collection
   - Sends a **data-only** FCM message (no `notification` block) with `{ type, transferId, senderCode, fileCount, totalBytes }`

4. **Flutter handling — three states**:

   | App state | Behaviour |
   |---|---|
   | **Foreground** | `FirebaseMessaging.onMessage` fires → `NotificationService` shows a `SnackBar` with a **"View"** button that navigates to `ReceiveScreen` |
   | **Background** | `firebaseMessagingBackgroundHandler` (top-level isolate) fires → `flutter_local_notifications` shows a system banner; tapping it calls `onDidReceiveNotificationResponse` which navigates to `ReceiveScreen` |
   | **App killed** | Same background handler shows the notification; `FirebaseMessaging.instance.getInitialMessage()` is checked on next launch and navigates to `ReceiveScreen` after the router is mounted |

### Deploying the Cloud Function

```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

Requires Firebase CLI and a project with Blaze (pay-as-you-go) plan.

---

## FCM Permission Denial — Fallback Behaviour

When the user denies notification permission (or on platforms where FCM is unavailable), the app degrades gracefully:

- `IdentityRepository._readFcmToken()` calls `messaging.requestPermission()`. If the status is `AuthorizationStatus.denied`, it returns `null` — no token is stored in Firestore and no push is ever sent.
- The Cloud Function silently skips the send when `fcmToken` is absent.
- The app does **not** crash or block onboarding.

**Polling fallback**: `IncomingTransfersNotifier` wraps a **real-time Firestore listener** (not polling) so transfers are always visible the moment the app is open, regardless of whether FCM permission was granted. The listener fires on any status → `ready` or `queued` document that matches `recipientCode == myCode AND expiresAt > now`. This means users who denied push notifications (or were offline when the push was sent) will still receive transfers the moment they open the app.

### 72-Hour TTL & Offline Queuing

To ensure privacy and storage efficiency, NeoSapien Share implements a strict TTL (Time To Live) policy:

1. **Automatic Expiry**: All transfers automatically expire 72 hours after upload.
2. **Offline Queuing**: If a recipient is offline (no FCM token available), the transfer is marked as `queued`. It remains available for the recipient to discover via the real-time listener for the full 72-hour window.
3. **Cleanup Job**: A scheduled Cloud Function runs every 6 hours to find expired transfers, delete their files from Firebase Storage, and mark their status as `expired` in Firestore.
4. **Sender Visibility**: Senders can track the delivery state in real-time (`queued` → `delivered` → `expired`).

> To implement a true polling fallback for backgrounded users who denied FCM, add a `WorkManager` / `BGTaskScheduler` periodic task that calls `IncomingTransferRemoteDataSource.watchIncomingTransfers` once and shows a local notification if new transfers are found. This is left as a future enhancement.

---

## Firestore Schema

```
users/{shortCode}
  shortCode: string
  createdAt: timestamp
  fcmToken?: string

transfers/{transferId}
  senderId: string        ← shortCode of sender
  recipientCode: string
  status: "uploading" | "ready"
  createdAt: timestamp
  expiresAt: timestamp

transfers/{transferId}/files/{fileId}
  name: string
  size: number
  mimeType: string
  storageUrl: string
  sha256: string
  progress: number
  status: "uploading" | "uploaded" | "failed"
```

---

## Getting Started

1. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platform directories.
2. Copy `.env.example` to `.env` and fill in `FIREBASE_PROJECT_ID` and `STORAGE_BUCKET`.
3. Run `flutter pub get`.
4. Run `dart run build_runner build --delete-conflicting-outputs`.
5. Run `flutter run`.
