import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../../features/identity/identity_loading_screen.dart';
import '../../features/identity/presentation/home_screen.dart';
import '../../features/send/file_selector_screen.dart';
import '../../features/send/presentation/send_screen.dart';
import '../../features/send/send_progress_screen.dart';
import '../../features/receive/presentation/receive_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const loading      = '/';
  static const home         = '/home';
  static const send         = '/send';
  static const fileSelector = '/send/select/:recipientCode';
  static const sendProgress = '/send/progress/:transferId/:recipientCode';
  static const receive      = '/receive/:transferId';

  static String fileSelectorPath(String recipientCode) =>
      '/send/select/$recipientCode';

  static String sendProgressPath(String transferId, String recipientCode) =>
      '/send/progress/$transferId/$recipientCode';

  static String receivePath(String transferId) => '/receive/$transferId';
}

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.loading,
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: IdentityLoadingScreen(title: AppConstants.appName),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: HomeScreen(title: AppConstants.appName),
        ),
      ),
      GoRoute(
        path: AppRoutes.send,
        pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: SendScreen(title: 'Send Files'),
        ),
      ),
      GoRoute(
        path: AppRoutes.fileSelector,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          child: FileSelectorScreen(
            recipientCode: state.pathParameters['recipientCode'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.sendProgress,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          child: SendProgressScreen(
            transferId:    state.pathParameters['transferId']    ?? '',
            recipientCode: state.pathParameters['recipientCode'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.receive,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          child: ReceiveScreen(
            transferId: state.pathParameters['transferId'] ?? '',
          ),
        ),
      ),
    ],
  );
}
