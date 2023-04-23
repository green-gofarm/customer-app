import 'dart:convert';
import 'package:customer_app/utils/enum/notification_status.dart';

class NotificationModel {
  final int id;
  final int userId;
  final String header;
  final String content;
  final NotificationStatuses status;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final Map<String, dynamic> extras;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.header,
    required this.content,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
    required this.extras,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'],
        userId: json['userId'],
        header: json['header'],
        content: json['content'],
        status: NotificationStatusesExtension.fromValue(json['status']),
        createdDate: DateTime.parse(json['createdDate']),
        updatedDate: json['updatedDate'] != null
            ? DateTime.parse(json['updatedDate'])
            : null,
        extras: Map<String, dynamic>.from(jsonDecode(json['extras'])));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'header': header,
      'content': content,
      'status': status.value,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'extras': jsonEncode(extras),
    };
  }
}
