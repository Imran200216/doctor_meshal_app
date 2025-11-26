extension TimeFormatExtension on String {
  String toChatTimeFormat() {
    try {
      final utcTime = DateTime.parse(this);
      final localTime = utcTime.toLocal();
      final now = DateTime.now();

      if (localTime.year == now.year &&
          localTime.month == now.month &&
          localTime.day == now.day) {
        return '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
      } else {
        return '${localTime.day}/${localTime.month}/${localTime.year}';
      }
    } catch (e) {
      return this;
    }
  }
}