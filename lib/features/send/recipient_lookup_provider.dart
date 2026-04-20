import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../identity/identity_provider.dart';
import 'recipient_lookup_repository.dart';

class RecipientLookupState {
  const RecipientLookupState({
    required this.normalizedCode,
    required this.isLoading,
    this.errorMessage,
    this.resolvedRecipientCode,
  });

  const RecipientLookupState.initial()
    : normalizedCode = '',
      isLoading = false,
      errorMessage = null,
      resolvedRecipientCode = null;

  final String normalizedCode;
  final bool isLoading;
  final String? errorMessage;
  final String? resolvedRecipientCode;

  RecipientLookupState copyWith({
    String? normalizedCode,
    bool? isLoading,
    String? errorMessage,
    String? resolvedRecipientCode,
    bool clearError = false,
    bool clearResolvedRecipientCode = false,
  }) {
    return RecipientLookupState(
      normalizedCode: normalizedCode ?? this.normalizedCode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      resolvedRecipientCode: clearResolvedRecipientCode
          ? null
          : resolvedRecipientCode ?? this.resolvedRecipientCode,
    );
  }
}

final recipientLookupRepositoryProvider = Provider<RecipientLookupRepository>(
  (ref) => FirestoreRecipientLookupRepository(
    firebaseService: ref.watch(firebaseServiceProvider),
  ),
);

final recipientLookupProvider =
    AutoDisposeNotifierProvider<
      RecipientLookupController,
      RecipientLookupState
    >(RecipientLookupController.new);

class RecipientLookupController
    extends AutoDisposeNotifier<RecipientLookupState> {
  Timer? _debounceTimer;

  @override
  RecipientLookupState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const RecipientLookupState.initial();
  }

  void onInputChanged(String rawInput) {
    final normalized = _normalizeCode(rawInput);
    _debounceTimer?.cancel();

    state = state.copyWith(
      normalizedCode: normalized,
      isLoading: false,
      clearError: true,
      clearResolvedRecipientCode: true,
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
        clearError: true,
        clearResolvedRecipientCode: true,
      );
      return false;
    }

    final senderCode = ref.read(identityProvider).valueOrNull?.shortCode;

    if (senderCode != null && code == senderCode) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "You can't send to yourself.",
        clearResolvedRecipientCode: true,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearResolvedRecipientCode: true,
    );

    try {
      final exists = await ref
          .read(recipientLookupRepositoryProvider)
          .userExists(code);

      if (!exists) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No user found with code $code',
          clearResolvedRecipientCode: true,
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        resolvedRecipientCode: code,
        clearError: true,
      );
      return true;
    } on FirebaseException {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'We could not reach the network. Check your connection and try again.',
        clearResolvedRecipientCode: true,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'We could not verify that code right now. Please try again.',
        clearResolvedRecipientCode: true,
      );
      return false;
    }
  }

  static String _normalizeCode(String input) {
    return input.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }
}
