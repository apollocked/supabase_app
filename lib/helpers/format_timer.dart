String formatTime(String isoTime) {
  final dt = DateTime.parse(isoTime).toLocal();
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
