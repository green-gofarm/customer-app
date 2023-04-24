import 'package:intl/intl.dart';

class NumberUtil {
  static String formatIntPriceToVnd(int price) {
    if(price == 0) return "Miễn phí";

    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final result = formatCurrency.format(price);
    return result;
  }
}
