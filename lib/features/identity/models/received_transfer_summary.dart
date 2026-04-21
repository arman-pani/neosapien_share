class ReceivedTransferSummary {
  const ReceivedTransferSummary({
    required this.id,
    required this.fileName,
    required this.sizeInBytes,
    required this.status,
  });

  final String id;
  final String fileName;
  final int sizeInBytes;
  final String status;
}
