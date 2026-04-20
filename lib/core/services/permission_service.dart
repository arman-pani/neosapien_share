import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  /// Checks and requests a permission with a rationale dialog first if needed.
  /// If the permission was permanently denied, it shows a dialog to open settings.
  Future<bool> checkAndRequest({
    required BuildContext context,
    required Permission permission,
    required String rationaleTitle,
    required String rationaleMessage,
    required String permanentlyDeniedMessage,
  }) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isLimited) {
      // iOS limited access (e.g. some photos)
      return true;
    }

    if (!context.mounted) return false;

    // Show rationale before the system prompt.
    // If the permission has never been requested, we still show the rationale
    // to explain why we are about to ask.
    final proceed = await showRationaleDialog(
      context: context,
      title: rationaleTitle,
      message: rationaleMessage,
    );

    if (!proceed || !context.mounted) return false;

    final newStatus = await permission.request();

    if (newStatus.isGranted || newStatus.isLimited) {
      return true;
    }

    if (newStatus.isPermanentlyDenied && context.mounted) {
      await showPermanentlyDeniedDialog(
        context: context,
        message: permanentlyDeniedMessage,
      );
      return false;
    }

    return false;
  }

  /// Shows a rationale dialog.
  Future<bool> showRationaleDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await showCupertinoDialog<bool>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(ctx, false),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Continue'),
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
            ),
          ) ??
          false;
    }

    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Shows a dialog explaining that the permission is permanently denied
  /// and offers to open settings.
  Future<void> showPermanentlyDeniedDialog({
    required BuildContext context,
    required String message,
  }) async {
    final openSettings = await (Platform.isIOS || Platform.isMacOS
        ? showCupertinoDialog<bool>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: const Text('Permission Required'),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Not Now'),
                  onPressed: () => Navigator.pop(ctx, false),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Open Settings'),
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
            ),
          )
        : showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Permission Required'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Not Now'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          ));

    if (openSettings == true) {
      await openAppSettings();
    }
  }
}
