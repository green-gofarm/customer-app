import 'package:intl/intl.dart';

class DateTimeUtil {
  static List<String> VN_MONTHS_LIST = [
    "Tháng 1",
    "Tháng 2",
    "Tháng 3",
    "Tháng 4",
    "Tháng 5",
    "Tháng 6",
    "Tháng 7",
    "Tháng 8",
    "Tháng 9",
    "Tháng 10",
    "Tháng 11",
    "Tháng 12"
  ];

  static String getFormattedMonthYear(DateTime date) {
    String month = VN_MONTHS_LIST[date.month - 1];
    String year = date.year.toString();

    return '$month $year';
  }

  static DateTime getTomorrow() {
    DateTime selectedDate = DateTime.now();
    return selectedDate.add(Duration(days: 1));
  }

  static DateTime getCenterDate(DateTime start, DateTime end) {
    return start.add(Duration(days: end.difference(start).inDays ~/ 2));
  }

  static int getLongestPeriod(DateTime start, DateTime end, DateTime centerDay) {
    Duration centerToStart = centerDay.difference(start);
    Duration centerToEnd = end.difference(centerDay);
    int centerToStartDays = centerToStart.inDays;
    int centerToEndDays = centerToEnd.inDays;
    return centerToStartDays > centerToEndDays ? centerToStartDays : centerToEndDays;
  }

  static String getFormattedDateInVietnamese(DateTime date) {
    return DateFormat.yMMMMd("vi_VN").format(date);
  }

  static String getFormattedDateMdInVietnamese(DateTime date) {
    return DateFormat.Md("vi_VN").format(date);
  }
}
