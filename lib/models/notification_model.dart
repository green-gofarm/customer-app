import 'dart:convert';

class NotificationModel {
  final int? id;
  final int? userId;
  final String? header;
  final String? content;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final Map<String, dynamic>? extras;

  NotificationModel({
    this.id,
    this.userId,
    this.header,
    this.content,
    this.status,
    this.createdDate,
    this.updatedDate,
    this.extras,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      header: json['header'],
      content: json['content'],
      status: json['status'],
      createdDate: DateTime.tryParse(json['createdDate'] ?? ''),
      updatedDate: DateTime.tryParse(json['updatedDate'] ?? ''),
      extras: json['extras'] != null ? jsonDecode(json['extras']) : null,
    );
  }
}
