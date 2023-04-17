enum ScheduleFarmstayItemType { ACTIVITY, ROOM }

extension ScheduleFarmstayItemTypeExtension on ScheduleFarmstayItemType {
  String get value {
    switch (this) {
      case ScheduleFarmstayItemType.ACTIVITY:
        return 'ACTIVITY';
      case ScheduleFarmstayItemType.ROOM:
        return 'ROOM';
      default:
        return '';
    }
  }

  static ScheduleFarmstayItemType? parse(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVITY':
        return ScheduleFarmstayItemType.ACTIVITY;
      case 'ROOM':
        return ScheduleFarmstayItemType.ROOM;
      default:
        return null;
    }
  }
}
