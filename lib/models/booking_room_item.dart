import 'dart:convert';
import 'package:customer_app/models/room_model.dart';

class BookingRoomItem {
  final int price;
  final int orderId;
  final int roomId;
  final DateTime date;
  final int status;
  final DateTime createdDate;
  final RoomModel room;

  BookingRoomItem({
    required this.price,
    required this.orderId,
    required this.roomId,
    required this.date,
    required this.status,
    required this.createdDate,
    required this.room,
  });

  factory BookingRoomItem.fromJson(Map<String, dynamic> json) {
    return BookingRoomItem(
      price: json['price'],
      orderId: json['orderId'],
      roomId: json['roomId'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      room: RoomModel.fromJson(json['room']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'orderId': orderId,
      'roomId': roomId,
      'date': date.toIso8601String(),
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'room': room.toJson(),
    };
  }

  String toRawJson() => json.encode(toJson());
  factory BookingRoomItem.fromRawJson(String str) =>
      BookingRoomItem.fromJson(json.decode(str));
}
