# AI Agents Guide - Neosapien Share

Welcome, Agent. This document outlines the architecture, patterns, and protocols of the **Neosapien Share** project (a cross-platform file sharing application).

## 🏗️ Architecture Overview

The project follows a **Feature-First Layered Architecture** powered by **Riverpod**.

- **lib/core/**: Application constants, logic-independent services, routing, and `theme/app_colors.dart`.
- **lib/domain/**: Pure business logic entities and abstract repository interfaces.
- **lib/data/**: Concrete implementations of repositories (Firebase, Local, etc.) and remote data sources.
- **lib/features/**: UI, State Management (Providers), and logic grouped by user-facing capability (Identity, Send, Receive).
- **lib/shared/**: Globally shared components such as `widgets/`, `utils/`, and `extensions/`.

## 🚀 Key Patterns

### 1. State Management (Riverpod)

- All providers use `@riverpod` or `@Riverpod(keepAlive: true)` annotations.
- Generated provider names come from `.g.dart` files — never declare providers manually.
- Run `dart run build_runner build --delete-conflicting-outputs` after changing any provider or model.
- Use `family` modifiers for session-based states (e.g., `sendUploadProvider(transferId)`).

### 2. Freezed Models

- All state classes (IdentityState, SendUploadState, ReceiveDownloadState, RecipientLookupState) are `@freezed`.
- Use `.copyWith()` for state updates — never mutate directly.
- Generated files are `*.freezed.dart` and `*.g.dart` — do not edit them manually.

### 3. File Transfers (Resumable)

- **Hashing**: All file hashing (SHA-256) MUST happen in a background **Isolate** using `compute()` to prevent UI thread jank.
- **Resumable Uploads**: We use Google Cloud Storage's resumable upload protocol (Streaming PUT) via `Dio`.
- **Database**: Transfer metadata is stored in Firestore (`transfers/` collection).

### 4. Identity System

- Users are assigned a unique 6-character short code.
- Identity is managed via `identityProvider` and stored in `FirestoreIdentityRepository`.
- **Note**: The app requires a valid SHA-1 certificate in the Firebase Console for Android Firestore/Auth to function (`DEVELOPER_ERROR` occurs otherwise).

## 🛠️ Diagnostics & Debugging

- **Logging**: Use `print()` with prefixes (e.g., `[UI]`, `[TransferRepo]`) for visibility in the Flutter console.
- **Error Handling**: Always use `AsyncValue.guard` or explicit try-catch blocks with StackTrace logging at the repository level.

## 🤝 Interaction Protocol for AI Agents

1.  **Safety First**: Never modify `android/` or `ios/` native configurations without explicitly checking the `README.md` or existing Gradle patterns.
2.  **Performance**: If a task involves heavy I/O or math, offload it to an Isolate.
3.  **Firebase**: When adding new features, ensure corresponding security rules or Firestore indexes are considered.
4.  **UI/UX**: Prioritize responsiveness. Ensure all asynchronous operations show a loading state (e.g., `AsyncValue.when`).

---

_Created on 2026-04-20 to support agentic collaboration._
