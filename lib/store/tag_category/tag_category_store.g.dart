// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_category_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TagCategoryStore on _TagCategoryStore, Store {
  late final _$categoryMapAtom =
      Atom(name: '_TagCategoryStore.categoryMap', context: context);

  @override
  Map<int, TagCategoryModel> get categoryMap {
    _$categoryMapAtom.reportRead();
    return super.categoryMap;
  }

  @override
  set categoryMap(Map<int, TagCategoryModel> value) {
    _$categoryMapAtom.reportWrite(value, super.categoryMap, () {
      super.categoryMap = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_TagCategoryStore.isLoading', context: context);

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
      Atom(name: '_TagCategoryStore.message', context: context);

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

  late final _$getAllTagCategoriesAsyncAction =
      AsyncAction('_TagCategoryStore.getAllTagCategories', context: context);

  @override
  Future<void> getAllTagCategories({bool? force}) {
    return _$getAllTagCategoriesAsyncAction
        .run(() => super.getAllTagCategories(force: force));
  }

  @override
  String toString() {
    return '''
categoryMap: ${categoryMap},
isLoading: ${isLoading},
message: ${message}
    ''';
  }
}
