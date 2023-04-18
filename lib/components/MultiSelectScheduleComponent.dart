import 'package:customer_app/models/schedule_item_model.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:customer_app/utils/enum/schedule_item_status.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

typedef OnViewChangedCallback = void Function(
    DateTime startDate, DateTime endDate);
typedef OnSelectedDateCallback = void Function(List<DateTime> dates);

class MultiSelectScheduleComponent extends StatelessWidget {
  final Map<String, ScheduleItemModel>? schedule;
  final OnViewChangedCallback? onViewChanged;
  final OnSelectedDateCallback? onSelectedDates;
  final DateRangePickerController? controller;

  const MultiSelectScheduleComponent(
      {Key? key,
      this.schedule,
      this.onViewChanged,
      this.onSelectedDates,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get disabled dates from schedule
    List<DateTime> disabledDates = schedule != null
        ? schedule!.entries
            .where((entry) =>
                entry.value.getStatus(DateTime.parse(entry.key)) !=
                ScheduleItemStatus.ON_SALE)
            .map((entry) => DateTime.parse(entry.key))
            .toList()
        : [];

    return Scaffold(
      body: SfDateRangePicker(
        controller: controller,
        view: DateRangePickerView.month,
        minDate: DateTimeUtil.getTomorrow(),
        enablePastDates: false,
        monthViewSettings: DateRangePickerMonthViewSettings(
          blackoutDates: disabledDates,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          blackoutDateTextStyle: TextStyle(
              color: Colors.grey, decoration: TextDecoration.lineThrough),
        ),
        selectionMode: DateRangePickerSelectionMode.multiple,
        onViewChanged: (DateRangePickerViewChangedArgs args) {
          if (onViewChanged != null) {
            final startDate = args.visibleDateRange.startDate;
            final endDate = args.visibleDateRange.endDate;
            if (startDate != null && endDate != null) {
              onViewChanged!(startDate, endDate);
            }
          }
        },
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (onSelectedDates != null) {
            final selectedDates = List<DateTime>.from(args.value);
            onSelectedDates!(selectedDates);
          }
        },
      ),
    );
  }
}
