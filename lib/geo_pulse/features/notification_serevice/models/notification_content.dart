class NotificationContent {
  final String title;
  final String body;

  NotificationContent({
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "body": body,
    };
  }
}
