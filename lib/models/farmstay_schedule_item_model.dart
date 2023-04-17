import 'package:customer_app/utils/enum/schedule_item_status.dart';
import 'package:customer_app/utils/enum/farmstay_item_type.dart';

class FarmstayScheduleItemModel {
  final int totalItem;
  final int availableItem;
  final bool available;
  final String state;
  final bool readyForSell;
  final String itemName;
  final int itemId;
  final ScheduleFarmstayItemType itemType;

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
      itemType: ScheduleFarmstayItemTypeExtension.parse(json['itemType']) ??
          ScheduleFarmstayItemType.ACTIVITY,
    );
  }

  ScheduleItemStatus getStatus(DateTime date) {
    if (date.isBefore(DateTime.now())) {
      return ScheduleItemStatus.STOP_SALE;
    }
    return available
        ? ScheduleItemStatus.ON_SALE
        : ScheduleItemStatus.OUT_OF_TICKET;
  }
}
