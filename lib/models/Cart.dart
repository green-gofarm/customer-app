import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/room_model.dart';

class Cart {
  int totalRoom;
  int totalRoomPrice;
  int totalActivity;
  int totalActivityPrice;
  int totalPrice;
  List<RoomModel> rooms;
  List<ActivityModel> activities;

  Cart({
    required this.totalRoom,
    required this.totalRoomPrice,
    required this.totalActivity,
    required this.totalActivityPrice,
    required this.totalPrice,
    required this.rooms,
    required this.activities,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      totalRoom: json['totalRoom'] ?? 0,
      totalRoomPrice: json['totalRoomPrice'] ?? 0,
      totalActivity: json['totalActivity'] ?? 0,
      totalActivityPrice: json['totalActivityPrice'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
      rooms: (json['rooms'] as List<dynamic>)
          .map((roomJson) => RoomModel.fromJson(roomJson))
          .toList(),
      activities: (json['activities'] as List<dynamic>)
          .map((activityJson) => ActivityModel.fromJson(activityJson))
          .toList(),
    );
  }
}