// utils/time_formatter.dart
String formatMessageTime(String timeString) {
  try {
    // Parse the time string as UTC
    final utcDateTime = DateTime.parse(timeString).toUtc();

    // Convert to local system time
    final localDateTime = utcDateTime.toLocal();

    // Format as HH:mm in local time
    return '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return timeString;
  }
}
