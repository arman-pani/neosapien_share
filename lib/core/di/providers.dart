import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/connectivity_service.dart';

import '../../data/transfer_repository.dart';
import '../../data/remote_data_sources/transfer_remote_data_source.dart';
import '../../data/remote_data_sources/firebase_service.dart';
import '../../data/remote_data_sources/incoming_transfer_remote_data_source.dart';
import '../../data/repositories/receive_repository.dart';
import '../../domain/interfaces/transfer_repository.dart';
import '../../features/receive/notification_service.dart';
import '../router/app_router.dart';

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

final pendingResumptionsProvider = FutureProvider<List<PendingResumption>>(
  (ref) => ref.watch(transferRepositoryProvider).getPendingResumableTransfers(),
);

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
  (ref) => ReceiveRepository(dio: ref.watch(_dioProvider)),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService.instance,
);

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final appRouterProvider = Provider<GoRouter>((ref) => AppRouter.router);
