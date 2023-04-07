enum FarmstayStatus {
  DRAFT,
  PENDING,
  ACTIVE,
  INACTIVE,
}

extension FarmstayStatusExtension on FarmstayStatus {
  int get value {
    switch (this) {
      case FarmstayStatus.DRAFT:
        return 1;
      case FarmstayStatus.PENDING:
        return 2;
      case FarmstayStatus.ACTIVE:
        return 3;
      case FarmstayStatus.INACTIVE:
        return 4;
    }
  }

  String get name {
    switch (this) {
      case FarmstayStatus.DRAFT:
        return "DRAFT";
      case FarmstayStatus.PENDING:
        return "PENDING";
      case FarmstayStatus.ACTIVE:
        return "ACTIVE";
      case FarmstayStatus.INACTIVE:
        return "INACTIVE";
    }
  }
}

FarmstayStatus farmstayStatusFromValue(int value) {
  switch (value) {
    case 1:
      return FarmstayStatus.DRAFT;
    case 2:
      return FarmstayStatus.PENDING;
    case 3:
      return FarmstayStatus.ACTIVE;
    case 4:
      return FarmstayStatus.INACTIVE;
    default:
      throw Exception("Invalid farmstay status value: $value");
  }
}
