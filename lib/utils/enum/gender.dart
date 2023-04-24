enum Gender { male, female }

extension GenderExtension on Gender {
  int get value {
    switch (this) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 2;
    }
  }

  String get name {
    switch (this) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
      default:
        return 'Không xác định';
    }
  }

  static Gender fromValue(int value) {
    switch (value) {
      case 1:
        return Gender.male;
      case 2:
        return Gender.female;
      default:
        return Gender.male;
    }
  }
}
