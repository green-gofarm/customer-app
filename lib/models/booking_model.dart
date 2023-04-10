class BookingModel {
  final int? id;
  final int? customerId;
  final int? totalPrice;
  final int? reimbursement;
  final int? status;
  final int? farmstayId;
  final String? referenceId;
  final DateTime? expiredTime;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final DateTime? checkInDate;
  final DateTime? completedDate;

  BookingModel({
    this.id,
    this.customerId,
    this.totalPrice,
    this.reimbursement,
    this.status,
    this.farmstayId,
    this.referenceId,
    this.expiredTime,
    this.createdDate,
    this.updatedDate,
    this.checkInDate,
    this.completedDate,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      customerId: json['customerId'],
      totalPrice: json['totalPrice'],
      reimbursement: json['reimbursement'],
      status: json['status'],
      farmstayId: json['farmstayId'],
      referenceId: json['referenceId'],
      expiredTime: json['expiredTime'] != null ? DateTime.parse(json['expiredTime']) : null,
      createdDate: json['createdDate'] != null && json['createdDate'] is String
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
      checkInDate: json['checkInDate'] != null ? DateTime.parse(json['checkInDate']) : null,
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
    );
  }
}
