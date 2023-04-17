import 'package:customer_app/utils/enum/tag_category_status.dart';

class TagCategoryModel {
  final int id;
  final String name;
  final TagCategoryStatuses status;
  final String description;
  final DateTime createdDate;
  final DateTime? updatedDate;

  TagCategoryModel({
    required this.id,
    required this.name,
    required this.status,
    required this.description,
    required this.createdDate,
    required this.updatedDate,
  });

  factory TagCategoryModel.fromJson(Map<String, dynamic> json) {
    return TagCategoryModel(
      id: json['id'],
      name: json['name'],
      status: TagCategoryStatusesExtension.fromValue(json['status']),
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }
}
