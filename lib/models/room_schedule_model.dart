import 'package:customer_app/models/schedule_item_model.dart';
import 'package:intl/intl.dart';

class RoomScheduleModel {
  final int? id;
  final int? farmstayId;
  final String? description;
  final int? roomCategoryId;
  final int? price;
  final String? images;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? name;
  final Map<DateTime, ScheduleItemModel>? schedule;
  final int? bookingCount;

  RoomScheduleModel({
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
    this.schedule,
    this.bookingCount,
  });

  factory RoomScheduleModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonSchedule = json['schedule'];
    Map<DateTime, ScheduleItemModel> schedule = {};
    jsonSchedule.forEach((key, value) {
      DateTime dateTime = DateFormat('yyyy-MM-dd').parse(key);
      schedule[dateTime] = ScheduleItemModel.fromJson(value);
    });

    return RoomScheduleModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      description: json['description'],
      roomCategoryId: json['roomCategoryId'],
      price: json['price'],
      images: json['images'],
      status: json['status'],
      createdDate: json['createdDate'] != null && json['createdDate'] is String
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
      name: json['name'],
      schedule: schedule,
      bookingCount: json['bookingCount'],
    );
  }
}
