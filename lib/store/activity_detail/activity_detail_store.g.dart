// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ActivityDetailStore on _ActivityDetailStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_ActivityDetailStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$activityDetailAtom =
      Atom(name: '_ActivityDetailStore.activityDetail', context: context);

  @override
  ActivityModel? get activityDetail {
    _$activityDetailAtom.reportRead();
    return super.activityDetail;
  }

  @override
  set activityDetail(ActivityModel? value) {
    _$activityDetailAtom.reportWrite(value, super.activityDetail, () {
      super.activityDetail = value;
    });
  }

  late final _$messageAtom =
      Atom(name: '_ActivityDetailStore.message', context: context);

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

  late final _$getActivityDetailAsyncAction =
      AsyncAction('_ActivityDetailStore.getActivityDetail', context: context);

  @override
  Future<void> getActivityDetail(
      {required int farmstayId, required int activityId}) {
    return _$getActivityDetailAsyncAction.run(() => super
        .getActivityDetail(farmstayId: farmstayId, activityId: activityId));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
activityDetail: ${activityDetail},
message: ${message}
    ''';
  }
}
