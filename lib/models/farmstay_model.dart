import 'package:customer_app/models/image_model.dart';
import 'package:customer_app/models/location_model.dart';

class FarmstayModel {
  final int? id;
  final String? name;
  final LocationModel? location;
  final String? address;
  final double? rating;
  final int? hostId;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final ImagesModel? images;
  final int? status;

  FarmstayModel({
    this.id,
    this.name,
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
      name: json['name'],
      location: json['location'] != null ? LocationModel.fromJson(json['location']): null,
      address: json['address'],
      rating: json['rating'],
      hostId: json['hostId'],
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']): null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']): null,
      images: json['images'] != null ? ImagesModel.fromJson(json['images']) : null,
      status: json['status'],
    );
  }
}
