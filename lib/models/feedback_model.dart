class FeedbackModel {
  final int? id;
  final int? rating;
  final String? attachments;
  final String? comment;
  final int? repliedFeedbackId;
  final int? hostId;
  final int? customerId;
  final int? orderId;
  final int? type;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  FeedbackModel({
    this.id,
    this.rating,
    this.attachments,
    this.comment,
    this.repliedFeedbackId,
    this.hostId,
    this.customerId,
    this.orderId,
    this.type,
    this.status,
    this.createdDate,
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
      createdDate: json['createdDate'] != null && json['createdDate'] is String
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }
}
