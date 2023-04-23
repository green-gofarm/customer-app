// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProvinceStore on _ProvinceStore, Store {
  late final _$provincesAtom =
      Atom(name: '_ProvinceStore.provinces', context: context);

  @override
  List<ProvinceModel> get provinces {
    _$provincesAtom.reportRead();
    return super.provinces;
  }

  @override
  set provinces(List<ProvinceModel> value) {
    _$provincesAtom.reportWrite(value, super.provinces, () {
      super.provinces = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ProvinceStore.isLoading', context: context);

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
      Atom(name: '_ProvinceStore.message', context: context);

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

  late final _$getProvincesAsyncAction =
      AsyncAction('_ProvinceStore.getProvinces', context: context);

  @override
  Future<void> getProvinces() {
    return _$getProvincesAsyncAction.run(() => super.getProvinces());
  }

  @override
  String toString() {
    return '''
provinces: ${provinces},
isLoading: ${isLoading},
message: ${message}
    ''';
  }
}
