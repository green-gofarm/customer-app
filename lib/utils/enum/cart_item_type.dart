enum CartItemType {
  ROOM,
  ACTIVITY,
}

extension CartItemTypeExtension on CartItemType {
  int get code {
    switch (this) {
      case CartItemType.ROOM:
        return 1;
      case CartItemType.ACTIVITY:
        return 2;
      default:
        throw Exception('Unknown CartItemType');
    }
  }

  static CartItemType? fromValue(int? value) {
    switch (value) {
      case 1:
        return CartItemType.ROOM;
      case 2:
        return CartItemType.ACTIVITY;
      default:
        return null;
    }
  }
}
