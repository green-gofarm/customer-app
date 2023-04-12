import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:mobx/mobx.dart';

part 'farmstay_detail_store.g.dart';

class FarmstayDetailStore = _FarmstayDetailStore with _$FarmstayDetailStore;

abstract class _FarmstayDetailStore with Store {
  final FarmstayApi _api = FarmstayApi();

  @observable
  bool isLoading = false;

  @observable
  FarmstayDetailModel? farmstayDetail;

  @observable
  String? message = null;

  @action
  Future<void> getFarmstayDetail(int id) async {
    isLoading = true;
    final result = await _api.getFarmstayDetail(id);

    await result.fold(
      (error) {
        message = error;
        isLoading = false;
      },
      (farmstayDetail) {
        this.farmstayDetail = farmstayDetail;
        isLoading = false;
      },
    );

    isLoading = false;
    logger.i("Farmstay detail ${farmstayDetail}");
    if (message != null) {
      logger.e("Farmstay detail error $message");
    }
  }
}
