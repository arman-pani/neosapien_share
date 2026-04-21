import 'package:flutter/material.dart';
import '../../../../shared/utils/file_util.dart';
import '../../providers/file_selection_state.dart';

class SelectedFilesList extends StatelessWidget {
  const SelectedFilesList({
    super.key,
    required this.selectedFiles,
    required this.onRemoveFile,
  });

  final List<SelectedSendFile> selectedFiles;
  final Function(int) onRemoveFile;

  @override
  Widget build(BuildContext context) {
    if (selectedFiles.isEmpty) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file_rounded, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No files selected',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: selectedFiles.length,
        itemBuilder: (context, index) {
          final file = selectedFiles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFF0F0F0)),
              ),
              child: ListTile(
                leading: _FileIcon(mimeType: file.mimeType),
                title: Text(
                  file.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${formatBytes(file.sizeInBytes)} • ${file.mimeType}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                  tooltip: 'Remove',
                  onPressed: () => onRemoveFile(index),
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FileIcon extends StatelessWidget {
  const _FileIcon({required this.mimeType});
  final String mimeType;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    if (mimeType.startsWith('image/')) {
      icon = Icons.image_outlined;
      color = Colors.blue;
    } else if (mimeType.startsWith('video/')) {
      icon = Icons.video_library_outlined;
      color = Colors.purple;
    } else if (mimeType.startsWith('audio/')) {
      icon = Icons.audiotrack_outlined;
      color = Colors.orange;
    } else if (mimeType.contains('pdf')) {
      icon = Icons.picture_as_pdf_outlined;
      color = Colors.red;
    } else {
      icon = Icons.insert_drive_file_outlined;
      color = Colors.grey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
