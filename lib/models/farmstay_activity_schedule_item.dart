import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/farmstay_schedule_item_model.dart';

class FarmstayActivityScheduleItem {
  final FarmstayScheduleItemModel schedule;
  final ActivityModel? activity;

  FarmstayActivityScheduleItem({required this.schedule, this.activity});
}
