enum TagCategoryStatuses {
  ACTIVE,
  INACTIVE,
}

extension TagCategoryStatusesExtension on TagCategoryStatuses {
  int get value {
    switch (this) {
      case TagCategoryStatuses.ACTIVE:
        return 1;
      case TagCategoryStatuses.INACTIVE:
        return 2;
    }
  }

  static TagCategoryStatuses fromValue(int value) {
    switch (value) {
      case 1:
        return TagCategoryStatuses.ACTIVE;
      case 2:
        return TagCategoryStatuses.INACTIVE;
      default:
        throw ArgumentError('Invalid value for TagCategoryStatuses enum: $value');
    }
  }
}