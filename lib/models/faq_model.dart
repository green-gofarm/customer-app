class FaqModel {
  final int? id;
  final int? farmstayId;
  final String? question;
  final String? answer;
  final int? status;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  FaqModel({
    this.id,
    this.farmstayId,
    this.question,
    this.answer,
    this.status,
    this.createdDate,
    this.updatedDate,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      farmstayId: json['farmstayId'],
      question: json['question'],
      answer: json['answer'],
      status: json['status'],
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']) : null,
    );
  }
}
