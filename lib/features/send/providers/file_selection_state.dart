import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_selection_state.freezed.dart';

@freezed
class SelectedSendFile with _$SelectedSendFile {
  const factory SelectedSendFile({
    required String name,
    required String? path,
    required int sizeInBytes,
    required String mimeType,
    required bool isZeroByte,
  }) = _SelectedSendFile;
}

@freezed
class FileSelectionMessage with _$FileSelectionMessage {
  const factory FileSelectionMessage({
    required String fileName,
    required String message,
    required bool isWarning,
  }) = _FileSelectionMessage;
}

@freezed
class FileSelectionState with _$FileSelectionState {
  const factory FileSelectionState({
    @Default([]) List<SelectedSendFile> selectedFiles,
    @Default([]) List<FileSelectionMessage> messages,
    @Default(false) bool isPickingFiles,
  }) = _FileSelectionState;
}
