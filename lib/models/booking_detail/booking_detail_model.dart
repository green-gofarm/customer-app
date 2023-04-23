import 'package:customer_app/models/booking_activity_item.dart';
import 'package:customer_app/models/booking_detail/payment_model.dart';
import 'package:customer_app/models/booking_room_item.dart';
import 'package:customer_app/models/feedback_model.dart';

class BookingDetailModel {
  final int id;
  final int customerId;
  final int totalPrice;
  final int reimbursement;
  final int status;
  final int farmstayId;
  final String referenceId;
  final DateTime expiredTime;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final DateTime checkInDate;
  final DateTime completedDate;
  final List<BookingActivityItem> activities;
  final List<BookingRoomItem> rooms;
  final int? totalPriceWithFee;
  final List<FeedbackModel> feedbacks;
  final Payment? payment;

  BookingDetailModel({
    required this.id,
    required this.customerId,
    required this.totalPrice,
    required this.reimbursement,
    required this.status,
    required this.farmstayId,
    required this.referenceId,
    required this.expiredTime,
    required this.createdDate,
    this.updatedDate,
    required this.checkInDate,
    required this.completedDate,
    required this.activities,
    required this.rooms,
    this.totalPriceWithFee,
    required this.feedbacks,
    this.payment,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> activityJson = json['activities'] ?? [];
    final List<dynamic> roomJson = json['rooms'] ?? [];
    final List<dynamic> feedbacksJson = json['feedbacks'] ?? [];

    return BookingDetailModel(
      id: json['id'],
      customerId: json['customerId'],
      totalPrice: json['totalPrice'],
      reimbursement: json['reimbursement'],
      status: json['status'],
      farmstayId: json['farmstayId'],
      referenceId: json['referenceId'],
      expiredTime: DateTime.parse(json['expiredTime']),
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
      checkInDate: DateTime.parse(json['checkInDate']),
      completedDate: DateTime.parse(json['completedDate']),
      activities: activityJson
          .map((activity) => BookingActivityItem.fromJson(activity))
          .toList(),
      rooms: roomJson.map((room) => BookingRoomItem.fromJson(room)).toList(),
      totalPriceWithFee: json['totalPriceWithFee'],
      feedbacks: feedbacksJson
          .map((feedback) => FeedbackModel.fromJson(feedback))
          .toList(),
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
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
      'referenceId': referenceId,
      'expiredTime': expiredTime.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'checkInDate': checkInDate.toIso8601String(),
      'completedDate': completedDate.toIso8601String(),
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'rooms': rooms.map((room) => room.toJson()).toList(),
      'totalPriceWithFee': totalPriceWithFee,
      'feedbacks': [],
      'payment': payment?.toJson(),
    };
  }
}
