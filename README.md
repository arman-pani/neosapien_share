# NeoSapien Share

Peer-to-peer file transfer over Firebase. Users are identified by a 6-character short code — no accounts, no sign-in. Files are encrypted in transit via HTTPS (TLS), stored in Firebase Storage, and automatically purged after 72 hours.

Built as part of the NeoSapien Flutter Developer Intern Assessment.

---

## Devices & OS Versions Tested

| Device                  | OS                  | Role               |
| :---------------------- | :------------------ | :----------------- |
| Android physical device | Android 13          | Sender + Recipient |
| Android emulator        | Android 13 (API 33) | Sender + Recipient |

Minimum: Android ↔ Android on two physical devices, or one physical device + one emulator.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                        CLIENT                           │
│                                                         │
│   Presentation  ←→  Riverpod Providers  ←→  Domain     │
│   (Screens /         (AsyncNotifier /      (Interfaces  │
│    Widgets)           StreamNotifier)       + Entities) │
│                              ↕                          │
│                         Data Layer                      │
│              (FirestoreIdentityRepository,              │
│               TransferRepository,                       │
│               ReceiveRepository)                        │
└──────────────────────────┬──────────────────────────────┘
                           │ HTTPS / TLS
          ┌────────────────┼────────────────┐
          ↓                ↓                ↓
   Cloud Firestore   Firebase Storage   FCM + Cloud
   (transfer meta,   (file bytes,       Functions
    user registry,    resumable PUT)    (push notify,
    real-time                            TTL cleanup)
    listeners)
```

### Layer Responsibilities

| Layer        | Location                       | Responsibility                                     |
| :----------- | :----------------------------- | :------------------------------------------------- |
| Presentation | `lib/features/*/presentation/` | Screens and widgets — UI only                      |
| Providers    | `lib/features/*/providers/`    | Riverpod notifiers, state management               |
| Domain       | `lib/domain/`                  | Abstract repository interfaces, pure Dart entities |
| Data         | `lib/data/`                    | Firebase implementations, remote data sources      |
| Core         | `lib/core/`                    | Router, theme, app-wide DI, services               |
| Shared       | `lib/shared/`                  | Reusable widgets and utilities                     |

---

## Transport Choice & Rationale

**Firebase Storage (resumable PUT) + Cloud Firestore (real-time listeners) + FCM (push)**

- **Why not WebRTC / WebSockets / self-hosted relay**: Firebase gives us a globally distributed relay with at-rest encryption, signed URLs, and resumable upload support out of the box. A self-hosted relay would require infrastructure management and NAT traversal logic that is out of scope for this timeline.
- **Why FCM data messages**: A data-only FCM message (no `notification` block) wakes the app in background without showing a duplicate system notification. The Cloud Function sends the push the moment a transfer transitions to `ready` in Firestore.
- **Why Firestore listeners**: Even when FCM is denied or unavailable, `IncomingTransfersNotifier` holds a live `snapshots()` listener. Transfers appear the moment the app is opened — no polling, no manual refresh.
- **Transport encryption**: All Firebase Storage traffic is over HTTPS (TLS 1.2+). Firestore uses the same. No plaintext bytes leave the device.

---

## How to Run Locally

### Prerequisites

- Flutter SDK `^3.11.4`
- Firebase CLI (`npm install -g firebase-tools`)
- A Firebase project with Blaze (pay-as-you-go) plan
- Node.js `^18` (for Cloud Functions)

### Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/arman-pani/neosapien_share.git
   cd neosapien_share
   ```

2. Add your Firebase config files:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

3. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

4. Run code generation (Riverpod + Freezed):

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. Deploy the Cloud Function:

   ```bash
   cd functions
   npm install
   cd ..
   firebase deploy --only functions
   ```

6. Run the app:
   ```bash
   flutter run
   ```

> **Note**: There is no `.env` file. All Firebase configuration is provided via the platform-specific `google-services.json` / `GoogleService-Info.plist` files. No secrets are committed to the repository.

---

## Key Packages

| Package                                    | Purpose                                              |
| :----------------------------------------- | :--------------------------------------------------- |
| `flutter_riverpod` + `riverpod_annotation` | State management with code generation                |
| `freezed` + `freezed_annotation`           | Immutable state classes and data models              |
| `cloud_firestore`                          | Real-time transfer metadata and user registry        |
| `firebase_storage`                         | File storage with resumable upload support           |
| `firebase_messaging`                       | Push notifications via FCM data messages             |
| `flutter_local_notifications`              | Foreground and background local notification display |
| `dio`                                      | Streaming file downloads (`ResponseType.stream`)     |
| `go_router`                                | Declarative navigation and deep linking              |
| `file_picker`                              | Cross-platform file selection                        |
| `flutter_secure_storage`                   | Secure local UUID persistence across sessions        |
| `shared_preferences`                       | Short code persistence                               |
| `crypto`                                   | SHA-256 integrity hashing                            |
| `uuid`                                     | Transfer ID and local device UUID generation         |
| `open_filex`                               | Opening received files with the OS default app       |
| `connectivity_plus`                        | Network state monitoring                             |
| `permission_handler`                       | Runtime permission requests                          |
| `path_provider`                            | App-scoped storage directory resolution              |
| `mime`                                     | MIME type detection for file selection               |

---

## Identity & Short Code System

Each device is assigned a **6-character alphanumeric short code** on first launch.

### Alphabet

```dart
static const _alphabet = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
```

Ambiguous characters `0`, `1`, `I`, `O` are intentionally excluded to prevent human transcription errors. This gives 32 characters over 6 positions ≈ **1.07 billion combinations**.

### Collision Handling (★ required)

Collision handling is enforced at the database level via a **Firestore transaction**:

1. A candidate code is generated locally using `Random.secure()`.
2. A transaction reads `users/{shortCode}` — if the document exists, the transaction returns `false` and the attempt is abandoned.
3. If the document does not exist, the transaction atomically writes the new user record.
4. On failure, a new code is generated and the process retries up to **5 times**.
5. If all 5 attempts fail, an `IdentityProvisioningException` is thrown with a clear message.

Two devices racing to claim the same code simultaneously cannot both succeed — the transaction guarantees only one write lands.

### Identity Persistence Tradeoff

Short codes are stored in `SharedPreferences`. If the user clears app data or reinstalls, `SharedPreferences` is wiped and the device provisions a **new short code**. The old code remains in Firestore as an orphan — it cannot be reclaimed.

**Tradeoff accepted**: Recovery of a previous short code after reinstall would require binding the code to a persistent device identifier (e.g. Android ID or Keychain UUID). This is implemented partially — a UUID is stored in `flutter_secure_storage` (which survives reinstall on Android) — but Firestore record recovery on reinstall is not implemented in this submission. This is documented as a known limitation.

---

## Push Notifications

### How It Works

1. On first launch, the app provisions a short code and writes the FCM token to `users/{shortCode}.fcmToken`.
2. `FirebaseMessaging.instance.onTokenRefresh` refreshes the token in Firestore on every rotation.
3. The `onTransferReady` Cloud Function triggers on `transfers/{transferId}` when `status` transitions to `"ready"`. It looks up the recipient's FCM token and sends a **data-only** message with `{ type, transferId, senderCode, fileCount, totalBytes }`.

| App state  | Behaviour                                                                                              |
| :--------- | :----------------------------------------------------------------------------------------------------- |
| Foreground | `FirebaseMessaging.onMessage` → `NotificationService` shows a SnackBar with a "View" button            |
| Background | `firebaseMessagingBackgroundHandler` → `flutter_local_notifications` shows a system banner             |
| Killed     | Same background handler; `getInitialMessage()` checked on next launch and navigates to `ReceiveScreen` |

### FCM Permission Denial — Fallback

If the user denies notification permission, `_readFcmToken()` returns `null`. No token is stored and no push is ever sent. The Cloud Function silently skips. The app does not crash or block onboarding.

The real-time Firestore listener in `IncomingTransfersNotifier` ensures transfers are always visible the moment the app is opened, regardless of push permission status.

---

## Memory Strategy

Files up to **500 MB** are supported. The app never loads a file into RAM.

### Upload

- SHA-256 is computed by feeding `file.openRead()` chunks one at a time into `sha256.startChunkedConversion()`. Only one ~64 KB OS page is in memory at a time.
- Firebase Storage's `putFile(File)` is used — the SDK reads the file off disk in its own chunks. `readAsBytes()` and `putData(Uint8List)` are never called.
- Peak RAM from an upload: **≈ 1–4 MB** (SDK internal buffer).

### Download

- Dio is configured with `ResponseType.stream`. Each `Uint8List` chunk is written directly to a `RandomAccessFile` sink and then released.
- Post-download SHA-256 verification runs in a separate **Isolate** via `compute()` using the same chunked streaming pattern. The main isolate holds zero bytes of the file during verification.
- Peak RAM per download: **≈ one network chunk (≤ 256 KB)**.

**Expected peak heap for a 500 MB transfer: under 20 MB.**

---

## 72-Hour TTL & Offline Queuing

1. All transfers are stamped with `expiresAt = createdAt + 72h`.
2. If the recipient is offline (no FCM token), the transfer is marked `queued`. The real-time listener surfaces it when the app next opens — within the 72-hour window.
3. A scheduled Cloud Function runs every 6 hours, deletes expired files from Firebase Storage, and marks their Firestore records as `expired`.
4. Senders see live status: `uploading → ready → queued → delivered → expired`.

---

## Firestore Schema

```
users/{shortCode}
  shortCode:  string
  createdAt:  timestamp
  fcmToken?:  string

transfers/{transferId}
  senderId:       string        ← shortCode of sender
  recipientCode:  string
  status:         "uploading" | "ready" | "queued" | "delivered" | "expired"
  createdAt:      timestamp
  expiresAt:      timestamp

transfers/{transferId}/files/{fileId}
  name:        string
  size:        number
  mimeType:    string
  storageUrl:  string
  sha256:      string
  progress:    number
  status:      "uploading" | "uploaded" | "failed"
```

---

## Edge Cases — Handled

| #   | Requirement                             | Status | Notes                                                                       |
| :-- | :-------------------------------------- | :----: | :-------------------------------------------------------------------------- |
| ★   | Short-code collisions                   |   ✅   | Firestore transaction + 5-attempt retry loop                                |
| ★   | Invalid recipient code                  |   ✅   | Lookup fails fast with a clear UI error message                             |
| ★   | Recipient offline                       |   ✅   | Transfer queued with 72h TTL; real-time listener delivers on next open      |
| ★   | Network drops mid-transfer              |   ✅   | Resumable GCS PUT protocol; upload survives reconnect                       |
| ★   | Large files (up to 500 MB)              |   ✅   | Streaming upload and download; peak heap < 20 MB                            |
| ★   | Multiple files at once                  |   ✅   | Per-file and aggregate progress; one failure does not kill the batch        |
| ★   | Permission denial                       |   ✅   | Storage and notification denial degrade gracefully; app does not crash      |
| ★   | Incoming transfer while app closed      |   ✅   | FCM data message → local notification → deep link to ReceiveScreen          |
| ★   | Transport encryption                    |   ✅   | All traffic over HTTPS / TLS                                                |
| —   | Ambiguous characters in short code      |   ✅   | 0, 1, I, O excluded from alphabet intentionally                             |
| —   | Corrupted transfers                     |   ✅   | SHA-256 verified end-to-end; mismatch surfaces as a failure state           |
| —   | Duplicate delivery                      |   ✅   | Deduped by `transferId`, not filename                                       |
| —   | Self-send                               |   ✅   | Allowed — sender and recipient codes can match                              |
| —   | Unusual MIME types (.heic, .webp, .mov) |   ✅   | MIME detected from file extension; unrecognised types shown as generic file |
| —   | Zero-byte files                         |   ✅   | Handled without crash; SHA-256 of empty file is verified                    |

## Edge Cases — Not Implemented / Known Limitations

| #   | Requirement                              | Notes                                                                                                                                                                                      |
| :-- | :--------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| —   | Identity recovery after reinstall        | Old short code cannot be reclaimed. New code is provisioned. Documented tradeoff.                                                                                                          |
| —   | Metered connection warning               | No cellular quota warning before large transfers.                                                                                                                                          |
| —   | Low device storage check                 | No pre-flight storage check before accepting a download.                                                                                                                                   |
| —   | Background transfer (foreground service) | Upload survives backgrounding on most devices but does not use an Android foreground service or iOS URLSession background config. OEM battery killers (Xiaomi, Oppo, Samsung) may kill it. |
| —   | Nearby transport (Wi-Fi Direct / BLE)    | Not implemented. All transfers go via Firebase Storage.                                                                                                                                    |
| —   | Platform channel (Pigeon)                | Not attempted in this submission.                                                                                                                                                          |
| —   | iOS support                              | Android only in this submission.                                                                                                                                                           |
| —   | Network transition (Wi-Fi ↔ cellular)    | Not explicitly tested mid-transfer.                                                                                                                                                        |

---

## AI Tool Usage

AI tools (Claude, Cursor) were used throughout this project for:

- Scaffolding the clean architecture folder structure
- Generating Riverpod provider boilerplate
- Writing and reviewing the memory strategy for large file transfers
- Drafting the Cloud Function logic

Every architectural decision was reviewed and defended manually. The Firestore transaction-based collision handling, the `_alphabet` design, the `ResponseType.stream` + `RandomAccessFile` download pattern, and the `compute()` isolate for SHA-256 verification were all understood, validated, and in some cases overridden from initial AI suggestions.

---

## Deploying the Cloud Function

```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

Requires Firebase CLI and a project on the Blaze (pay-as-you-go) plan.

---

## Known Bugs

- FCM token refresh occasionally fails silently on first launch on some Android emulators — restarting the app resolves it.
- The real-time listener for incoming transfers may fire twice on initial subscription in rare cases, resulting in a duplicate SnackBar notification. Deduplication by `transferId` prevents duplicate downloads.

---

_NeoSapien Share — built for the NeoSapien Flutter Developer Intern Assessment, April 2026._
