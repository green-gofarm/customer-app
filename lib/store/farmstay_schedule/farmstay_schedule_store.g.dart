// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmstay_schedule_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FarmstayScheduleStore on _FarmstayScheduleStore, Store {
  late final _$farmstayScheduleAtom =
      Atom(name: '_FarmstayScheduleStore.farmstaySchedule', context: context);

  @override
  FarmstayScheduleModel? get farmstaySchedule {
    _$farmstayScheduleAtom.reportRead();
    return super.farmstaySchedule;
  }

  @override
  set farmstaySchedule(FarmstayScheduleModel? value) {
    _$farmstayScheduleAtom.reportWrite(value, super.farmstaySchedule, () {
      super.farmstaySchedule = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_FarmstayScheduleStore.isLoading', context: context);

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

  late final _$messageAtom =
      Atom(name: '_FarmstayScheduleStore.message', context: context);

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

  late final _$getFarmstayScheduleAsyncAction = AsyncAction(
      '_FarmstayScheduleStore.getFarmstaySchedule',
      context: context);

  @override
  Future<void> getFarmstaySchedule({required int farmstayId, DateTime? date}) {
    return _$getFarmstayScheduleAsyncAction.run(
        () => super.getFarmstaySchedule(farmstayId: farmstayId, date: date));
  }

  @override
  String toString() {
    return '''
farmstaySchedule: ${farmstaySchedule},
isLoading: ${isLoading},
message: ${message}
    ''';
  }
}
