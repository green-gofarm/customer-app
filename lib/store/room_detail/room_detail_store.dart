import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:mobx/mobx.dart';

part 'room_detail_store.g.dart';

class RoomDetailStore = _RoomDetailStore with _$RoomDetailStore;

abstract class _RoomDetailStore with Store {
  final FarmstayApi _api = FarmstayApi();

  @observable
  bool isLoading = false;

  @observable
  RoomModel? roomDetail;

  @observable
  String? message = null;

  void clear() {
    message = null;
  }

  @action
  Future<void> getRoomDetail(
      {required int farmstayId, required int roomId}) async {
    clear();
    isLoading = true;
    final result = await _api.getRoomDetail(farmstayId, roomId);

    await result.fold(
          (error) {
        message = error;
        this.roomDetail = null;
      },
          (detail) {
        this.roomDetail = detail;
      },
    );

    logger.i("Room detail ${roomDetail}");
    if (message != null) {
      logger.e("Room detail error $message");
    }
    isLoading = false;
  }
}
