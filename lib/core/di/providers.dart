import 'package:dio/dio.dart';
import 'package:neosapien_share/data/transfer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:neosapien_share/core/services/connectivity_service.dart';

import 'package:neosapien_share/data/remote_data_sources/transfer_remote_data_source.dart';
import 'package:neosapien_share/data/remote_data_sources/firebase_service.dart';
import 'package:neosapien_share/data/remote_data_sources/incoming_transfer_remote_data_source.dart';
import 'package:neosapien_share/data/repositories/receive_repository.dart';
import 'package:neosapien_share/domain/interfaces/transfer_repository.dart';
import 'package:neosapien_share/core/services/notification_service.dart';
import 'package:neosapien_share/core/router/app_router.dart';

part 'providers.g.dart';

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService.instance,
);

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences must be overridden'),
);

// ---------------------------------------------------------------------------
// Firebase / core
// ---------------------------------------------------------------------------

final firebaseServiceProvider = Provider<FirebaseService>(
  (ref) => FirebaseService.instance,
);

// ---------------------------------------------------------------------------
// Upload (send) deps
// ---------------------------------------------------------------------------

final transferRemoteDataSourceProvider = Provider<TransferRemoteDataSource>(
  (ref) => const TransferRemoteDataSource(),
);

final transferRepositoryProvider = Provider<TransferRepository>(
  (ref) => FirebaseTransferRepository(
    firebaseService: ref.watch(firebaseServiceProvider),
    remoteDataSource: ref.watch(transferRemoteDataSourceProvider),
    prefs: ref.watch(sharedPreferencesProvider),
    dio: ref.watch(_dioProvider),
  ),
);

@riverpod
class PendingResumptions extends _$PendingResumptions {
  @override
  Future<List<PendingResumption>> build() {
    return ref.watch(transferRepositoryProvider).getPendingResumableTransfers();
  }
}

// ---------------------------------------------------------------------------
// Receive deps
// ---------------------------------------------------------------------------

final incomingTransferDataSourceProvider =
    Provider<IncomingTransferRemoteDataSource>(
      (ref) => IncomingTransferRemoteDataSource(
        ref.watch(firebaseServiceProvider).firestore,
      ),
    );

final _dioProvider = Provider<Dio>((ref) => Dio());

final receiveRepositoryProvider = Provider<ReceiveRepository>(
  (ref) => ReceiveRepository(
    dio: ref.watch(_dioProvider),
    dataSource: ref.watch(incomingTransferDataSourceProvider),
  ),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService.instance,
);

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final appRouterProvider = Provider<GoRouter>((ref) => AppRouter.router);
