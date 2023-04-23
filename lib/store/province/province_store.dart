import 'package:customer_app/data/common/common_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/address_model.dart';

import 'package:mobx/mobx.dart';

part 'province_store.g.dart';

class ProvinceStore = _ProvinceStore with _$ProvinceStore;

abstract class _ProvinceStore with Store {
  final CommonApi _api = CommonApi();

  @observable
  List<ProvinceModel> provinces = [];

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  @action
  Future<void> getProvinces() async {
    if(provinces.length > 0) return;
    isLoading = true;

    final result = await _api.getAllProvinces();

    await result.fold(
      (error) {
        message = error;
        provinces.clear();
      },
      (r) {
        message = null;
        provinces = r;
      },
    );

    logger.i("Get all provinces ${provinces}");
    if (message != null) {
      logger.e("Get all province error $message");
    }

    isLoading = false;
  }
}
