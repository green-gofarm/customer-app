class AddressModel {
  final String? country;
  final ProvinceModel? province;
  final DistrictModel? district;
  final WardModel? ward;
  final String? detail;

  AddressModel({
    this.country,
    this.province,
    this.district,
    this.ward,
    this.detail,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      country: json['country'],
      province: ProvinceModel.fromJson(json['province']),
      district: DistrictModel.fromJson(json['district']),
      ward: WardModel.fromJson(json['ward']),
      detail: json['detail'],
    );
  }
}

class ProvinceModel {
  final String? name;
  final int? code;

  ProvinceModel({
    this.name,
    this.code,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      name: json['name'],
      code: json['code'],
    );
  }
}

class DistrictModel {
  final String? name;
  final int? code;

  DistrictModel({
    this.name,
    this.code,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      name: json['name'],
      code: json['code'],
    );
  }
}

class WardModel {
  final String? name;
  final int? code;

  WardModel({
    this.name,
    this.code,
  });

  factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
      name: json['name'],
      code: json['code'],
    );
  }
}
