// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmstay_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FarmstayDetailStore on _FarmstayDetailStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_FarmstayDetailStore.isLoading', context: context);

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

  late final _$farmstayDetailAtom =
      Atom(name: '_FarmstayDetailStore.farmstayDetail', context: context);

  @override
  FarmstayDetailModel? get farmstayDetail {
    _$farmstayDetailAtom.reportRead();
    return super.farmstayDetail;
  }

  @override
  set farmstayDetail(FarmstayDetailModel? value) {
    _$farmstayDetailAtom.reportWrite(value, super.farmstayDetail, () {
      super.farmstayDetail = value;
    });
  }

  late final _$messageAtom =
      Atom(name: '_FarmstayDetailStore.message', context: context);

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

  late final _$getFarmstayDetailAsyncAction =
      AsyncAction('_FarmstayDetailStore.getFarmstayDetail', context: context);

  @override
  Future<void> getFarmstayDetail(int id) {
    return _$getFarmstayDetailAsyncAction
        .run(() => super.getFarmstayDetail(id));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
farmstayDetail: ${farmstayDetail},
message: ${message}
    ''';
  }
}
