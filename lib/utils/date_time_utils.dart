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
}
