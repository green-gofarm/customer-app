enum NotificationStatuses { read, unread }

extension NotificationStatusesExtension on NotificationStatuses {
  int get value {
    switch (this) {
      case NotificationStatuses.read:
        return 1;
      case NotificationStatuses.unread:
        return 2;
      default:
        return 0;
    }
  }

  static NotificationStatuses fromValue(int value) {
    switch (value) {
      case 1:
        return NotificationStatuses.read;
      case 2:
        return NotificationStatuses.unread;
      default:
        return NotificationStatuses.unread;
    }
  }
}
