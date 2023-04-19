class PolicyModel {
  final int id;
  final String name;
  final int? farmstayId;
  final String description;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  PolicyModel({
    required this.id,
    required this.name,
    this.farmstayId,
    required this.description,
    this.status,
    this.createdDate,
    this.updatedDate,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'],
      name: json['name'],
      farmstayId: json['farmstayId'],
      description: json['description'],
      status: json['status'],
      createdDate: json['createdDate'] != null && json['createdDate'] is String
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }
}
