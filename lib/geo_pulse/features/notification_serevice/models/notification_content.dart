class NotificationContent {
  final String title;
  final String body;
  final String? image;

  NotificationContent({
    required this.title,
    required this.body,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "body": body,
      if (image != null) "image": image,
    };
  }
}
