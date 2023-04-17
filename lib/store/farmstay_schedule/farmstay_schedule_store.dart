import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/farmstay_schedule_model.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'farmstay_schedule_store.g.dart';

class FarmstayScheduleStore = _FarmstayScheduleStore
    with _$FarmstayScheduleStore;

const LIMIT = 0;

abstract class _FarmstayScheduleStore with Store {
  final FarmstayApi _api = FarmstayApi();

  @observable
  FarmstayScheduleModel? farmstaySchedule = null;

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  @action
  Future<void> getFarmstaySchedule({required int farmstayId, DateTime? date}) async {
    isLoading = true;

    final _date = date ?? DateTimeUtil.getTomorrow();
    final _formattedDate = DateFormat("yyyy-MM-dd").format(_date);
    final result =
        await _api.getFarmstaySchedule(farmstayId, _formattedDate, LIMIT);

    await result.fold(
      (error) {
        message = error;
        isLoading = false;
      },
      (schedule) {
        this.farmstaySchedule = schedule;
        isLoading = false;
      },
    );

    logger.i("Farmstay schedule ${farmstaySchedule}");
    if (message != null) {
      logger.e("Farmstay schedule error $message");
    }
  }
}
