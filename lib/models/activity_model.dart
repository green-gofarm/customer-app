import 'package:customer_app/models/image_model.dart';

class ActivityModel {
  final int? id;
  final int farmstayId;
  final String? description;
  final int price;
  final ImagesModel images;
  final int status;
  final int slot;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? name;
  final int? categoryId;
  final int? bookingCount;
  final List<int>? tags;

  ActivityModel(
      {this.id,
      required this.farmstayId,
      this.description,
      required this.price,
      required this.images,
      required this.status,
      required this.slot,
      this.createdDate,
      this.updatedDate,
      this.name,
      this.categoryId,
      this.bookingCount,
      required this.tags});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      description: json['description'],
      price: json['price'] ?? 0,
      images: ImagesModel.fromJson(json['images']),
      status: json['status'],
      slot: json['slot'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'])
          : null,
      name: json['name'],
      bookingCount: json['bookingCount'],
      tags: json['tags'] != null ? List<int>.from(json['tags']) : null,
    );
  }
}
