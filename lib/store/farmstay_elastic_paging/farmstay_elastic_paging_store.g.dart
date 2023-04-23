// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmstay_elastic_paging_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FarmstayElasticPagingStore on _FarmstayElasticPagingStore, Store {
  Computed<PaginationModel>? _$PaginationComputed;

  @override
  PaginationModel get Pagination => (_$PaginationComputed ??=
          Computed<PaginationModel>(() => super.Pagination,
              name: '_FarmstayElasticPagingStore.Pagination'))
      .value;

  late final _$farmstaysAtom =
      Atom(name: '_FarmstayElasticPagingStore.farmstays', context: context);

  @override
  List<FarmstayModel> get farmstays {
    _$farmstaysAtom.reportRead();
    return super.farmstays;
  }

  @override
  set farmstays(List<FarmstayModel> value) {
    _$farmstaysAtom.reportWrite(value, super.farmstays, () {
      super.farmstays = value;
    });
  }

  late final _$paginationAtom =
      Atom(name: '_FarmstayElasticPagingStore.pagination', context: context);

  @override
  PaginationModel get pagination {
    _$paginationAtom.reportRead();
    return super.pagination;
  }

  @override
  set pagination(PaginationModel value) {
    _$paginationAtom.reportWrite(value, super.pagination, () {
      super.pagination = value;
    });
  }

  late final _$paramsAtom =
      Atom(name: '_FarmstayElasticPagingStore.params', context: context);

  @override
  Map<String, dynamic> get params {
    _$paramsAtom.reportRead();
    return super.params;
  }

  @override
  set params(Map<String, dynamic> value) {
    _$paramsAtom.reportWrite(value, super.params, () {
      super.params = value;
    });
  }

  late final _$queryAtom =
      Atom(name: '_FarmstayElasticPagingStore.query', context: context);

  @override
  String get query {
    _$queryAtom.reportRead();
    return super.query;
  }

  @override
  set query(String value) {
    _$queryAtom.reportWrite(value, super.query, () {
      super.query = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_FarmstayElasticPagingStore.isLoading', context: context);

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
      Atom(name: '_FarmstayElasticPagingStore.message', context: context);

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

  late final _$refreshAsyncAction =
      AsyncAction('_FarmstayElasticPagingStore.refresh', context: context);

  @override
  Future<void> refresh(
      {PaginationModel? newPagination,
      Map<String, dynamic>? newParams,
      required String query}) {
    return _$refreshAsyncAction.run(() => super.refresh(
        newPagination: newPagination, newParams: newParams, query: query));
  }

  late final _$handleChangePageSizeAsyncAction = AsyncAction(
      '_FarmstayElasticPagingStore.handleChangePageSize',
      context: context);

  @override
  Future<void> handleChangePageSize(int newPageSize) {
    return _$handleChangePageSizeAsyncAction
        .run(() => super.handleChangePageSize(newPageSize));
  }

  late final _$handleChangeParamsAsyncAction = AsyncAction(
      '_FarmstayElasticPagingStore.handleChangeParams',
      context: context);

  @override
  Future<void> handleChangeParams(Map<String, dynamic> params) {
    return _$handleChangeParamsAsyncAction
        .run(() => super.handleChangeParams(params));
  }

  @override
  String toString() {
    return '''
farmstays: ${farmstays},
pagination: ${pagination},
params: ${params},
query: ${query},
isLoading: ${isLoading},
message: ${message},
Pagination: ${Pagination}
    ''';
  }
}
