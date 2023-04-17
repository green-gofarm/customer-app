import 'dart:convert';

class CustomerBookingActivityItem {
  final int price;
  final int orderId;
  final int activityId;
  final DateTime date;
  final int status;
  final DateTime createdDate;
  final DateTime? updatedDate;

  CustomerBookingActivityItem({
    required this.price,
    required this.orderId,
    required this.activityId,
    required this.date,
    required this.status,
    required this.createdDate,
    this.updatedDate,
  });

  factory CustomerBookingActivityItem.fromJson(Map<String, dynamic> json) {
    return CustomerBookingActivityItem(
      price: json['price'],
      orderId: json['orderId'],
      activityId: json['activityId'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
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
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toJson());
  factory CustomerBookingActivityItem.fromRawJson(String str) =>
      CustomerBookingActivityItem.fromJson(json.decode(str));
}
