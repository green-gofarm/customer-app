import 'dart:convert';
import 'package:customer_app/models/activity_model.dart';

class BookingActivityItem {
  final int price;
  final int orderId;
  final int activityId;
  final DateTime date;
  final int status;
  final DateTime createdDate;
  final ActivityModel activity;

  BookingActivityItem({
    required this.price,
    required this.orderId,
    required this.activityId,
    required this.date,
    required this.status,
    required this.createdDate,
    required this.activity,
  });

  factory BookingActivityItem.fromJson(Map<String, dynamic> json) {
    return BookingActivityItem(
      price: json['price'],
      orderId: json['orderId'],
      activityId: json['activityId'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      activity: ActivityModel.fromJson(json['activity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'orderId': orderId,
      'activityId': activityId,
      'date': date.toIso8601String(),
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'activity': activity.toJson(),
    };
  }

  String toRawJson() => json.encode(toJson());
  factory BookingActivityItem.fromRawJson(String str) =>
      BookingActivityItem.fromJson(json.decode(str));
}
