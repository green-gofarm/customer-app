import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/farmstay_activity_schedule_item.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:customer_app/models/farmstay_room_schedule_item.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:customer_app/screens/ActivityDetailScreen.dart';
import 'package:customer_app/screens/RoomDetailScreen.dart';
import 'package:customer_app/store/farmstay_schedule/farmstay_schedule_store.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/schedule_item_status.dart';
import 'package:customer_app/utils/enum/farmstay_item_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'HorizontalCalendarComponent.dart';

class FarmstayScheduleComponent extends StatefulWidget {
  final FarmstayDetailModel farmstay;
  final VoidCallback refresh;

  final GlobalKey<FarmstayScheduleComponentState> key;

  FarmstayScheduleComponent(
      {required this.farmstay, required this.refresh, required this.key})
      : super(key: key);

  @override
  FarmstayScheduleComponentState createState() =>
      FarmstayScheduleComponentState();
}

class FarmstayScheduleComponentState extends State<FarmstayScheduleComponent> {
  FarmstayScheduleStore store = FarmstayScheduleStore();

  DateTime selectedDate = DateTimeUtil.getTomorrow();

  List<FarmstayActivityScheduleItem> activityScheduleList = [];
  List<FarmstayRoomScheduleItem> roomScheduleList = [];

  void clearSchedule() {
    activityScheduleList = [];
    roomScheduleList = [];
  }

  RoomModel? getRoomById(List<RoomModel> rooms, int itemId) {
    for (RoomModel room in rooms) {
      if (room.id == itemId) {
        return room;
      }
    }

    return null;
  }

  ActivityModel? getActivityById(List<ActivityModel> activities, int itemId) {
    for (ActivityModel activity in activities) {
      if (activity.id == itemId) {
        return activity;
      }
    }

    return null;
  }

  void handleGetScheduleItems(DateTime selectedDate) {
    clearSchedule();
    if (store.farmstaySchedule!.schedule == null) {
      return;
    }

    final scheduleList = store.farmstaySchedule!
        .schedule![DateFormat("yyyy-MM-dd").format(selectedDate)];

    if (scheduleList == null) {
      logger.i("Schedule list is null");
      logger
          .i("Selected date: ${DateFormat("yyyy-MM-dd").format(selectedDate)}");
      logger.i("Schedule map: ${store.farmstaySchedule!.schedule.toString()}");
      return;
    }

    activityScheduleList = List.from(scheduleList
        .where((item) => item.itemType == ScheduleFarmstayItemType.ACTIVITY)
        .map((item) => FarmstayActivityScheduleItem(
              schedule: item,
              activity: widget.farmstay.activities.length > 0
                  ? getActivityById(widget.farmstay.activities, item.itemId)
                  : null,
            ))
        .where((element) => element.activity != null)
        .toList());

    roomScheduleList = List.from(scheduleList
        .where((item) => item.itemType == ScheduleFarmstayItemType.ROOM)
        .map((item) => FarmstayRoomScheduleItem(
              schedule: item,
              room: widget.farmstay.rooms.length > 0
                  ? getRoomById(widget.farmstay.rooms, item.itemId)
                  : null,
            ))
        .where((element) => element.room != null)
        .toList());

    logger.i("Activity ${activityScheduleList.length}");
    logger.i("Room ${roomScheduleList.length}");
  }

  Future<void> handleDateSelected(DateTime selectedDate) async {
    setState(() {
      this.selectedDate = selectedDate;
    });
    await store.getFarmstaySchedule(
        farmstayId: widget.farmstay.id, date: selectedDate);
    setState(() {
      handleGetScheduleItems(selectedDate);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await refresh();
  }

  Future<void> refresh() async {
    await store.getFarmstaySchedule(
        farmstayId: widget.farmstay.id, date: selectedDate);
    setState(() {
      handleGetScheduleItems(selectedDate);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.height,
          HorizontalCalendarComponent(
              onDateSelected: handleDateSelected, selectedDate: selectedDate),
          8.height,
          Text('Hoạt động', style: boldTextStyle()).paddingLeft(4),
          8.height,
          _buildListActivities(),
          Text('Phòng ở', style: boldTextStyle()).paddingLeft(4),
          8.height,
          _buildListRooms(),
        ],
      ),
    ).paddingAll(0);
  }

  Widget _buildListActivities() {
    final availableList =
        activityScheduleList.where((element) => element.activity != null);
    return availableList.length < 1
        ? Text("Không có hoạt động trong ngày.",
                style: secondaryTextStyle(fontStyle: FontStyle.italic))
            .paddingBottom(8.0)
        : ListView.builder(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: activityScheduleList.length,
            itemBuilder: (context, index) {
              return ActivityFragment(context,
                  item: activityScheduleList[index], date: selectedDate);
            },
          );
  }

  Widget _buildListRooms() {
    final availableList =
        roomScheduleList.where((element) => element.room != null);
    return availableList.length < 1
        ? Text("Không có phòng trống trong ngày.",
                style: secondaryTextStyle(fontStyle: FontStyle.italic))
            .paddingBottom(8.0)
        : ListView.builder(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: roomScheduleList.length,
            itemBuilder: (context, index) {
              return RoomFragment(context,
                  item: roomScheduleList[index], date: selectedDate);
            },
          );
  }

  Widget RoomFragment(BuildContext context,
      {required FarmstayRoomScheduleItem item, required DateTime date}) {
    final room = item.room!;

    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(4.0),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: Color(0xFFf7f7f7),
        borderRadius: radius(4.0),
      ),
      child: Row(
        children: [
          4.width,
          rfCommonCachedNetworkImage(
            (room.images.avatar).validate(),
            fit: BoxFit.cover,
            height: 44,
            width: 60,
          ).cornerRadiusWithClipRRect(2.0),
          10.width,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name.validate(), style: boldTextStyle()),
                  8.height,
                  getScheduleItemStatusText(item.schedule.getStatus(date),
                      size: 12),
                ],
              ),
            ],
          ).expand(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              32.height,
              Icon(Icons.keyboard_arrow_right,
                  color: Colors.grey.shade400, size: 18),
              8.height,
            ],
          ),
          8.width,
        ],
      ),
    ).onTap(() {
      RoomDetailScreen(
        farmstayId: room.farmstayId,
        roomId: room.id,
        defaultDatetime: selectedDate,
        onBack: widget.refresh,
      ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
    });
  }

  Widget ActivityFragment(BuildContext context,
      {required FarmstayActivityScheduleItem item, required DateTime date}) {
    final activity = item.activity;

    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(4.0),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: Color(0xFFf7f7f7),
        borderRadius: radius(4.0),
      ),
      child: Row(
        children: [
          4.width,
          rfCommonCachedNetworkImage(
            (item.activity!.images.avatar).validate(),
            fit: BoxFit.cover,
            height: 44,
            width: 60,
          ).cornerRadiusWithClipRRect(4.0),
          10.width,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity!.name.validate(), style: boldTextStyle()),
                  8.height,
                  getScheduleItemStatusText(item.schedule.getStatus(date),
                      size: 12),
                ],
              ),
            ],
          ).expand(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              32.height,
              Icon(Icons.keyboard_arrow_right,
                  color: Colors.grey.shade400, size: 18),
              8.height,
            ],
          ),
          8.width,
        ],
      ),
    ).onTap(() {
      ActivityDetailScreen(
        farmstayId: activity.farmstayId,
        activityId: activity.id,
        defaultDatetime: selectedDate,
        onBack: widget.refresh,
      ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
    });
  }
}
