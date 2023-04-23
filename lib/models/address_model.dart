import 'dart:convert';

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

  factory AddressModel.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);

    return AddressModel(
      country: json['country'],
      province: ProvinceModel.fromJson(json['province']),
      district: DistrictModel.fromJson(json['district']),
      ward: WardModel.fromJson(json['ward']),
      detail: json['detail'],
    );
  }

  @override
  String toString() {
    return '${detail ?? ''}, ${ward?.name ?? ''}, ${district?.name ?? ''}, ${province?.name ?? ''}, ${country ?? ''}';
  }
}

class ProvinceModel {
  final int code;
  final String name;

  ProvinceModel({required this.code, required this.name});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
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
