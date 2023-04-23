import 'dart:convert';

import 'package:customer_app/models/FeeModel.dart';

class RefundDetail {
  final bool cancelAvailable;
  final int? fee;
  final int? refundAmount;
  final FeeModel? feeExtras;

  RefundDetail({
    required this.cancelAvailable,
    required this.fee,
    required this.refundAmount,
    required this.feeExtras,
  });

  factory RefundDetail.fromJson(Map<String, dynamic> json) {
    return RefundDetail(
        cancelAvailable: json['cancelAvailable'],
        fee: json['fee'],
        refundAmount: json['refundAmount'],
        feeExtras: json['feeExtras'] != null
            ? FeeModel.fromJson(jsonDecode(json['feeExtras']))
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'cancelAvailable': cancelAvailable,
      'fee': fee,
      'refundAmount': refundAmount,
      'feeExtras': feeExtras?.toJson(),
    };
  }
}
