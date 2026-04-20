import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/remote_data_sources/firebase_service.dart';
import 'features/identity/identity_provider.dart';
import 'features/receive/incoming_transfers_provider.dart';
import 'features/receive/notification_service.dart';

/// Global key so NotificationService can show SnackBars from any context.
final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await File('.env').exists()) {
    await dotenv.load(fileName: '.env');
  }

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

    // Eagerly start the Firestore listener as soon as identity resolves.
    // Keeping this watched at the root ensures the provider is never disposed
    // while the app is alive.
    ref.watch(incomingTransfersProvider);

    return MaterialApp.router(
      title: 'NeoSapien Share',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
