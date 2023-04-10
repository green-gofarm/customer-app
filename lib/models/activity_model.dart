import 'package:customer_app/models/image_model.dart';

class ActivityModel {
  final int? id;
  final int? farmstayId;
  final String? description;
  final int? price;
  final ImagesModel? images;
  final int? status;
  final int? slot;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? name;
  final int? categoryId;
  final int? bookingCount;


  ActivityModel({
    this.id,
    this.farmstayId,
    this.description,
    this.price,
    this.images,
    this.status,
    this.slot,
    this.createdDate,
    this.updatedDate,
    this.name,
    this.categoryId,
    this.bookingCount
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      description: json['description'],
      price: json['price'],
      images: json['images'] != null ? ImagesModel.fromJson(json['images']) : null,
      status: json['status'],
      slot: json['slot'],
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']): null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']): null,
      name: json['name'],
      bookingCount: json['bookingCount'],
    );
  }

}
