// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on _CartStore, Store {
  late final _$cartAtom = Atom(name: '_CartStore.cart', context: context);

  @override
  Cart? get cart {
    _$cartAtom.reportRead();
    return super.cart;
  }

  @override
  set cart(Cart? value) {
    _$cartAtom.reportWrite(value, super.cart, () {
      super.cart = value;
    });
  }

  late final _$allCartsAtom =
      Atom(name: '_CartStore.allCarts', context: context);

  @override
  List<CartItemModel> get allCarts {
    _$allCartsAtom.reportRead();
    return super.allCarts;
  }

  @override
  set allCarts(List<CartItemModel> value) {
    _$allCartsAtom.reportWrite(value, super.allCarts, () {
      super.allCarts = value;
    });
  }

  late final _$loadingAtom = Atom(name: '_CartStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$messageAtom = Atom(name: '_CartStore.message', context: context);

  @override
  String? get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String? value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  late final _$getAllCustomerCartsAsyncAction =
      AsyncAction('_CartStore.getAllCustomerCarts', context: context);

  @override
  Future<void> getAllCustomerCarts() {
    return _$getAllCustomerCartsAsyncAction
        .run(() => super.getAllCustomerCarts());
  }

  late final _$getCustomerCartInFarmstayAsyncAction =
      AsyncAction('_CartStore.getCustomerCartInFarmstay', context: context);

  @override
  Future<void> getCustomerCartInFarmstay(int farmstayId) {
    return _$getCustomerCartInFarmstayAsyncAction
        .run(() => super.getCustomerCartInFarmstay(farmstayId));
  }

  late final _$addToCartAsyncAction =
      AsyncAction('_CartStore.addToCart', context: context);

  @override
  Future<bool> addToCart(int farmstayId, List<CreateCartItem> items,
      {bool? forceRefresh}) {
    return _$addToCartAsyncAction.run(
        () => super.addToCart(farmstayId, items, forceRefresh: forceRefresh));
  }

  late final _$removeItemAsyncAction =
      AsyncAction('_CartStore.removeItem', context: context);

  @override
  Future<bool> removeItem(int farmstayId, int uid) {
    return _$removeItemAsyncAction.run(() => super.removeItem(farmstayId, uid));
  }

  late final _$clearCartAsyncAction =
      AsyncAction('_CartStore.clearCart', context: context);

  @override
  Future<bool> clearCart(int farmstayId) {
    return _$clearCartAsyncAction.run(() => super.clearCart(farmstayId));
  }

  late final _$removeItemsAsyncAction =
      AsyncAction('_CartStore.removeItems', context: context);

  @override
  Future<bool> removeItems(int farmstayId, List<int> items) {
    return _$removeItemsAsyncAction
        .run(() => super.removeItems(farmstayId, items));
  }

  late final _$_CartStoreActionController =
      ActionController(name: '_CartStore', context: context);

  @override
  int getTotalItem() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.getTotalItem');
    try {
      return super.getTotalItem();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getTotalPriceVndString() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.getTotalPriceVndString');
    try {
      return super.getTotalPriceVndString();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cart: ${cart},
allCarts: ${allCarts},
loading: ${loading},
message: ${message}
    ''';
  }
}
