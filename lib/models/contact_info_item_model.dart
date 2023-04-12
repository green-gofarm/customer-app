class ContactInfoItemModel {
  final String method;
  final String value;

  ContactInfoItemModel({required this.method, required this.value});

  factory ContactInfoItemModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoItemModel(
      method: json['method'] ?? "",
      value: json['value'] ?? "",
    );
  }
}
