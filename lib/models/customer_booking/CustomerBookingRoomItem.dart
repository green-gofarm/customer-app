import 'dart:convert';

class CustomerBookingRoomItem {
  final int price;
  final int orderId;
  final int roomId;
  final DateTime date;
  final int status;
  final DateTime createdDate;
  final DateTime? updatedDate;

  CustomerBookingRoomItem({
    required this.price,
    required this.orderId,
    required this.roomId,
    required this.date,
    required this.status,
    required this.createdDate,
    this.updatedDate,
  });

  factory CustomerBookingRoomItem.fromJson(Map<String, dynamic> json) {
    return CustomerBookingRoomItem(
      price: json['price'],
      orderId: json['orderId'],
      roomId: json['roomId'],
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
      'activityId': roomId,
      'date': date.toIso8601String(),
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toJson());

  factory CustomerBookingRoomItem.fromRawJson(String str) =>
      CustomerBookingRoomItem.fromJson(json.decode(str));
}
