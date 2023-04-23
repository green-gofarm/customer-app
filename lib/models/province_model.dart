class Province {
  String name;
  int code;
  String divisionType;
  String codename;
  int phoneCode;
  List<dynamic> districts;

  Province({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.codename,
    required this.phoneCode,
    required this.districts,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      name: json['name'],
      code: json['code'],
      divisionType: json['division_type'],
      codename: json['codename'],
      phoneCode: json['phone_code'],
      districts: json['districts'],
    );
  }
}
