enum UserStatus {
  ACTIVE,
  REGISTER_PENDING,
  INACTIVE,
  BANNED,
}

extension UserStatusExtension on UserStatus {
  int get value {
    switch (this) {
      case UserStatus.ACTIVE:
        return 1;
      case UserStatus.REGISTER_PENDING:
        return 2;
      case UserStatus.INACTIVE:
        return 3;
      case UserStatus.BANNED:
        return 4;
    }
  }

  String get name {
    switch (this) {
      case UserStatus.ACTIVE:
        return "ACTIVE";
      case UserStatus.REGISTER_PENDING:
        return "REGISTER PENDING";
      case UserStatus.INACTIVE:
        return "INACTIVE";
      case UserStatus.BANNED:
        return "BANNED";
    }
  }
}

UserStatus userStatusFromValue(int value) {
  switch (value) {
    case 1:
      return UserStatus.ACTIVE;
    case 2:
      return UserStatus.REGISTER_PENDING;
    case 3:
      return UserStatus.INACTIVE;
    case 4:
      return UserStatus.BANNED;
    default:
      throw Exception("Invalid user status value: $value");
  }
}