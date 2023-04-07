import 'package:customer_app/main.dart';
import 'package:customer_app/models/user_model.dart';
import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/data/auth/auth_api.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/error_message.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthApi _authApi = AuthApi();

  @observable
  UserModel? user;

  @observable
  String? errorMessage = null;

  @computed
  UserModel? get getUser => user;

  void resetStore () {
      setUser(null);
      errorMessage = null;
  }

  @action
  Future<void> signInCustomer(bool? noMessage) async {
    resetStore();

    final result = await _authApi.signInCustomer();

    await result.fold(
      (errorMessage) => {
        if (noMessage == null || noMessage == false)
          {this.errorMessage = errorMessage}
      },
      (user) => this.user = user,
    );

    logger.i("Customer sign in", user.toString());
  }

  @action
  Future<bool> checkNewlyAccount(String token) async {
    resetStore();

    final checkResult = await _authApi.checkNewlySignupAccount(token);

    bool isNew = false;
    await checkResult.fold(
          (errorMessage) => this.errorMessage = errorMessage,
          (result) => isNew = result,
    );

    logger.i("Account is new?", isNew);
    return isNew;
  }

  @action
  Future<void> signUpCustomer(String token) async {
    resetStore();

    final isNew = await checkNewlyAccount(token);
    if(!isNew) {
      this.errorMessage = ACCOUNT_ALREADY_EXIST;
      this.user = null;
      return;
    }

    final result = await _authApi.signUpCustomer(token);

    await result.fold(
      (errorMessage) => this.errorMessage = errorMessage,
      (user) => this.user = user,
    );

    logger.i("Customer sign up", user?.toString());
  }

  @action
  void setUser(UserModel? user) {
    this.user = user;
  }
}