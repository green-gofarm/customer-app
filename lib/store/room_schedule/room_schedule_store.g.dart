// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_schedule_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RoomScheduleStore on _RoomScheduleStore, Store {
  late final _$roomScheduleAtom =
      Atom(name: '_RoomScheduleStore.roomSchedule', context: context);

  @override
  RoomScheduleModel? get roomSchedule {
    _$roomScheduleAtom.reportRead();
    return super.roomSchedule;
  }

  @override
  set roomSchedule(RoomScheduleModel? value) {
    _$roomScheduleAtom.reportWrite(value, super.roomSchedule, () {
      super.roomSchedule = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_RoomScheduleStore.isLoading', context: context);

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
      Atom(name: '_RoomScheduleStore.message', context: context);

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

  late final _$getRoomScheduleAsyncAction =
      AsyncAction('_RoomScheduleStore.getRoomSchedule', context: context);

  @override
  Future<void> getRoomSchedule(
      {required int farmstayId,
      required int roomId,
      DateTime? date,
      required int limit}) {
    return _$getRoomScheduleAsyncAction.run(() => super.getRoomSchedule(
        farmstayId: farmstayId, roomId: roomId, date: date, limit: limit));
  }

  @override
  String toString() {
    return '''
roomSchedule: ${roomSchedule},
isLoading: ${isLoading},
message: ${message}
    ''';
  }
}
