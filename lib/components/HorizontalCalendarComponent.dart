import 'package:customer_app/utils/RFColors.dart';
import 'package:customer_app/utils/SettingUtils.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HorizontalCalendarComponent extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  const HorizontalCalendarComponent({
    Key? key,
    required this.onDateSelected,
    required this.selectedDate,
  }) : super(key: key);

  @override
  HorizontalCalendarComponentState createState() =>
      HorizontalCalendarComponentState();
}

class HorizontalCalendarComponentState
    extends State<HorizontalCalendarComponent> {
  late int currentDateSelectedIndex;
  late ScrollController scrollController;

  static List<String> listOfMonths = [
    "Thg 1",
    "Thg 2",
    "Thg 3",
    "Thg 4",
    "Thg 5",
    "Thg 6",
    "Thg 7",
    "Thg 8",
    "Thg 9",
    "Thg 10",
    "Thg 11",
    "Thg 12"
  ];
  static List<String> listOfDays = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

  @override
  void initState() {
    super.initState();
    currentDateSelectedIndex =
        widget.selectedDate.difference(DateTimeUtil.getTomorrow()).inDays;
    scrollController =
        ScrollController(initialScrollOffset: currentDateSelectedIndex * 60.0);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 0);
        },
        itemCount: SettingUtils.MAX_BOOK_DATE,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {

          final day = DateTimeUtil.getTomorrow().add(Duration(days: index));
          return Container(
            height: 70,
            width: 70,
            alignment: Alignment.center,
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor:
                  currentDateSelectedIndex == index ? rf_primaryColor : white,
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  listOfDays[day.weekday - 1],
                  style: secondaryTextStyle(
                    size: 14,
                    color: currentDateSelectedIndex == index
                        ? white
                        : rf_primaryColor,
                  ),
                ),
                4.height,
                Text(
                  "${day.day.toString()}/${day.month}",
                  style: boldTextStyle(
                    size: currentDateSelectedIndex == index ? 20: 16,
                    color: currentDateSelectedIndex == index ? white : black,
                  ),
                ),
                4.height,
              ],
            ),
          ).paddingRight(8.0).onTap(
            () {
              widget.onDateSelected(day);
              setState(() {
                currentDateSelectedIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
