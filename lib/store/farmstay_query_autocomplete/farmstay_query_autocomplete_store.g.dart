// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmstay_query_autocomplete_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FarmstayQueryAutocompleteStore
    on _FarmstayQueryAutocompleteStore, Store {
  late final _$suggestsAtom =
      Atom(name: '_FarmstayQueryAutocompleteStore.suggests', context: context);

  @override
  List<String> get suggests {
    _$suggestsAtom.reportRead();
    return super.suggests;
  }

  @override
  set suggests(List<String> value) {
    _$suggestsAtom.reportWrite(value, super.suggests, () {
      super.suggests = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_FarmstayQueryAutocompleteStore.isLoading', context: context);

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
      Atom(name: '_FarmstayQueryAutocompleteStore.message', context: context);

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

  late final _$getAutocompletesAsyncAction = AsyncAction(
      '_FarmstayQueryAutocompleteStore.getAutocompletes',
      context: context);

  @override
  Future<void> getAutocompletes(String query) {
    return _$getAutocompletesAsyncAction
        .run(() => super.getAutocompletes(query));
  }

  @override
  String toString() {
    return '''
suggests: ${suggests},
isLoading: ${isLoading},
message: ${message}
    ''';
  }
}
