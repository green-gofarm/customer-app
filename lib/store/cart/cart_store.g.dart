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

  late final _$getCustomerCartInFarmstayAsyncAction =
      AsyncAction('_CartStore.getCustomerCartInFarmstay', context: context);

  @override
  Future<void> getCustomerCartInFarmstay(int farmstayId) {
    return _$getCustomerCartInFarmstayAsyncAction
        .run(() => super.getCustomerCartInFarmstay(farmstayId));
  }

  @override
  String toString() {
    return '''
cart: ${cart},
loading: ${loading},
message: ${message}
    ''';
  }
}
