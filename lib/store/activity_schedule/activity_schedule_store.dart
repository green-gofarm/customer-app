import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/activity_schedule_model.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'activity_schedule_store.g.dart';

class ActivityScheduleStore = _ActivityScheduleStore
    with _$ActivityScheduleStore;

const LIMIT = 0;

abstract class _ActivityScheduleStore with Store {
  final FarmstayApi _api = FarmstayApi();

  @observable
  ActivityScheduleModel? activitySchedule = null;

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  @action
  Future<void> getActivitySchedule(
      {required int farmstayId,
      required int activityId,
      DateTime? date,
      required int limit}) async {
    isLoading = true;

    final _date = date ?? DateTimeUtil.getTomorrow();
    final _formattedDate = DateFormat("yyyy-MM-dd").format(_date);
    final result = await _api.getActivitySchedule(
        farmstayId, activityId, _formattedDate, limit);

    await result.fold(
      (error) {
        activitySchedule = null;
        message = error;
      },
      (schedule) {
        this.activitySchedule = schedule;
      },
    );

    if (message != null) {
      logger.e("Activity schedule error $message");
    }

    isLoading = false;
  }
}
