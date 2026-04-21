import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

import 'package:neosapien_share/core/router/app_router.dart';
import 'package:neosapien_share/core/services/permission_service.dart';
import 'package:neosapien_share/domain/interfaces/transfer_repository.dart';
import 'package:neosapien_share/features/identity/providers/identity_provider.dart';
import 'package:neosapien_share/features/send/providers/file_selection_state.dart';
import 'package:neosapien_share/features/send/providers/send_upload_provider.dart';

part 'file_selection_notifier.g.dart';

@riverpod
class FileSelection extends _$FileSelection {
  static const _maxFileSizeBytes = 500 * 1024 * 1024;
  static const _warnBatchSizeBytes = 1024 * 1024 * 1024;

  @override
  FileSelectionState build() {
    return const FileSelectionState();
  }

  void removeFileAt(int index) {
    state = state.copyWith(
      selectedFiles: List<SelectedSendFile>.from(state.selectedFiles)..removeAt(index),
    );
  }

  Future<void> pickFiles(BuildContext context) async {
    final status = await _checkMediaPermissions(context);
    if (!status) return;

    state = state.copyWith(isPickingFiles: true, messages: []);

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        withData: false,
      );

      if (result == null) return;

      final nextFiles = List<SelectedSendFile>.from(state.selectedFiles);
      final nextMessages = <FileSelectionMessage>[];

      for (final file in result.files) {
        if (file.size > _maxFileSizeBytes) {
          nextMessages.add(
            FileSelectionMessage(
              fileName: file.name,
              message: '${file.name} exceeds the 500 MB limit and was not added.',
              isWarning: false,
            ),
          );
          continue;
        }

        final mimeType = lookupMimeType(file.name) ?? 'application/octet-stream';
        final isZeroByte = file.size == 0;

        if (isZeroByte) {
          nextMessages.add(
            FileSelectionMessage(
              fileName: file.name,
              message: '${file.name} is empty (0 B). It can still be sent if that is intentional.',
              isWarning: true,
            ),
          );
        }

        nextFiles.add(
          SelectedSendFile(
            name: file.name,
            path: file.path,
            sizeInBytes: file.size,
            mimeType: mimeType,
            isZeroByte: isZeroByte,
          ),
        );
      }

      state = state.copyWith(
        selectedFiles: nextFiles,
        messages: nextMessages,
      );
    } finally {
      state = state.copyWith(isPickingFiles: false);
    }
  }

  Future<bool> _checkMediaPermissions(BuildContext context) async {
    final ps = PermissionService.instance;

    if (Platform.isIOS) {
      return await ps.checkAndRequest(
        context: context,
        permission: Permission.photos,
        rationaleTitle: 'Access Photos',
        rationaleMessage: 'Neosapien Share needs access to your gallery to let you pick images and videos to send.',
        permanentlyDeniedMessage: 'Photo library access is permanently denied. Please enable it in settings to pick media.',
      );
    }

    if (Platform.isAndroid) {
      final permissions = [
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ];

      for (final p in permissions) {
        final granted = await ps.checkAndRequest(
          context: context,
          permission: p,
          rationaleTitle: 'Media Access',
          rationaleMessage: 'Access to your media files is required to select files for sharing.',
          permanentlyDeniedMessage: 'Media access is denied. Please enable it in settings to select files.',
        );
        if (!granted) return false;
      }
      return true;
    }

    return true;
  }

  Future<void> startSend(BuildContext context, String recipientCode) async {
    final identityState = ref.read(identityProvider);
    final identity = identityState.valueOrNull;

    if (identity == null || state.selectedFiles.isEmpty) return;

    final transferId = const Uuid().v4();

    final uploadFiles = state.selectedFiles
        .where((f) => f.path != null)
        .map(
          (f) => TransferUploadFile(
            fileId: const Uuid().v4(),
            name: f.name,
            path: f.path!,
            sizeInBytes: f.sizeInBytes,
            mimeType: f.mimeType,
          ),
        )
        .toList();

    if (uploadFiles.isEmpty) return;

    if (!context.mounted) return;
    context.push(AppRoutes.sendProgressPath(transferId, recipientCode));

    ref.read(sendUploadProvider(transferId).notifier).startUpload(
          senderId: identity.shortCode,
          recipientCode: recipientCode,
          files: uploadFiles,
        );
  }

  int get totalBytes => state.selectedFiles.fold(0, (sum, f) => sum + f.sizeInBytes);
  bool get totalBytesTooLarge => totalBytes > _warnBatchSizeBytes;
}
