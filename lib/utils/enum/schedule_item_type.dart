enum FarmstayItemType { ACTIVITY, ROOM }

extension FarmstayItemTypeExtension on FarmstayItemType {
  String get value {
    switch (this) {
      case FarmstayItemType.ACTIVITY:
        return 'ACTIVITY';
      case FarmstayItemType.ROOM:
        return 'ROOM';
      default:
        return '';
    }
  }

  static FarmstayItemType? parse(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVITY':
        return FarmstayItemType.ACTIVITY;
      case 'ROOM':
        return FarmstayItemType.ROOM;
      default:
        return null;
    }
  }
}
