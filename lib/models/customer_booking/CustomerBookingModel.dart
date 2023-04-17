import 'package:customer_app/models/FeeModel.dart';
import 'package:customer_app/models/customer_booking/CustomerBookingActivityItem.dart';
import 'package:customer_app/models/customer_booking/CustomerBookingRoomItem.dart';

class CustomerBookingModel {
  final int id;
  final int customerId;
  final int totalPrice;
  final int? reimbursement;
  final int status;
  final int farmstayId;
  final String farmstayName;
  final String referenceId;
  final DateTime? expiredTime;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final DateTime? checkInDate;
  final DateTime? completedDate;
  final List<CustomerBookingActivityItem> activities;
  final List<CustomerBookingRoomItem> rooms;
  final List<FeeModel> feeExtras;

  CustomerBookingModel({
    required this.farmstayName,
    required this.id,
    required this.customerId,
    required this.totalPrice,
    this.reimbursement,
    required this.status,
    required this.farmstayId,
    required this.referenceId,
    this.expiredTime,
    required this.createdDate,
    this.updatedDate,
    this.checkInDate,
    this.completedDate,
    required this.activities,
    required this.rooms,
    required this.feeExtras,
  });

  factory CustomerBookingModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> activityJson = json['activities'] ?? [];
    final List<dynamic> roomJson = json['rooms'] ?? [];
    final List<dynamic> feeExtrasJson = json['feeExtras'] ?? [];

    return CustomerBookingModel(
      farmstayName: json['farmstayName'],
      id: json['id'],
      customerId: json['customerId'],
      totalPrice: json['totalPrice'],
      reimbursement: json['reimbursement'],
      status: json['status'],
      farmstayId: json['farmstayId'],
      referenceId: json['referenceId'],
      expiredTime: json['expiredTime'] != null ? DateTime.parse(json['expiredTime']) : null,
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
      checkInDate: json['checkInDate'] != null ? DateTime.parse(json['checkInDate']) : null,
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
      activities: activityJson.map((activity) => CustomerBookingActivityItem.fromJson(activity)).toList(),
      rooms: roomJson.map((room) => CustomerBookingRoomItem.fromJson(room)).toList(),
      feeExtras: feeExtrasJson.map((fee) => FeeModel.fromJson(fee)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'totalPrice': totalPrice,
      'reimbursement': reimbursement,
      'status': status,
      'farmstayId': farmstayId,
      'farmstayName': farmstayName,
      'referenceId': referenceId,
      'expiredTime': expiredTime?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'checkInDate': checkInDate?.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'rooms': rooms.map((room) => room.toJson()).toList(),
      'feeExtras': feeExtras.map((fee) => fee.toJson()),
    };
  }
}
