import 'package:customer_app/models/image_model.dart';

class ActivityModel {
  final int id;
  final int farmstayId;
  final String? description;
  final int price;
  final ImagesModel images;
  final int status;
  final int slot;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String name;
  final int? bookingCount;
  final List<int>? tags;

  ActivityModel(
      {required this.id,
      required this.farmstayId,
      this.description,
      required this.price,
      required this.images,
      required this.status,
      required this.slot,
      required this.createdDate,
      this.updatedDate,
      required this.name,
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
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'])
          : null,
      name: json['name'],
      bookingCount: json['bookingCount'],
      tags: json['tags'] != null ? List<int>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmstayId': farmstayId,
      'description': description,
      'price': price,
      'images': images.toJson(),
      'status': status,
      'slot': slot,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'name': name,
      'bookingCount': bookingCount,
      'tags': tags,
    };
  }
}
