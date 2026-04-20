import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:neosapien_share/features/identity/identity_provider.dart';
import 'package:neosapien_share/features/identity/identity_repository.dart';
import 'package:neosapien_share/features/identity/identity_state.dart';
import 'package:neosapien_share/features/receive/incoming_transfers_provider.dart';
import 'package:neosapien_share/domain/entities/incoming_transfer.dart';
import 'package:neosapien_share/main.dart';

void main() {
  testWidgets('app boots with provider scope', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          identityRepositoryProvider.overrideWithValue(
            _FakeIdentityRepository(),
          ),
          incomingTransfersProvider.overrideWith(
            () => _FakeIncomingTransfersNotifier(),
          ),
        ],
        child: const NeoSapienShareApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NeoSapienShareApp), findsOneWidget);
  });
}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeIdentityRepository implements IdentityRepository {
  @override
  Future<IdentityState> ensureIdentity({bool forceRefresh = false}) async {
    return const IdentityState(shortCode: 'TEST42', localUuid: 'local-uuid');
  }

  @override
  Future<void> refreshFcmToken(String shortCode) async {}
}

class _FakeIncomingTransfersNotifier
    extends StreamNotifier<List<IncomingTransfer>>
    implements IncomingTransfersNotifier {
  @override
  Stream<List<IncomingTransfer>> build() => Stream.value([]);
}
