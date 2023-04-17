import 'package:customer_app/models/image_model.dart';

class RoomModel {
  final int id;
  final int farmstayId;
  final String description;
  final int roomCategoryId;
  final int price;
  final ImagesModel images;
  final int status;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String name;
  final int? bookingCount;

  RoomModel({
    required this.id,
    required this.farmstayId,
    required this.description,
    required this.roomCategoryId,
    required this.price,
    required this.images,
    required this.status,
    required this.createdDate,
    this.updatedDate,
    required this.name,
    this.bookingCount,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      description: json['description'],
      roomCategoryId: json['roomCategoryId'],
      price: json['price'],
      images: ImagesModel.fromJson(json['images']),
      status: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
      name: json['name'],
      bookingCount: json['bookingCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmstayId': farmstayId,
      'description': description,
      'roomCategoryId': roomCategoryId,
      'price': price,
      'images': images.toJson(),
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'name': name,
      'bookingCount': bookingCount,
    };
  }
}
