import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

enum ScheduleItemStatus {
  STOP_SALE,
  OUT_OF_TICKET,
  ON_SALE
}

Widget getScheduleItemStatusText(ScheduleItemStatus status, {int? size}) {
  switch (status) {
    case ScheduleItemStatus.STOP_SALE:
      return Text("Ngưng bán", style: secondaryTextStyle(size: size));
    case ScheduleItemStatus.OUT_OF_TICKET:
      return Text("Hết chổ", style: secondaryTextStyle(size: size));
    case ScheduleItemStatus.ON_SALE:
      return Text("Còn chỗ", style: primaryTextStyle(size: size, color: rf_primaryColor));
    default:
      return Text("Unknown", style: secondaryTextStyle(size: size));
  }
}