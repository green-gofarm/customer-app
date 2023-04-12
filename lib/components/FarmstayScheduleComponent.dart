import 'package:customer_app/main.dart';
import 'package:customer_app/models/farmstay_activity_schedule_item.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:customer_app/models/farmstay_room_schedule_item.dart';
import 'package:customer_app/store/farmstay_schedule/farmstay_schedule_store.dart';
import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/RFConstant.dart';
import 'package:customer_app/utils/RFWidget.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:customer_app/utils/enum/schedule_item_type.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'HorizontalCalendarComponent.dart';

class FarmstayScheduleComponent extends StatefulWidget {
  final FarmstayDetailModel farmstay;

  FarmstayScheduleComponent({required this.farmstay});

  @override
  FarmstayScheduleComponentState createState() =>
      FarmstayScheduleComponentState();
}

class FarmstayScheduleComponentState extends State<FarmstayScheduleComponent> {
  FarmstayScheduleStore store = FarmstayScheduleStore();

  DateTime selectedDate = DateTime.now();

  List<FarmstayActivityScheduleItem> activityScheduleList = [];
  List<FarmstayRoomScheduleItem> roomScheduleList = [];

  void clearSchedule() {
    activityScheduleList = [];
    roomScheduleList = [];
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
      logger.i("Schedule map: ${store.farmstaySchedule!.schedule.toString()}");
      return;
    }

    activityScheduleList = List.from(scheduleList
        .where((item) => item.itemType == FarmstayItemType.ACTIVITY)
        .map((item) => FarmstayActivityScheduleItem(
              schedule: item,
              activity: widget.farmstay.activities.length > 0
                  ? widget.farmstay.activities
                      .firstWhere((activity) => activity.id == item.itemId)
                  : null,
            ))
        .toList());

    roomScheduleList = List.from(scheduleList
        .where((item) => item.itemType == FarmstayItemType.ROOM)
        .map((item) => FarmstayRoomScheduleItem(
              schedule: item,
              room: widget.farmstay.rooms.length > 0
                  ? widget.farmstay.rooms
                      .firstWhere((room) => room.id == item.itemId)
                  : null,
            ))
        .toList());

    logger.i("Activity ${activityScheduleList.length}");
    logger.i("Room ${roomScheduleList.length}");
  }

  void handleDateSelected(DateTime selectedDate) {
    setState(() {
      this.selectedDate = selectedDate;
      handleGetScheduleItems(selectedDate);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await store.getFarmstaySchedule(farmstayId: widget.farmstay.id);
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
        children: [
          16.height,
          Text(DateTimeUtil.getFormattedMonthYear(selectedDate),
              style: boldTextStyle()),
          8.height,
          HorizontalCalendarComponent(
              onDateSelected: handleDateSelected, selectedDate: selectedDate),
          8.height,
          Row(
            children: [
              Text('Hoạt động', style: boldTextStyle()).expand(),
            ],
          ).paddingSymmetric(vertical: 0, horizontal: 16.0),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: activityScheduleList.length,
            itemBuilder: (context, index) {
              return Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: rf_primaryColor,
                      borderRadius: radius(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.check, color: white)
                          .paddingOnly(top: 28.0, bottom: 28.0),
                    ),
                  ), // instead of background
                  ActivityFragment(context,
                      item: activityScheduleList[index], date: selectedDate),
                ],
              );
            },
          ),
          Row(
            children: [
              Text('Phòng ở', style: boldTextStyle()).expand(),
            ],
          ).paddingSymmetric(vertical: 0, horizontal: 16.0),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: roomScheduleList.length,
            itemBuilder: (context, index) {
              return Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: rf_primaryColor,
                      borderRadius: radius(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.check, color: white)
                          .paddingOnly(top: 28.0, bottom: 28.0),
                    ),
                  ), // instead of background
                  RoomFragment(context,
                          item: roomScheduleList[index], date: selectedDate),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget RoomFragment(BuildContext context,
      {required FarmstayRoomScheduleItem item, required DateTime date}) {
    final room = item.room!;

    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: EdgeInsets.all(8.0),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.cardColor,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: radius(12),
      ),
      child: Row(
        children: [
          4.width,
          rfCommonCachedNetworkImage(
            (room.images.avatar ?? default_image).validate(),
            fit: BoxFit.cover,
            height: 75,
            width: 75,
          ).cornerRadiusWithClipRRect(8.0),
          10.width,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name.validate(), style: boldTextStyle()),
                  8.height,
                  item.schedule.getStatusString(date, size: 12),
                  12.height,
                  Text(NumberUtil.formatIntPriceToVnd(room.price),
                      style: boldTextStyle(size: 12, color: rf_primaryColor)),
                  8.height,
                ],
              ),
            ],
          ).expand(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              56.height,
              Icon(Icons.keyboard_arrow_right,
                  color: Colors.grey.shade400, size: 18),
              8.height,
            ],
          ),
          8.width,
        ],
      ),
    ).onTap(() {

    });
  }

  Widget ActivityFragment(BuildContext context,
      {required FarmstayActivityScheduleItem item, required DateTime date}) {
    final activity = item.activity;

    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: EdgeInsets.all(8.0),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.cardColor,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: radius(12),
      ),
      child: Row(
        children: [
          4.width,
          rfCommonCachedNetworkImage(
            (item.activity!.images.avatar ?? default_image).validate(),
            fit: BoxFit.cover,
            height: 75,
            width: 75,
          ).cornerRadiusWithClipRRect(8.0),
          10.width,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity!.name!.validate(), style: boldTextStyle()),
                  8.height,
                  item.schedule.getStatusString(date, size: 12),
                  12.height,
                  Text(NumberUtil.formatIntPriceToVnd(activity.price),
                      style: boldTextStyle(size: 12, color: rf_primaryColor)),
                  8.height,
                ],
              ),
            ],
          ).expand(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              56.height,
              Icon(Icons.keyboard_arrow_right,
                  color: Colors.grey.shade400, size: 18),
              8.height,
            ],
          ),
          8.width,
        ],
      ),
    ).onTap((){
      Navigator.pushNamed(
          context, RoutePaths.ACTIVITY_DETAIL.value, arguments: {
        "farmstayId": activity.farmstayId,
        "activityId": activity.id
      });
    });
  }
}
