import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import 'identity_repository.dart';
import 'identity_state.dart';

final identityRepositoryProvider = Provider<IdentityRepository>(
  (ref) => FirestoreIdentityRepository(
    firebaseService: ref.watch(firebaseServiceProvider),
  ),
);

final identityProvider = AsyncNotifierProvider<IdentityProvider, IdentityState>(
  IdentityProvider.new,
);

class IdentityProvider extends AsyncNotifier<IdentityState> {
  @override
  Future<IdentityState> build() async {
    return ref.watch(identityRepositoryProvider).ensureIdentity();
  }

  Future<void> retryProvisioning() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(identityRepositoryProvider)
          .ensureIdentity(forceRefresh: true),
    );
  }
}
