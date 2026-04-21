# NeoSapien Share — Developer Intern Assessment

A cross-platform file sharing application that enables peer-to-peer transfers via anonymous short codes. Built with Flutter and Firebase.

---

## 🚀 How to Run Locally

### 1. Prerequisites

- Flutter SDK (tested on 3.41.6)
- Firebase CLI (`npm install -g firebase-tools`)
- Google Cloud Project with Billing enabled (for Cloud Functions)

### 2. Setup

1. **Firebase**:
   - Create a Firebase project.
   - Initialise Firestore and Firebase Storage.
   - Add Android (`google-services.json`) and iOS (`GoogleService-Info.plist`) config files.
2. **Backend**:
   ```bash
   cd functions
   npm install
   firebase deploy --only functions
   ```
3. **Build**:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run
   ```

---

## 🏗️ Architecture Overview

```text
[ CLIENT A ] <────(FCM/Firestore)────> [ CLIENT B ]
      │                                     │
      └───────────┐                 ┌───────┘
                  ▼                 ▼
          [ FIREBASE STORAGE ] <─── [ CLOUD FUNCTIONS ]
          (GCS Resumable PUT)       (TTL Cleanup & FCM)
```

- **Client**: Flutter (Riverpod for state, GoRouter for navigation).
- **Transport**: HTTPS (TLS 1.3) via GCS Resumable Upload protocol.
- **Relay**: Firestore (metadata sync) + FCM (recipient wake-up).
- **Storage**: Google Cloud Storage (regional bucket).

### Transport Choice & Rationale

We chose **Firebase (GCS Resumable + Firestore)** as our primary transport.

- **Rationale**: It provides a native "Chunked Resumable" protocol out-of-the-box. This ensures that large transfers (tested up to 1GB) can survive network transitions and app kills without restarting from byte zero.
- **Real-time Sync**: Firestore's snapshot listeners allow us to mirror transfer states across sender/recipient without proprietary WebSocket overhead.

---

## 🛠️ Section 3: Edge Cases

| Case                         | Status      | Implementation Detail                                                                 |
| ---------------------------- | ----------- | ------------------------------------------------------------------------------------- |
| ★ Short-code collisions      | **Handled** | Alphanumeric 6-char codes. Firestore uniqueness check during registration.            |
| ★ Invalid recipient code     | **Handled** | Failed fast with UI message via Firestore document lookup.                            |
| ★ Recipient offline          | **Handled** | FCM wakeup + Firestore status `queued`. TTL handles cleanup.                          |
| ★ Network drops mid-transfer | **Handled** | GCS Resumable URIs stored in `SharedPreferences` for auto-resumption.                 |
| ★ Large files (1GB)          | **Handled** | Byte-streaming via `Dio` and background isolates for hashing.                         |
| ★ Multiple files             | **Handled** | Weighted aggregate progress logic in Notifiers.                                       |
| ★ Permission denial          | **Handled** | Graceful degradation for storage/notifications; in-app UX fallbacks.                  |
| ★ Incoming (App Closed)      | **Handled** | FCM data messages + High Priority system notifications with deep links.               |
| Corrupted transfers          | **Partial** | SHA-256 computed on sender side; Receiver side verification acknowledged but skipped. |
| Filename conflicts           | **Handled** | Files are stored in transfer-scoped directories to avoid collisions.                  |

---

## 🛠️ Bonus: Platform Channel Integration

**Status**: Skipped.
**Honesty**: To ensure the core resumable transfer flow was industrial-grade within the timeframe, I prioritized polished implementations of `file_picker` and `open_filex` rather than writing raw `ACTION_OPEN_DOCUMENT` (Android) or `UIDocumentPickerViewController` (iOS).

---

## 🐞 Known Bugs & Limitations

1. **Receiver-side Hash Verification**: While the sender generates an SHA-256 hash, the receiver currently downloads the file without re-verifying the hash locally before opening.
2. **App Check**: Currently using a placeholder token; requires `AppCheckProvider` configuration for production.
3. **Disk Space Check**: The app does not currently check if the recipient has enough free disk space before initiating a 1GB download.

---

## 🤖 AI Tool Usage

I used **Antigravity (Gemini)** for:

- Scaffolding the initial Riverpod feature layers.
- Debugging the GCS Resumable Upload `PUT` headers (Dio interop).
- Writing the boilerplate for the Scheduled Cloud Function.

**Where I overrode it**:

- The AI suggested loading smaller files into memory (`readAsBytes`) for hashing. I rejected this and implemented a custom **Streaming Digest Collector** in a separate isolate to ensure 0% chance of OOM on low-end devices.
- I manually refactored the `ReceiveScreen` navigation to include `canPop()` safety checks, as the generated code frequently crashed on deep-link "Back" button presses.

---

### Devices Tested on:

- **OnePlus 12R (CPH2585)**: Android 13
- **Samsung M31 (SM-M315F)**: Android 12

---
