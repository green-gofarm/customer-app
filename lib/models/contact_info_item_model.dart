class ContactInfoItemModel {
  final String? method;
  final String? value;

  ContactInfoItemModel({this.method, this.value});

  factory ContactInfoItemModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoItemModel(
      method: json['method'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'value': value,
    };
  }
}
