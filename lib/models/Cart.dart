import 'package:customer_app/models/activity_ticket_model.dart';
import 'package:customer_app/models/image_model.dart';
import 'package:customer_app/models/room_ticket_model.dart';
import 'package:customer_app/utils/enum/farmstay_status.dart';

class Cart {
  final int totalRoom;
  final int totalRoomPrice;
  final int totalActivity;
  final int totalActivityPrice;
  final int totalPrice;
  final List<RoomTicketModel> rooms;
  final List<ActivityTicketModel> activities;
  final int farmstayId;
  final String farmstayName;
  final ImagesModel farmstayImages;
  final FarmstayStatus farmstayStatus;
  final int totalCartItem;

  Cart({
    required this.totalRoom,
    required this.totalRoomPrice,
    required this.totalActivity,
    required this.totalActivityPrice,
    required this.totalPrice,
    required this.rooms,
    required this.activities,
    required this.farmstayId,
    required this.farmstayName,
    required this.farmstayImages,
    required this.farmstayStatus,
    required this.totalCartItem,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      totalRoom: json['totalRoom'] ?? 0,
      totalRoomPrice: json['totalRoomPrice'] ?? 0,
      totalActivity: json['totalActivity'] ?? 0,
      totalActivityPrice: json['totalActivityPrice'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
      rooms: (json['rooms'] as List<dynamic>)
          .map((roomJson) => RoomTicketModel.fromJson(roomJson))
          .toList(),
      activities: (json['activities'] as List<dynamic>)
          .map((activityJson) => ActivityTicketModel.fromJson(activityJson))
          .toList(),
      farmstayId: json['farmstayId'],
      farmstayName: json['farmstayName'],
      farmstayImages: ImagesModel.fromJson(json['farmstayImages']),
      farmstayStatus: farmstayStatusFromValue(json['farmstayStatus']),
      totalCartItem: json['totalCartItem'],
    );
  }
}
