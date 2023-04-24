import 'package:customer_app/data/user/user_api.dart';
import 'package:customer_app/main.dart';

import 'package:customer_app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

const LIMIT = 0;

abstract class _UserStore with Store {
  final UserApi _api = UserApi();

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  @action
  Future<bool> updateProfile(UserModel newUser) async {
    isLoading = true;

    bool isUpdated = false;
    final result = await _api.updateProfile(newUser.toUpdateJson());
    await result.fold(
      (error) {
        message = error;
      },
      (r) {
        isUpdated = r;
        message = null;
      },
    );

    logger.i("Update profile: ${isUpdated}");
    if (message != null) {
      logger.e("Update profile error $message");
    }

    isLoading = false;
    return isUpdated;
  }

  @action
  Future<bool> updateAvatar(XFile file) async {
    isLoading = true;

    bool isUpdated = false;
    List<String> urls = [];

    final resultCreateImageUrl = await _api.uploadImage([file]);
    await resultCreateImageUrl.fold(
      (error) {
        message = error;
      },
      (r) {
        urls = r;
        message = null;
      },
    );

    if(urls.isEmpty) {
      isLoading = false;
      return false;
    }

    final resultUpdate = await _api.updateProfile({
      'avatar': urls[0],
    });

    await resultUpdate.fold(
          (error) {
        message = error;
      },
          (r) {
        isUpdated = r;
        message = null;
      },
    );

    logger.i("Update avatar: ${isUpdated}");
    if (message != null) {
      logger.e("Update avatar error $message");
    }

    isLoading = false;
    return isUpdated;
  }
}
