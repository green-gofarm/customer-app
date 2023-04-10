import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/farmstay_detail_model.dart';
import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';

part 'demo_farmstay_store.g.dart';

typedef StoreResult<T> = Tuple2<String?, T?>;

class FarmstayStore extends _FarmstayStore with _$FarmstayStore {
  FarmstayStore(FarmstayApi farmstayApi) : super(farmstayApi);
}

abstract class _FarmstayStore with Store {
  final FarmstayApi _farmstayApi;

  _FarmstayStore(this._farmstayApi);

  @observable
  StoreResult<PagingModel<FarmstayModel>>? farmstayResult;

  @observable
  StoreResult<List<FarmstayModel>>? topRatedFarmstayResult;

  @observable
  StoreResult<List<ActivityModel>>? topBookedActivitiesResult;

  @observable
  StoreResult<List<RoomModel>>? topBookedRoomsResult;

  @observable
  StoreResult<FarmstayDetailModel>? farmstayDetailResult;

  @action
  Future<void> searchFarmstayWithElastic(Map<String, String> params) async {
    final result = await _farmstayApi.searchFarmstayWithElastic(params);

    farmstayResult = result.fold(
          (errorMessage) => Tuple2(errorMessage, null),
          (data) => Tuple2(null, data),
    );
  }

  @action
  Future<void> getTopRatedFarmstay(int limit) async {
    final result = await _farmstayApi.getTopRatedFarmstay(limit);

    topRatedFarmstayResult = result.fold(
          (errorMessage) => Tuple2(errorMessage, null),
          (data) => Tuple2(null, data),
    );
  }

  @action
  Future<void> getTopBookedActivities(int limit) async {
    final result = await _farmstayApi.getTopBookedActivities(limit);

    topBookedActivitiesResult = result.fold(
          (errorMessage) => Tuple2(errorMessage, null),
          (data) => Tuple2(null, data),
    );
  }

  @action
  Future<void> getTopBookedRooms(int limit) async {
    final result = await _farmstayApi.getTopBookedRooms(limit);

    topBookedRoomsResult = result.fold(
          (errorMessage) => Tuple2(errorMessage, null),
          (data) => Tuple2(null, data),
    );
  }

  @action
  Future<void> getFarmstayDetail(int id) async {
    final result = await _farmstayApi.getFarmstayDetail(id);

    farmstayDetailResult = result.fold(
          (errorMessage) => Tuple2(errorMessage, null),
          (data) => Tuple2(null, data),
    );
  }
}
