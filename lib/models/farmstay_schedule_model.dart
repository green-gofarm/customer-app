import 'package:customer_app/models/contact_info_item_model.dart';
import 'package:customer_app/models/farmstay_schedule_item_model.dart';
import 'package:customer_app/models/address_model.dart';

class FarmstayScheduleModel {
  final int? id;
  final String? name;
  final List<ContactInfoItemModel>? contactInformation;
  final AddressModel? address;
  final int? status;
  final int? hostId;
  final String? images;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final double? latitude;
  final double? longitude;
  final Map<DateTime, List<FarmstayScheduleItemModel>>? schedule;

  FarmstayScheduleModel({
    this.id,
    this.name,
    this.contactInformation,
    this.address,
    this.status,
    this.hostId,
    this.images,
    this.createdDate,
    this.updatedDate,
    this.latitude,
    this.longitude,
    this.schedule,
  });

  factory FarmstayScheduleModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonSchedule = json['schedule'];
    Map<DateTime, List<FarmstayScheduleItemModel>> schedule = {};
    jsonSchedule.forEach((key, value) {
      List<dynamic> items = value;
      List<FarmstayScheduleItemModel> itemList = [];
      items.forEach((element) {
        itemList.add(FarmstayScheduleItemModel.fromJson(element));
      });
      DateTime dateTime = DateTime.parse(key);
      schedule[dateTime] = itemList;
    });

    List<dynamic> jsonContactInformation = json['contactInformation'];
    List<ContactInfoItemModel> contactInformation = [];
    jsonContactInformation.forEach((element) {
      contactInformation.add(ContactInfoItemModel.fromJson(element));
    });

    AddressModel address = AddressModel.fromJson(json['address']);

    return FarmstayScheduleModel(
      id: json['id'],
      name: json['name'],
      contactInformation: contactInformation,
      address: address,
      status: json['status'],
      hostId: json['hostId'],
      images: json['images'],
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']): null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']): null,
      latitude: json['latitude'],
      longitude: json['longitude'],
      schedule: schedule,
    );
  }
}
