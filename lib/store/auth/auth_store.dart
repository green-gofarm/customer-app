import 'package:customer_app/main.dart';
import 'package:customer_app/models/user_model.dart';
import 'package:customer_app/screens/SignInScreen.dart';
import 'package:customer_app/data/auth/auth_api.dart';
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
  bool isLoading = false;

  @observable
  String? errorMessage = null;

  @computed
  UserModel? get getUser => user;

  @action
  void listenForAuthChanges(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        authStore.setUser(null);
        SignInScreen().launch(context);
      }
    });
  }

  void resetStore () {
      setUser(null);
      errorMessage = null;
  }

  @action
  Future<void> signInCustomer(bool? noMessage) async {
    resetStore();
    isLoading = true;

    final result = await _authApi.signInCustomer();

    await result.fold(
      (errorMessage) => {
        if (noMessage == null || noMessage == false)
          {this.errorMessage = errorMessage}
      },
      (user) => this.user = user,
    );

    isLoading = false;
    logger.i("Customer sign in", user.toString());
  }

  @action
  Future<bool> checkNewlyAccount(String token) async {
    resetStore();
    isLoading = true;

    final checkResult = await _authApi.checkNewlySignupAccount(token);

    bool isNew = false;
    await checkResult.fold(
          (errorMessage) => this.errorMessage = errorMessage,
          (result) => isNew = result,
    );

    isLoading = false;
    logger.i("Account is new?", isNew);

    return isNew;
  }

  @action
  Future<void> signUpCustomer(String token) async {
    resetStore();
    isLoading = true;

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

    isLoading = false;
    logger.i("Customer sign up", user?.toString());
  }

  @action
  void setUser(UserModel? user) {
    this.user = user;
  }
}
