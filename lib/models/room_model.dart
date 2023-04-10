import 'package:customer_app/models/image_model.dart';

class RoomModel {
  final int? id;
  final int? farmstayId;
  final String? description;
  final int? roomCategoryId;
  final int? price;
  final ImagesModel? images;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? name;
  final int? bookingCount;

  RoomModel({
    this.id,
    this.farmstayId,
    this.description,
    this.roomCategoryId,
    this.price,
    this.images,
    this.status,
    this.createdDate,
    this.updatedDate,
    this.name,
    this.bookingCount,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      description: json['description'],
      roomCategoryId: json['roomCategoryId'],
      price: json['price'],
      images: json['images'] != null ? ImagesModel.fromJson(json['images']) : null,
      status: json['status'],
      createdDate: json['createdDate'] != null && json['createdDate'] is String
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
      name: json['name'],
      bookingCount: json['bookingCount'],
    );
  }
}
