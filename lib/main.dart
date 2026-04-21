import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:neosapien_share/core/di/providers.dart';
import 'package:neosapien_share/core/router/app_router.dart';
import 'package:neosapien_share/core/theme/app_theme.dart';
import 'package:neosapien_share/data/remote_data_sources/firebase_service.dart';
import 'package:neosapien_share/features/identity/providers/identity_provider.dart';
import 'package:neosapien_share/features/receive/providers/incoming_transfers_provider.dart';
import 'package:neosapien_share/core/services/notification_service.dart';
import 'package:neosapien_share/features/receive/providers/transfer_notification_handler.dart';

/// Global key so NotificationService can show SnackBars from any context.
final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.instance.initialize();
  final prefs = await SharedPreferences.getInstance();

  // Must be called before runApp:
  //   • registers the FCM background-message handler (top-level isolate)
  //   • initialises flutter_local_notifications
  //   • processes getInitialMessage (app-killed launch)
  //   • processes pending background transfers from SharedPreferences
  await NotificationService.instance.initialize(prefs);

  NotificationService.instance.setScaffoldMessengerKey(_scaffoldMessengerKey);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const NeoSapienShareApp(),
    ),
  );
}

class NeoSapienShareApp extends ConsumerStatefulWidget {
  const NeoSapienShareApp({super.key});

  @override
  ConsumerState<NeoSapienShareApp> createState() => _NeoSapienShareAppState();
}

class _NeoSapienShareAppState extends ConsumerState<NeoSapienShareApp> {
  @override
  void initState() {
    super.initState();

    // Attach the GoRouter instance so NotificationService can navigate.
    NotificationService.instance.attachRouter(AppRouter.router);
  }

  @override
  Widget build(BuildContext context) {
    // Wire the token-refresh callback the moment identity is first resolved.
    ref.listen(identityProvider, (prev, next) {
      final shortCode = next.valueOrNull?.shortCode;
      if (shortCode == null) return;

      NotificationService.instance.setTokenRefreshCallback((token) {
        ref.read(identityRepositoryProvider).refreshFcmToken(shortCode);
      });
    });

    final router = ref.watch(appRouterProvider);

    // Eagerly start the Firestore listener and its corresponding notification
    // handler as soon as identity resolves.
    ref.watch(incomingTransfersProvider);
    ref.read(transferNotificationHandlerProvider).listen();

    return MaterialApp.router(
      title: 'NeoSapien Share',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
