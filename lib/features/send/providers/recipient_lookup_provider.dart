import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neosapien_share/data/repositories/recipient_lookup_repository.dart';
import 'package:neosapien_share/domain/interfaces/recipient_lookup_repository.dart';
import 'package:neosapien_share/features/identity/providers/identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
part 'recipient_lookup_provider.freezed.dart';
part 'recipient_lookup_provider.g.dart';

@freezed
class RecipientLookupState with _$RecipientLookupState {
  const factory RecipientLookupState({
    required String normalizedCode,
    required bool isLoading,
    String? errorMessage,
    String? resolvedRecipientCode,
  }) = _RecipientLookupState;

  factory RecipientLookupState.initial() => const RecipientLookupState(
    normalizedCode: '',
    isLoading: false,
    errorMessage: null,
    resolvedRecipientCode: null,
  );
}

final recipientLookupRepositoryProvider = Provider<RecipientLookupRepository>(
  (ref) => FirestoreRecipientLookupRepository(
    firebaseService: ref.watch(firebaseServiceProvider),
  ),
);

@riverpod
class RecipientLookup extends _$RecipientLookup {
  Timer? _debounceTimer;

  @override
  RecipientLookupState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return RecipientLookupState.initial();
  }

  void onInputChanged(String rawInput) {
    final normalized = _normalizeCode(rawInput);
    _debounceTimer?.cancel();

    state = state.copyWith(
      normalizedCode: normalized,
      isLoading: false,
      errorMessage: null,
      resolvedRecipientCode: null,
    );

    if (normalized.isEmpty) {
      state = state.copyWith(isLoading: false);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      unawaited(validateRecipientCode());
    });
  }

  Future<bool> validateRecipientCode() async {
    _debounceTimer?.cancel();
    final code = state.normalizedCode;

    if (code.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        resolvedRecipientCode: null,
      );
      return false;
    }

    final senderCode = ref.read(identityProvider).valueOrNull?.shortCode;

    if (senderCode != null && code == senderCode) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "You can't send to yourself.",
        resolvedRecipientCode: null,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      resolvedRecipientCode: null,
    );

    try {
      final exists = await ref
          .read(recipientLookupRepositoryProvider)
          .userExists(code);

      if (!exists) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No user found with code $code',
          resolvedRecipientCode: null,
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        resolvedRecipientCode: code,
        errorMessage: null,
      );
      return true;
    } on FirebaseException {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'We could not reach the network. Check your connection and try again.',
        resolvedRecipientCode: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'We could not verify that code right now. Please try again.',
        resolvedRecipientCode: null,
      );
      return false;
    }
  }

  static String _normalizeCode(String input) {
    return input.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }
}
