import 'package:customer_app/utils/enum/schedule_item_status.dart';

class ScheduleItemModel {
  final int totalItem;
  final int availableItem;
  final bool available;
  final String? state;
  final bool readyForSell;

  ScheduleItemModel({
    required this.totalItem,
    required this.availableItem,
    required this.available,
    this.state,
    required this.readyForSell,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      totalItem: json['totalItem'],
      availableItem: json['availableItem'],
      available: json['available'],
      state: json['state'],
      readyForSell: json['readyForSell'],
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
