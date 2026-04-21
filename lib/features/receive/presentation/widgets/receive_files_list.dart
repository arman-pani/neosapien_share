import 'package:flutter/material.dart';
import 'package:neosapien_share/data/remote_data_sources/incoming_transfer_remote_data_source.dart';
import 'package:neosapien_share/features/receive/providers/receive_download_provider.dart';
import '../../../../shared/widgets/transfer_file_tile.dart';

class ReceiveFilesList extends StatelessWidget {
  const ReceiveFilesList({super.key, required this.state});

  final ReceiveDownloadState state;

  @override
  Widget build(BuildContext context) {
    final transfer = state.transfer;
    if (transfer == null) return const SizedBox.shrink();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: transfer.files.length,
      itemBuilder: (context, index) {
        final f = transfer.files[index];
        final progress = state.perFileProgress[f.fileId];
        final status = state.perFileStatus[f.fileId];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TransferFileTile(
            fileName: f.name,
            fileSize: f.size,
            mimeType: f.mimeType,
            progress: progress ?? 0.0,
            status: _mapStatus(status),
            isUpload: false,
            onTap: status == FileDownloadStatus.done
                ? () {
                    /* TODO: Open file? */
                  }
                : null,
          ),
        );
      },
    );
  }

  TransferFileStatus _mapStatus(FileDownloadStatus? s) => switch (s) {
    FileDownloadStatus.done => TransferFileStatus.done,
    FileDownloadStatus.corrupt => TransferFileStatus.corrupt,
    FileDownloadStatus.failed => TransferFileStatus.failed,
    FileDownloadStatus.verifying => TransferFileStatus.verifying,
    FileDownloadStatus.downloading => TransferFileStatus.active,
    _ => TransferFileStatus.pending,
  };
}
