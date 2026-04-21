import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../core/router/app_router.dart';
import '../../core/services/permission_service.dart';
import '../../domain/interfaces/transfer_repository.dart';
import '../../features/identity/identity_provider.dart';
import 'send_upload_provider.dart';

class SelectedSendFile {
  const SelectedSendFile({
    required this.name,
    required this.path,
    required this.sizeInBytes,
    required this.mimeType,
    required this.isZeroByte,
  });

  final String name;
  final String? path;
  final int sizeInBytes;
  final String mimeType;
  final bool isZeroByte;
}

class FileSelectionMessage {
  const FileSelectionMessage({
    required this.fileName,
    required this.message,
    required this.isWarning,
  });

  final String fileName;
  final String message;
  final bool isWarning;
}

final connectivityResultsProvider =
    StreamProvider.autoDispose<List<ConnectivityResult>>((ref) {
      final connectivity = Connectivity();
      return connectivity.onConnectivityChanged;
    });

class FileSelectorScreen extends ConsumerStatefulWidget {
  const FileSelectorScreen({super.key, required this.recipientCode});

  final String recipientCode;

  @override
  ConsumerState<FileSelectorScreen> createState() => _FileSelectorScreenState();
}

class _FileSelectorScreenState extends ConsumerState<FileSelectorScreen> {
  static const _maxFileSizeBytes = 500 * 1024 * 1024;
  static const _warnBatchSizeBytes = 1024 * 1024 * 1024;

  final List<SelectedSendFile> _selectedFiles = <SelectedSendFile>[];
  final List<FileSelectionMessage> _messages = <FileSelectionMessage>[];

  bool _isPickingFiles = false;

  @override
  Widget build(BuildContext context) {
    final connectivity = ref.watch(connectivityResultsProvider);
    final totalBytes = _selectedFiles.fold<int>(
      0,
      (sum, file) => sum + file.sizeInBytes,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Files')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Recipient',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.recipientCode,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  connectivity.when(
                    data: (results) =>
                        results.contains(ConnectivityResult.mobile)
                        ? const _WarningBanner(
                            message:
                                "You're on mobile data. This transfer may use significant data.",
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  if (totalBytes > _warnBatchSizeBytes) ...[
                    const SizedBox(height: 12),
                    _WarningBanner(
                      message:
                          'Selected files total ${_formatBytes(totalBytes)}. Large transfers may take longer to send.',
                    ),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _isPickingFiles ? null : _pickFiles,
                    icon: _isPickingFiles
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.attach_file_rounded),
                    label: const Text('Pick files'),
                  ),
                  if (_messages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ..._messages.map(
                      (message) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _MessageCard(message: message),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Selected files',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (_selectedFiles.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No valid files selected yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    ..._selectedFiles.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: ListTile(
                            leading: Icon(
                              _iconForMimeType(entry.value.mimeType),
                            ),
                            title: Text(entry.value.name),
                            subtitle: Text(
                              '${_formatBytes(entry.value.sizeInBytes)} • ${entry.value.mimeType}',
                            ),
                            trailing: IconButton(
                              tooltip: 'Remove file',
                              onPressed: () => _removeFileAt(entry.key),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedFiles.isEmpty ? null : _startSend,
                  child: const Text('Send'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    // Media permission check
    final status = await _checkMediaPermissions();
    if (!status) return;

    setState(() {
      _isPickingFiles = true;
      _messages.clear();
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        withData: false,
      );

      if (!mounted || result == null) {
        return;
      }

      final nextFiles = List<SelectedSendFile>.from(_selectedFiles);
      final nextMessages = <FileSelectionMessage>[];

      for (final file in result.files) {
        if (file.size > _maxFileSizeBytes) {
          nextMessages.add(
            FileSelectionMessage(
              fileName: file.name,
              message:
                  '${file.name} exceeds the 500 MB limit and was not added.',
              isWarning: false,
            ),
          );
          continue;
        }

        final mimeType =
            lookupMimeType(file.name) ?? 'application/octet-stream';
        final isZeroByte = file.size == 0;

        if (isZeroByte) {
          // We allow empty files because they may still be intentional markers
          // or placeholders the sender wants to share.
          nextMessages.add(
            FileSelectionMessage(
              fileName: file.name,
              message:
                  '${file.name} is empty (0 B). It can still be sent if that is intentional.',
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

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedFiles
          ..clear()
          ..addAll(nextFiles);
        _messages
          ..clear()
          ..addAll(nextMessages);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFiles = false;
        });
      }
    }
  }

  Future<bool> _checkMediaPermissions() async {
    final ps = PermissionService.instance;

    if (Platform.isIOS) {
      return await ps.checkAndRequest(
        context: context,
        permission: Permission.photos,
        rationaleTitle: 'Access Photos',
        rationaleMessage:
            'Neosapien Share needs access to your gallery to let you pick images and videos to send.',
        permanentlyDeniedMessage:
            'Photo library access is permanently denied. Please enable it in settings to pick media.',
      );
    }

    if (Platform.isAndroid) {
      // In a real app we'd use device_info_plus to check SDK version.
      // For this implementation, we follow the requirement to request
      // separately for Android 13+. READ_MEDIA_* permissions are handled
      // by these three Permission constants in permission_handler.
      final permissions = [
        Permission.photos, // READ_MEDIA_IMAGES
        Permission.videos, // READ_MEDIA_VIDEO
        Permission.audio,  // READ_MEDIA_AUDIO
      ];

      bool allGranted = true;
      for (final p in permissions) {
        final granted = await ps.checkAndRequest(
          context: context,
          permission: p,
          rationaleTitle: 'Media Access',
          rationaleMessage:
              'Access to your media files is required to select files for sharing.',
          permanentlyDeniedMessage:
              'Media access is denied. Please enable it in settings to select files.',
        );
        if (!granted) {
          allGranted = false;
          break;
        }
      }
      return allGranted;
    }

    return true;
  }

  void _removeFileAt(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _startSend() async {
    print('[UI] _startSend triggered');
    final identityState = ref.read(identityProvider);
    
    if (identityState.isLoading) {
      print('[UI] _startSend aborted: identity is still loading');
      return;
    }
    
    if (identityState.hasError) {
      print('[UI] _startSend aborted: identity error: ${identityState.error}');
      return;
    }

    final identity = identityState.valueOrNull;
    if (identity == null) {
      print('[UI] _startSend aborted: identity is null (no error, just null)');
      return;
    }
    
    if (_selectedFiles.isEmpty) {
      print('[UI] _startSend aborted: no files selected');
      return;
    }

    final transferId = const Uuid().v4();
    print('[UI] Starting send for $transferId with sender ${identity.shortCode}');

    // Build typed file list (filter out files with no path).
    final uploadFiles = _selectedFiles
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

    // Navigate first — the provider is keyed by transferId so it persists.
    if (!mounted) return;
    context.push(AppRoutes.sendProgressPath(transferId, widget.recipientCode));

    // Start the upload through the pre-created notifier.
    ref.read(sendUploadProvider(transferId).notifier).startUpload(
      senderId: identity.shortCode,
      recipientCode: widget.recipientCode,
      files: uploadFiles,
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.warning_amber_rounded, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final FileSelectionMessage message;

  @override
  Widget build(BuildContext context) {
    final background = message.isWarning
        ? const Color(0xFFFFF4D6)
        : const Color(0xFFFEE2E2);
    final icon = message.isWarning
        ? Icons.info_outline_rounded
        : Icons.error_outline_rounded;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconForMimeType(String mimeType) {
  if (mimeType.startsWith('image/')) {
    return Icons.image_rounded;
  }
  if (mimeType.startsWith('video/')) {
    return Icons.movie_rounded;
  }
  if (mimeType.startsWith('audio/')) {
    return Icons.music_note_rounded;
  }
  if (mimeType == 'application/pdf') {
    return Icons.picture_as_pdf_rounded;
  }
  if (mimeType.contains('zip') || mimeType.contains('compressed')) {
    return Icons.folder_zip_rounded;
  }
  if (mimeType.startsWith('text/')) {
    return Icons.description_rounded;
  }
  return Icons.insert_drive_file_rounded;
}

String _formatBytes(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  }

  final units = <String>['KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unitIndex = -1;

  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex++;
  }

  final decimals = max(0, value >= 100 ? 0 : 1);
  return '${value.toStringAsFixed(decimals)} ${units[unitIndex]}';
}
