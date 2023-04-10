// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_farmstay_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FarmstayStore on _FarmstayStore, Store {
  late final _$farmstayResultAtom =
      Atom(name: '_FarmstayStore.farmstayResult', context: context);

  @override
  Tuple2<String?, PagingModel<FarmstayModel>?>? get farmstayResult {
    _$farmstayResultAtom.reportRead();
    return super.farmstayResult;
  }

  @override
  set farmstayResult(Tuple2<String?, PagingModel<FarmstayModel>?>? value) {
    _$farmstayResultAtom.reportWrite(value, super.farmstayResult, () {
      super.farmstayResult = value;
    });
  }

  late final _$topRatedFarmstayResultAtom =
      Atom(name: '_FarmstayStore.topRatedFarmstayResult', context: context);

  @override
  Tuple2<String?, List<FarmstayModel>?>? get topRatedFarmstayResult {
    _$topRatedFarmstayResultAtom.reportRead();
    return super.topRatedFarmstayResult;
  }

  @override
  set topRatedFarmstayResult(Tuple2<String?, List<FarmstayModel>?>? value) {
    _$topRatedFarmstayResultAtom
        .reportWrite(value, super.topRatedFarmstayResult, () {
      super.topRatedFarmstayResult = value;
    });
  }

  late final _$topBookedActivitiesResultAtom =
      Atom(name: '_FarmstayStore.topBookedActivitiesResult', context: context);

  @override
  Tuple2<String?, List<ActivityModel>?>? get topBookedActivitiesResult {
    _$topBookedActivitiesResultAtom.reportRead();
    return super.topBookedActivitiesResult;
  }

  @override
  set topBookedActivitiesResult(Tuple2<String?, List<ActivityModel>?>? value) {
    _$topBookedActivitiesResultAtom
        .reportWrite(value, super.topBookedActivitiesResult, () {
      super.topBookedActivitiesResult = value;
    });
  }

  late final _$topBookedRoomsResultAtom =
      Atom(name: '_FarmstayStore.topBookedRoomsResult', context: context);

  @override
  Tuple2<String?, List<RoomModel>?>? get topBookedRoomsResult {
    _$topBookedRoomsResultAtom.reportRead();
    return super.topBookedRoomsResult;
  }

  @override
  set topBookedRoomsResult(Tuple2<String?, List<RoomModel>?>? value) {
    _$topBookedRoomsResultAtom.reportWrite(value, super.topBookedRoomsResult,
        () {
      super.topBookedRoomsResult = value;
    });
  }

  late final _$farmstayDetailResultAtom =
      Atom(name: '_FarmstayStore.farmstayDetailResult', context: context);

  @override
  Tuple2<String?, FarmstayDetailModel?>? get farmstayDetailResult {
    _$farmstayDetailResultAtom.reportRead();
    return super.farmstayDetailResult;
  }

  @override
  set farmstayDetailResult(Tuple2<String?, FarmstayDetailModel?>? value) {
    _$farmstayDetailResultAtom.reportWrite(value, super.farmstayDetailResult,
        () {
      super.farmstayDetailResult = value;
    });
  }

  late final _$searchFarmstayWithElasticAsyncAction =
      AsyncAction('_FarmstayStore.searchFarmstayWithElastic', context: context);

  @override
  Future<void> searchFarmstayWithElastic(Map<String, String> params) {
    return _$searchFarmstayWithElasticAsyncAction
        .run(() => super.searchFarmstayWithElastic(params));
  }

  late final _$getTopRatedFarmstayAsyncAction =
      AsyncAction('_FarmstayStore.getTopRatedFarmstay', context: context);

  @override
  Future<void> getTopRatedFarmstay(int limit) {
    return _$getTopRatedFarmstayAsyncAction
        .run(() => super.getTopRatedFarmstay(limit));
  }

  late final _$getTopBookedActivitiesAsyncAction =
      AsyncAction('_FarmstayStore.getTopBookedActivities', context: context);

  @override
  Future<void> getTopBookedActivities(int limit) {
    return _$getTopBookedActivitiesAsyncAction
        .run(() => super.getTopBookedActivities(limit));
  }

  late final _$getTopBookedRoomsAsyncAction =
      AsyncAction('_FarmstayStore.getTopBookedRooms', context: context);

  @override
  Future<void> getTopBookedRooms(int limit) {
    return _$getTopBookedRoomsAsyncAction
        .run(() => super.getTopBookedRooms(limit));
  }

  late final _$getFarmstayDetailAsyncAction =
      AsyncAction('_FarmstayStore.getFarmstayDetail', context: context);

  @override
  Future<void> getFarmstayDetail(int id) {
    return _$getFarmstayDetailAsyncAction
        .run(() => super.getFarmstayDetail(id));
  }

  @override
  String toString() {
    return '''
farmstayResult: ${farmstayResult},
topRatedFarmstayResult: ${topRatedFarmstayResult},
topBookedActivitiesResult: ${topBookedActivitiesResult},
topBookedRoomsResult: ${topBookedRoomsResult},
farmstayDetailResult: ${farmstayDetailResult}
    ''';
  }
}
