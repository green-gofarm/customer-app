import 'package:customer_app/data/cart/cart_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/Cart.dart';
import 'package:customer_app/models/all_cart/CartItemModel.dart';
import 'package:customer_app/models/create_cart_item.dart';
import 'package:customer_app/utils/number_utils.dart';
import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  final CartApi _api = CartApi();

  @observable
  Cart? cart = null;

  @observable
  List<CartItemModel> allCarts = [];

  @observable
  bool loading = false;

  @observable
  String? message = null;

  void clear() {
    message = null;
  }

  @action
  Future<void> getAllCustomerCarts() async {
    clear();
    loading = true;

    final result = await _api.getAllCustomerCarts();
    await result.fold((errorMessage) {
      message = errorMessage;
      allCarts = [];
    }, (r) {
      allCarts = r;
    });

    logger.i("Get ALL Cart: $allCarts");
    if (message != null) {
      logger.e("Error message get ALL cart: $message}");
    }

    loading = false;
  }

  @action
  Future<void> getCustomerCartInFarmstay(int farmstayId) async {
    clear();
    loading = true;

    final result = await _api.getCartOfFarmstay(farmstayId);
    await result.fold((errorMessage) {
      message = errorMessage;
      cart = null;
    }, (r) {
      cart = r;
    });

    logger.i("Get Cart: $cart");
    if (message != null) {
      logger.e("Error message get cart: $message}");
    }

    loading = false;
  }

  @action
  Future<bool> addToCart(int farmstayId, List<CreateCartItem> items,
      {bool? forceRefresh}) async {
    loading = true;
    clear();

    bool isAdded = false;
    final result = await _api.addToCart(farmstayId, items);
    await result.fold(
        (errorMessage) => message = errorMessage, (r) => isAdded = r);

    if (isAdded && forceRefresh == true) {
      await getCustomerCartInFarmstay(farmstayId);
    }

    if (message != null) {
      logger.e("Error message get cart: $message}");
    }

    loading = false;

    return isAdded;
  }

  bool hasAvailableCart() {
    return cart != null && (cart!.totalActivity > 0 || cart!.totalRoom > 0);
  }

  @action
  Future<bool> removeItem(int farmstayId, int uid) async {
    loading = true;
    clear();

    bool isRemoved = false;
    final result = await _api.removeItem(farmstayId, uid);
    await result.fold((errorMessage) => message, (r) => isRemoved = r);

    logger.i("Remove Cart: $cart");
    if (message != null) {
      logger.e("Error message remove cart: $message}");
    }

    loading = false;
    return isRemoved;
  }

  @action
  Future<bool> clearCart(int farmstayId) async {
    loading = true;
    clear();

    bool isCleared = false;
    final result = await _api.clearCart(farmstayId);
    await result.fold((errorMessage) => message, (r) => isCleared = r);

    logger.i("Clear Cart: $cart");
    if (message != null) {
      logger.e("Error message clear cart: $message}");
    }

    loading = false;
    return isCleared;
  }

  @action
  Future<bool> removeItems(int farmstayId, List<int> items) async {
    loading = true;
    clear();

    bool isRemoved = false;
    final result = await _api.removeItems(farmstayId, items);
    await result.fold((errorMessage) => message, (r) => isRemoved = r);

    logger.i("Remove multiple item: $cart");
    if (message != null) {
      logger.e("Error message Remove multiple item: $message}");
    }

    loading = false;
    return isRemoved;
  }

  @action
  int getTotalItem() {
    if (cart == null) return 0;
    return cart!.totalRoom + cart!.totalActivity;
  }

  @action
  String getTotalPriceVndString() {
    if (cart == null) return NumberUtil.formatIntPriceToVnd(0);
    return NumberUtil.formatIntPriceToVnd(cart!.totalPrice);
  }
}
