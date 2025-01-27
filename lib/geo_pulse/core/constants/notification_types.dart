enum NotificationTypes {
  request,
}

extension NotificationTypesExtension on NotificationTypes {
  String get getName {
    switch (this) {
      case NotificationTypes.request:
        return 'Request';
    }
  }
}
