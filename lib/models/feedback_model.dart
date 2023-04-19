class FeedbackModel {
  final int id;
  final int rating;
  final String? attachments;
  final String comment;
  final int? repliedFeedbackId;
  final int hostId;
  final int customerId;
  final int orderId;
  final int? type;
  final int status;
  final DateTime createdDate;
  final DateTime? updatedDate;

  FeedbackModel({
    required this.id,
    required this.rating,
    this.attachments,
    required this.comment,
    this.repliedFeedbackId,
    required this.hostId,
    required this.customerId,
    required this.orderId,
    this.type,
    required this.status,
    required this.createdDate,
    this.updatedDate,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      rating: json['rating'],
      attachments: json['attachments'],
      comment: json['comment'],
      repliedFeedbackId: json['repliedFeedbackId'],
      hostId: json['hostId'],
      customerId: json['customerId'],
      orderId: json['orderId'],
      type: json['type'],
      status: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }
}
