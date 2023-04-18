// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<UserModel?>? _$getUserComputed;

  @override
  UserModel? get getUser => (_$getUserComputed ??=
          Computed<UserModel?>(() => super.getUser, name: '_AuthStore.getUser'))
      .value;

  late final _$userAtom = Atom(name: '_AuthStore.user', context: context);

  @override
  UserModel? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_AuthStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$signInCustomerAsyncAction =
      AsyncAction('_AuthStore.signInCustomer', context: context);

  @override
  Future<void> signInCustomer(bool noMessage) {
    return _$signInCustomerAsyncAction
        .run(() => super.signInCustomer(noMessage));
  }

  late final _$checkNewlyAccountAsyncAction =
      AsyncAction('_AuthStore.checkNewlyAccount', context: context);

  @override
  Future<bool> checkNewlyAccount(String token) {
    return _$checkNewlyAccountAsyncAction
        .run(() => super.checkNewlyAccount(token));
  }

  late final _$signUpCustomerAsyncAction =
      AsyncAction('_AuthStore.signUpCustomer', context: context);

  @override
  Future<void> signUpCustomer(String token) {
    return _$signUpCustomerAsyncAction.run(() => super.signUpCustomer(token));
  }

  late final _$signOutAsyncAction =
      AsyncAction('_AuthStore.signOut', context: context);

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$_AuthStoreActionController =
      ActionController(name: '_AuthStore', context: context);

  @override
  bool isAuthenticated() {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.isAuthenticated');
    try {
      return super.isAuthenticated();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUser(UserModel? user) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
errorMessage: ${errorMessage},
getUser: ${getUser}
    ''';
  }
}
