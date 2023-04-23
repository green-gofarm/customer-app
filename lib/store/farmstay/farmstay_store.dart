import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:mobx/mobx.dart';

part 'farmstay_store.g.dart';

class FarmstayStore = _FarmstayStore with _$FarmstayStore;

abstract class _FarmstayStore with Store {
  final FarmstayApi _farmstayApi = FarmstayApi();

  @observable
  PagingModel<FarmstayModel>? farmstayPaging;

  @observable
  List<FarmstayModel> topRatedFarmstays = [];

  @observable
  List<ActivityModel> topBookedActivities = [];

  @observable
  List<RoomModel> topBookedRooms = [];

  @observable
  bool loading = false;

  @observable
  String? message = null;

  @action
  Future<void> searchFarmstayWithElastic(Map<String, String> params) async {
    loading = true;
    final result = await _farmstayApi.searchFarmstayWithElastic(params);

    await result.fold(
      (e) {
        message = e;
        farmstayPaging = null;
      },
      (data) {
        farmstayPaging = data;
        message = null;
      },
    );

    loading = false;
  }

  static const int LIMIT = 10;

  @action
  Future<void> getTopRatedFarmstay({int? limit}) async {
    loading = true;

    final result = await _farmstayApi.getTopRatedFarmstay(limit ?? LIMIT);

    await result.fold(
      (e) {
        message = e;
        topRatedFarmstays.clear();
      },
      (data) {
        topRatedFarmstays = data;
        message = null;
      },
    );

    loading = false;
  }

  Future<void> getTopBookedActivities({int? limit}) async {
    loading = true;

    final result = await _farmstayApi.getTopBookedActivities(limit ?? LIMIT);

    await result.fold(
      (e) {
        message = e;
        topBookedActivities.clear();
      },
      (data) {
        topBookedActivities = data;
        message = null;
      },
    );

    loading = false;
  }

  Future<void> getTopBookedRooms({int? limit}) async {
    loading = true;

    final result = await _farmstayApi.getTopBookedRooms(limit ?? LIMIT);

    await result.fold(
      (e) {
        message = e;
        topBookedRooms.clear();
      },
      (data) {
        topBookedRooms = data;
        message = null;
      },
    );

    loading = false;
  }
}
