import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/enum/order_status.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Tuple2<Color, String> getBookingStatusColorAndLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.NONE:
      return Tuple2(disabledTextColor, "Không");
    case OrderStatus.PENDING_PAYMENT:
      return Tuple2(pendingTextColor, "Chờ thanh toán");
    case OrderStatus.PENDING_APPROVE:
      return Tuple2(availableTextColor, "Chờ phê duyệt");
    case OrderStatus.APPROVED:
      return Tuple2(activeTextColor, "Đã phê duyệt");
    case OrderStatus.REJECTED:
      return Tuple2(canceledTextColor, "Đã từ chối");
    case OrderStatus.DISBURSE:
      return Tuple2(finishedTextColor, "Đã kết thúc");
    case OrderStatus.FAILED:
      return Tuple2(deletedTextColor, "Thất bại");
    case OrderStatus.CUSTOMER_CANCEL:
      return Tuple2(bannedTextColor, "Khách hàng hủy");
    default:
      throw Exception('Invalid status');
  }
}