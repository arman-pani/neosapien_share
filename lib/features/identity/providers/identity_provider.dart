import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:neosapien_share/core/di/providers.dart';
import 'package:neosapien_share/domain/interfaces/identity_repository.dart';
import 'package:neosapien_share/domain/entities/identity_state.dart';
import 'package:neosapien_share/data/repositories/identity_repository.dart';

part 'identity_provider.g.dart';

final identityRepositoryProvider = Provider<IdentityRepository>(
  (ref) => FirestoreIdentityRepository(
    firebaseService: ref.watch(firebaseServiceProvider),
  ),
);

@Riverpod(keepAlive: true)
class Identity extends _$Identity {
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
