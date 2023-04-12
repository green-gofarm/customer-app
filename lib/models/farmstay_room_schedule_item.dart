import 'package:customer_app/models/farmstay_schedule_item_model.dart';
import 'package:customer_app/models/room_model.dart';

class FarmstayRoomScheduleItem {
  final FarmstayScheduleItemModel schedule;
  final RoomModel? room;

  FarmstayRoomScheduleItem({required this.schedule, this.room});
}
