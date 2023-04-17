import 'package:customer_app/utils/enum/cart_item_type.dart';

class CreateCartItem {
  final int itemId;
  final String date;
  final CartItemType type;

  CreateCartItem({
    required this.itemId,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'date': date,
      'type': type.code,
    };
  }
}
