import 'package:customer_app/models/schedule_item_model.dart';

class ActivityScheduleModel {
  final int? id;
  final int? farmstayId;
  final String? description;
  final int? price;
  final String? images;
  final int? status;
  final int? slot;
  final DateTime? createdDate;
  final String? name;
  final Map<String, ScheduleItemModel> schedule;
  final int? bookingCount;

  ActivityScheduleModel({
    this.id,
    this.farmstayId,
    this.description,
    this.price,
    this.images,
    this.status,
    this.slot,
    this.createdDate,
    this.name,
    required this.schedule,
    this.bookingCount,
  });

  factory ActivityScheduleModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonSchedule = json['schedule'];
    Map<String, ScheduleItemModel> schedule = {};
    jsonSchedule.forEach((key, value) {
      schedule[key] = ScheduleItemModel.fromJson(value);
    });

    return ActivityScheduleModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      description: json['description'],
      price: json['price'],
      images: json['images'],
      status: json['status'],
      slot: json['slot'],
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']): null,
      name: json['name'],
      schedule: schedule,
      bookingCount: json['bookingCount'],
    );
  }
}
