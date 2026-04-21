import 'dart:math';

String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  if (bytes < 1024) return '$bytes B';

  const units = ['KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  final i = (log(bytes) / log(1024)).floor();
  final val = bytes / pow(1024, i);
  final decimals = val >= 100 ? 0 : 1;

  return '${val.toStringAsFixed(decimals)} ${units[i - 1]}';
}
