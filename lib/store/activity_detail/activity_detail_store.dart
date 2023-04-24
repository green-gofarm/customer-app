import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:mobx/mobx.dart';

part 'activity_detail_store.g.dart';

class ActivityDetailStore = _ActivityDetailStore with _$ActivityDetailStore;

abstract class _ActivityDetailStore with Store {
  final FarmstayApi _api = FarmstayApi();

  @observable
  bool isLoading = false;

  @observable
  ActivityModel? activityDetail;

  @observable
  String? message = null;

  @action
  Future<void> getActivityDetail(
      {required int farmstayId, required int activityId}) async {
    isLoading = true;
    final result = await _api.getActivityDetail(farmstayId, activityId);

    await result.fold(
      (error) {
        message = error;
        isLoading = false;
      },
      (detail) {
        this.activityDetail = detail;
        isLoading = false;
        message = null;
      },
    );

    logger.i("Activity detail ${activityDetail}");
    if (message != null) {
      logger.e("Activity detail error $message");
    }
  }
}
