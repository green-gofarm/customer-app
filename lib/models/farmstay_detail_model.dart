
import 'dart:convert';

import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/address_model.dart';
import 'package:customer_app/models/contact_info_item_model.dart';
import 'package:customer_app/models/faq_model.dart';
import 'package:customer_app/models/feedback_model.dart';
import 'package:customer_app/models/image_model.dart';
import 'package:customer_app/models/policy_model.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:customer_app/models/service_model.dart';
import 'package:customer_app/models/user_model.dart';

class FarmstayDetailModel {
  final int id;
  final String name;
  final String? description;
  final List<ContactInfoItemModel> contactInformation;
  final AddressModel address;
  final int status;
  final int hostId;
  final ImagesModel images;
  final DateTime createdDate;
  final DateTime updatedDate;
  final List<PolicyModel> policies;
  final List<ServiceModel> services;
  final List<RoomModel> rooms;
  final List<ActivityModel> activities;
  final List<FaqModel> faqs;
  final UserModel host;
  final List<FeedbackModel> feedbacks;
  final double rating;
  final double latitude;
  final double longitude;

  FarmstayDetailModel({
    required this.id,
    required this.name,
    this.description,
    required this.contactInformation,
    required this.address,
    required this.status,
    required this.hostId,
    required this.images,
    required this.createdDate,
    required this.updatedDate,
    required this.policies,
    required this.services,
    required this.rooms,
    required this.activities,
    required this.faqs,
    required this.host,
    required this.feedbacks,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });

  factory FarmstayDetailModel.fromJson(Map<String, dynamic> json) {
    var contacts = jsonDecode(json['contactInformation']) as List;
    List<ContactInfoItemModel> contactInformationList =
        contacts.map((i) => ContactInfoItemModel.fromJson(i)).toList();

    return FarmstayDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      contactInformation: contactInformationList,
      address: AddressModel.fromJson(json['address']),
      status: json['status'],
      hostId: json['hostId'],
      images: json['images'] != null && json['images'] is String
          ? ImagesModel.fromJson(json['images'])
          : ImagesModel(avatar: "", others: []),
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      policies: List<PolicyModel>.from(
          json['policies'].map((x) => PolicyModel.fromJson(x))),
      services: List<ServiceModel>.from(
          json['services'].map((x) => ServiceModel.fromJson(x))),
      rooms:
          List<RoomModel>.from(json['rooms'].map((x) => RoomModel.fromJson(x))),
      activities: List<ActivityModel>.from(
          json['activities'].map((x) => ActivityModel.fromJson(x))),
      faqs: List<FaqModel>.from(json['faqs'].map((x) => FaqModel.fromJson(x))),
      host: UserModel.fromJson(json['host']),
      feedbacks: List<FeedbackModel>.from(
          json['feedbacks'].map((x) => FeedbackModel.fromJson(x))),
      rating: json['rating'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
