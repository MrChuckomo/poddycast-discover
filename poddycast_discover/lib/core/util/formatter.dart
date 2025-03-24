/// Format a time/duration in a format of hh:mm:ss
String formatDuration(Duration duration) {
  final hour = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$hour:$minutes:$seconds';
}
