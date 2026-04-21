import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/incoming_transfer.dart';
import '../../core/router/app_router.dart';
import '../../core/services/permission_service.dart';

// ---------------------------------------------------------------------------
// FCM background handler — top-level, annotated for tree-shaking safety
// ---------------------------------------------------------------------------

/// Called by Firebase when the app is in the background OR fully terminated.
/// Must be a top-level function with @pragma('vm:entry-point').
///
/// NOTE ON ANDROID BATTERY OPTIMIZATION:
/// OEM battery killers (Xiaomi, Samsung, etc.) often prevent these background
/// isolates from waking up or may kill them mid-execution if they take too long.
/// For reliable performance, users may need to whitelist the app from
/// aggressive power management settings.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final data = message.data;
  if (data['type'] == 'incoming_transfer') {
    final transferId = data['transferId'] as String?;
    if (transferId != null && transferId.isNotEmpty) {
      // Background isolates have their own memory space. We must get a fresh
      // SharedPreferences instance to persist the ID for the main isolate to
      // pick up later.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_background_transfer', transferId);
    }
  }

  // Show local notification for system-level visibility.
  await _FcmNotificationHelper.showDataNotification(message);
}

// ---------------------------------------------------------------------------
// Internal helper called from both the background isolate and the main isolate
// ---------------------------------------------------------------------------

class _FcmNotificationHelper {
  static const _channelId = 'neosapien_incoming_transfer';
  static const _channelName = 'Incoming Transfers';
  static const _channelDescription =
      'Alerts when someone sends you files via NeoSapien Share';

  static bool _initialised = false;
  static final _plugin = FlutterLocalNotificationsPlugin();
  static int _id = 0;

  static Future<void> ensureInitialised() async {
    if (_initialised) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    _initialised = true;
  }

  /// Shows a local notification whose payload is the transferId.
  /// This is called from the background isolate (on kill/background) and
  /// also from the foreground path when we want a system-level banner.
  static Future<void> showDataNotification(RemoteMessage message) async {
    await ensureInitialised();

    final data = message.data;
    if (data['type'] != 'incoming_transfer') return;

    final transferId = data['transferId'] as String? ?? '';
    final senderCode = data['senderCode'] as String? ?? 'Unknown';
    final fileCount  = int.tryParse(data['fileCount'] ?? '0') ?? 0;
    final totalBytes = int.tryParse(data['totalBytes'] ?? '0') ?? 0;

    final title = 'Incoming transfer from $senderCode';
    final body  = fileCount == 1
        ? '1 file • ${_formatBytes(totalBytes)}'
        : '$fileCount files • ${_formatBytes(totalBytes)}';

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.show(
      _id++,
      title,
      body,
      details,
      payload: transferId, // used to deep-link on tap
    );
  }

  /// Called when the user taps a local notification in any state.
  static void _onNotificationTap(NotificationResponse response) {
    final transferId = response.payload;
    if (transferId == null || transferId.isEmpty) return;
    // The router is accessed via the global key set in NotificationService.
    NotificationService.instance._navigateToReceive(transferId);
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    const units = ['KB', 'MB', 'GB', 'TB'];
    var value = bytes.toDouble();
    var unitIndex = -1;
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    return '${value.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}

// ---------------------------------------------------------------------------
// NotificationService
// ---------------------------------------------------------------------------

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  /// Set this to the GoRouter instance after the app is initialised.
  /// Used for in-app navigation when a notification is tapped.
  GoRouter? _router;

  void attachRouter(GoRouter router) => _router = router;

  void _navigateToReceive(String transferId) {
    _router?.go(AppRoutes.receivePath(transferId));
  }

  // -------------------------------------------------------------------------
  // Initialize (call once before runApp)
  // -------------------------------------------------------------------------

  Future<void> initialize(SharedPreferences prefs) async {
    // Register background handler first — must happen before any other
    // Firebase Messaging call so it is in place for the background isolate.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _FcmNotificationHelper.ensureInitialised();

    await _FcmNotificationHelper.ensureInitialised();

    // Don't rely on FCM's own display for data-only messages — we build the
    // notification ourselves, so suppress automatic FCM foreground display.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );

    // -- Foreground ----------------------------------------------------------
    // App is open: show a SnackBar with a "tap to view" action.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // -- Background (app suspended, not killed) ------------------------------
    // The background handler already showed a local notification.
    // When the user taps it to open:
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final transferId =
          message.data['transferId'] as String?;
      if (transferId != null) _navigateToReceive(transferId);
    });

    // -- App killed ----------------------------------------------------------
    // Check if the app was launched by a tapped notification.
    await _processLaunchMessage();

    // Check SharedPreferences for data messages arrived while fully closed
    // that the user might have missed or dismissed but we still want to surface.
    await _processPendingBackgroundTransfer(prefs);

    // Token refresh: keep Firestore in sync whenever FCM rotates the token.
    FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);
  }

  /// Explicitly request notification permissions with a rationale.
  Future<bool> requestPermission(BuildContext context) async {
    return await PermissionService.instance.checkAndRequest(
      context: context,
      permission: Permission.notification,
      rationaleTitle: 'Stay Updated',
      rationaleMessage:
          'Neosapien Share needs notification permission to alert you when someone sends you files.',
      permanentlyDeniedMessage:
          'Notification permission is permanently denied. Please enable it in settings to receive transfer alerts.',
    );
  }

  // -------------------------------------------------------------------------
  // Foreground FCM — data-only message (type == 'incoming_transfer')
  // -------------------------------------------------------------------------

  /// Attaches a BuildContext-aware SnackBar listener.
  /// Call this once from [NeoSapienShareApp.build] via a [ref.listen] or
  /// directly by supplying a messenger key.
  void setScaffoldMessengerKey(GlobalKey<ScaffoldMessengerState> key) {
    _scaffoldMessengerKey = key;
  }

  GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;

  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    if (data['type'] != 'incoming_transfer') return;

    final transferId = data['transferId'] as String? ?? '';
    final senderCode = data['senderCode'] as String? ?? 'Unknown';
    final fileCount  = int.tryParse(data['fileCount'] ?? '0') ?? 0;

    final messengerState = _scaffoldMessengerKey?.currentState;
    if (messengerState != null) {
      messengerState.clearSnackBars();
      messengerState.showSnackBar(_buildIncomingTransferSnackBar(transferId, senderCode, fileCount));
      return;
    }

    // Messenger not ready — check if we can show a local notification instead.
    Permission.notification.isGranted.then((isGranted) {
      if (isGranted) {
        _FcmNotificationHelper.showDataNotification(message);
      } else {
        debugPrint('Foreground notification suppressed: Permission denied and no ScaffoldMessenger available.');
      }
    });
  }

  SnackBar _buildIncomingTransferSnackBar(String transferId, String senderCode, int fileCount) {
    return SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF1E1B4B),
        duration: const Duration(seconds: 6),
        content: Row(
          children: [
            const Icon(Icons.download_rounded, color: Color(0xFF7B6FE8)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fileCount == 1
                    ? '$senderCode sent you a file.'
                    : '$senderCode sent you $fileCount files.',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        action: transferId.isNotEmpty
            ? SnackBarAction(
                label: 'View',
                textColor: const Color(0xFF7B6FE8),
                onPressed: () => _navigateToReceive(transferId),
              )
            : null,
    );
  }

  // -------------------------------------------------------------------------
  // App-killed launch: check for an initial FCM message
  // -------------------------------------------------------------------------

  Future<void> _processLaunchMessage() async {
    // getInitialMessage returns the FCM message that launched the app from
    // a terminated state when the user tapped a notification.
    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage == null) return;

    final transferId =
        initialMessage.data['transferId'] as String?;
    if (transferId == null || transferId.isEmpty) return;

    // Delay navigation until the widget tree is mounted.
    // Using a microtask-delay is safe here because the router is set before
    // the first frame is drawn.
    await Future<void>.delayed(Duration.zero);
    _navigateToReceive(transferId);
  }

  Future<void> _processPendingBackgroundTransfer(SharedPreferences prefs) async {
    final transferId = prefs.getString('pending_background_transfer');
    if (transferId == null || transferId.isEmpty) return;

    // Clear it immediately to avoid infinite navigation loops on next launch
    await prefs.remove('pending_background_transfer');

    // Small delay to ensure GoRouter is fully ready and attached
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _navigateToReceive(transferId);
  }

  // -------------------------------------------------------------------------
  // Token refresh listener — keeps Firestore in sync
  // -------------------------------------------------------------------------

  /// The actual Firestore update is delegated back to [IdentityRepository]
  /// via a callback to avoid a circular dependency.
  void Function(String token)? _onTokenRefreshCallback;

  void setTokenRefreshCallback(void Function(String token) callback) {
    _onTokenRefreshCallback = callback;
  }

  void _onTokenRefresh(String newToken) {
    _onTokenRefreshCallback?.call(newToken);
  }

  // -------------------------------------------------------------------------
  // Show a local notification for in-app Firestore-triggered transfers
  // (called from IncomingTransfersNotifier when app is in the foreground)
  // -------------------------------------------------------------------------

  Future<void> showIncomingTransferNotification(
    IncomingTransfer transfer,
  ) async {
    final data = RemoteMessage(data: {
      'type':       'incoming_transfer',
      'transferId': transfer.transferId,
      'senderCode': transfer.senderCode,
      'fileCount':  '${transfer.files.length}',
      'totalBytes': '${transfer.totalBytes}',
    });
    await _FcmNotificationHelper.showDataNotification(data);
  }
}
