// utils/time_formatter.dart
String formatMessageTime(String timeString) {
  try {
    final dateTime = DateTime.parse(timeString);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return timeString;
  }
}