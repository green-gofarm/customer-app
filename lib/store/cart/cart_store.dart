import 'package:customer_app/data/cart/cart_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/Cart.dart';
import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  final CartApi _api = CartApi();

  @observable
  Cart? cart = null;

  @observable
  bool loading = false;

  @observable
  String? message = null;

  @action
  Future<void> getCustomerCartInFarmstay(int farmstayId) async {
    loading = true;

    final result = await _api.getCartOfFarmstay(farmstayId);
    await result.fold((errorMessage) => message, (r) => cart = r);

    logger.i("Get Cart: $cart");
    if(message != null) {
      logger.e("Error message get cart: $message}");
    }
  }

  bool hasAvailableCart () {
    return cart != null && (cart!.totalActivity > 0  || cart!.totalRoom > 0);
  }
}
