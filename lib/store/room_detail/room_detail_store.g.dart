// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RoomDetailStore on _RoomDetailStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_RoomDetailStore.isLoading', context: context);

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

  late final _$roomDetailAtom =
      Atom(name: '_RoomDetailStore.roomDetail', context: context);

  @override
  RoomModel? get roomDetail {
    _$roomDetailAtom.reportRead();
    return super.roomDetail;
  }

  @override
  set roomDetail(RoomModel? value) {
    _$roomDetailAtom.reportWrite(value, super.roomDetail, () {
      super.roomDetail = value;
    });
  }

  late final _$messageAtom =
      Atom(name: '_RoomDetailStore.message', context: context);

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

  late final _$getRoomDetailAsyncAction =
      AsyncAction('_RoomDetailStore.getRoomDetail', context: context);

  @override
  Future<void> getRoomDetail({required int farmstayId, required int roomId}) {
    return _$getRoomDetailAsyncAction
        .run(() => super.getRoomDetail(farmstayId: farmstayId, roomId: roomId));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
roomDetail: ${roomDetail},
message: ${message}
    ''';
  }
}
