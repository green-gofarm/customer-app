import 'package:customer_app/models/address_model.dart';
import 'package:customer_app/models/image_model.dart';
import 'package:customer_app/models/location_model.dart';

class FarmstayModel {
  final int? id;
  final String? name;
  final String? description;
  final LocationModel? location;
  final AddressModel? address;
  final double? rating;
  final int? hostId;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final ImagesModel? images;
  final int? status;

  FarmstayModel({
    this.id,
    this.name,
    this.description,
    this.location,
    this.address,
    this.rating,
    this.hostId,
    this.createdDate,
    this.updatedDate,
    this.images,
    this.status,
  });

  factory FarmstayModel.fromJson(Map<String, dynamic> json) {
    return FarmstayModel(
      id: json['id'],
      name: json['name'] ?? "NO_NAME",
      description: json['description'] ?? "Chưa có mô tả",
      location: json['location'] != null ? LocationModel.fromJson(json['location']): null,
      address: json['address'] != null ? AddressModel.fromJson(json['address']): null,
      rating: json['rating'],
      hostId: json['hostId'],
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']): null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']): null,
      images: json['images'] != null ? ImagesModel.fromJson(json['images']) : null,
      status: json['status'],
    );
  }
}
