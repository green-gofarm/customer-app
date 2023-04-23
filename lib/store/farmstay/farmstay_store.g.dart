// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmstay_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FarmstayStore on _FarmstayStore, Store {
  late final _$farmstayPagingAtom =
      Atom(name: '_FarmstayStore.farmstayPaging', context: context);

  @override
  PagingModel<FarmstayModel>? get farmstayPaging {
    _$farmstayPagingAtom.reportRead();
    return super.farmstayPaging;
  }

  @override
  set farmstayPaging(PagingModel<FarmstayModel>? value) {
    _$farmstayPagingAtom.reportWrite(value, super.farmstayPaging, () {
      super.farmstayPaging = value;
    });
  }

  late final _$topRatedFarmstaysAtom =
      Atom(name: '_FarmstayStore.topRatedFarmstays', context: context);

  @override
  List<FarmstayModel> get topRatedFarmstays {
    _$topRatedFarmstaysAtom.reportRead();
    return super.topRatedFarmstays;
  }

  @override
  set topRatedFarmstays(List<FarmstayModel> value) {
    _$topRatedFarmstaysAtom.reportWrite(value, super.topRatedFarmstays, () {
      super.topRatedFarmstays = value;
    });
  }

  late final _$topBookedActivitiesAtom =
      Atom(name: '_FarmstayStore.topBookedActivities', context: context);

  @override
  List<ActivityModel> get topBookedActivities {
    _$topBookedActivitiesAtom.reportRead();
    return super.topBookedActivities;
  }

  @override
  set topBookedActivities(List<ActivityModel> value) {
    _$topBookedActivitiesAtom.reportWrite(value, super.topBookedActivities, () {
      super.topBookedActivities = value;
    });
  }

  late final _$topBookedRoomsAtom =
      Atom(name: '_FarmstayStore.topBookedRooms', context: context);

  @override
  List<RoomModel> get topBookedRooms {
    _$topBookedRoomsAtom.reportRead();
    return super.topBookedRooms;
  }

  @override
  set topBookedRooms(List<RoomModel> value) {
    _$topBookedRoomsAtom.reportWrite(value, super.topBookedRooms, () {
      super.topBookedRooms = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_FarmstayStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$messageAtom =
      Atom(name: '_FarmstayStore.message', context: context);

  @override
  String? get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String? value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
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
  Future<void> getTopRatedFarmstay({int? limit}) {
    return _$getTopRatedFarmstayAsyncAction
        .run(() => super.getTopRatedFarmstay(limit: limit));
  }

  @override
  String toString() {
    return '''
farmstayPaging: ${farmstayPaging},
topRatedFarmstays: ${topRatedFarmstays},
topBookedActivities: ${topBookedActivities},
topBookedRooms: ${topBookedRooms},
loading: ${loading},
message: ${message}
    ''';
  }
}
