class NotificationResponse {
  final List<AppNotification> notifications;

  NotificationResponse({required this.notifications});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final list = json["view_all_app_notification_"] as List? ?? [];

    return NotificationResponse(
      notifications: list
          .map((item) => AppNotification.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "view_all_app_notification_":
      notifications.map((e) => e.toJson()).toList(),
    };
  }
}


class AppNotification {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
