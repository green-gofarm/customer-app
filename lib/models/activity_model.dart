import 'package:customer_app/models/image_model.dart';

class ActivityModel {
  final int? id;
  final int? farmstayId;
  final String? description;
  final int? price;
  final ImagesModel? images;
  final int? status;
  final int? slot;
  final String? createdDate;
  final String? updatedDate;
  final String? name;

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
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
      name: json['name'],
    );
  }
}
