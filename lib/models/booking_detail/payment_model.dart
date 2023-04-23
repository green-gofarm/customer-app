import 'dart:convert';

import 'package:customer_app/models/FeeModel.dart';

class Payment {
  final int id;
  final int amount;
  final int orderId;
  final int status;
  final int fee;
  final int type;
  final String? extras;
  final List<FeeModel> feeExtras;
  final DateTime paymentDate;
  final DateTime createdDate;
  final DateTime? updatedDate;

  Payment({
    required this.id,
    required this.amount,
    required this.orderId,
    required this.status,
    required this.fee,
    required this.type,
    required this.feeExtras,
    required this.paymentDate,
    required this.createdDate,
    this.updatedDate,
    this.extras,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    final List<dynamic> extrasJson =
        json['feeExtras'] != null ? jsonDecode(json['feeExtras']) : [];

    return Payment(
      id: json['id'],
      amount: json['amount'],
      orderId: json['orderId'],
      status: json['status'],
      fee: json['fee'],
      type: json['type'],
      extras: json['extras'],
      feeExtras: extrasJson.map((fee) => FeeModel.fromJson(fee)).toList(),
      paymentDate: DateTime.parse(json['paymentDate']),
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null && json['updatedDate'] is String
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'orderId': orderId,
      'status': status,
      'fee': fee,
      'feeExtras': feeExtras,
      'type': type,
      'extras': extras,
      'paymentDate': paymentDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }
}
