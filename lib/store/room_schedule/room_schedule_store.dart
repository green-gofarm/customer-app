import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/room_schedule_model.dart';
import 'package:customer_app/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'room_schedule_store.g.dart';

class RoomScheduleStore = _RoomScheduleStore with _$RoomScheduleStore;

const LIMIT = 0;

abstract class _RoomScheduleStore with Store {
  final FarmstayApi _api = FarmstayApi();

  @observable
  RoomScheduleModel? roomSchedule = null;

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  void clear() {
    message = null;
  }

  @action
  Future<void> getRoomSchedule(
      {required int farmstayId,
      required int roomId,
      DateTime? date,
      required int limit}) async {
    clear();
    isLoading = true;

    final _date = date ?? DateTimeUtil.getTomorrow();
    final _formattedDate = DateFormat("yyyy-MM-dd").format(_date);
    final result =
        await _api.getRoomSchedule(farmstayId, roomId, _formattedDate, limit);

    await result.fold(
      (error) {
        message = error;
        this.roomSchedule = null;
      },
      (schedule) {
        message = null;
        this.roomSchedule = schedule;
      },
    );

    if (message != null) {
      logger.e("Room schedule error $message");
    }

    isLoading = false;
  }
}
