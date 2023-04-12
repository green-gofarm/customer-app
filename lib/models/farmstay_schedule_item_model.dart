import 'package:customer_app/utils/enum/schedule_item_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

class FarmstayScheduleItemModel {
  final int totalItem;
  final int availableItem;
  final bool available;
  final String state;
  final bool readyForSell;
  final String itemName;
  final int itemId;
  final FarmstayItemType itemType;

  FarmstayScheduleItemModel({
    required this.totalItem,
    required this.availableItem,
    required this.available,
    required this.state,
    required this.readyForSell,
    required this.itemName,
    required this.itemId,
    required this.itemType,
  });

  factory FarmstayScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return FarmstayScheduleItemModel(
      totalItem: json['totalItem'],
      availableItem: json['availableItem'],
      available: json['available'],
      state: json['state'],
      readyForSell: json['readyForSell'],
      itemName: json['itemName'],
      itemId: json['itemId'],
      itemType: FarmstayItemTypeExtension.parse(json['itemType']) ?? FarmstayItemType.ACTIVITY,
    );
  }

  Widget getStatusString(DateTime date, {int? size}) {
    if (date.isBefore(DateTime.now())) {
      return Text("Ngưng bán", style: secondaryTextStyle(size: size));
    }
    return available
        ?    Text("Còn lượt", style: primaryTextStyle(size: size))
        :    Text("Hết chổ", style: secondaryTextStyle(size: size));
  }
}