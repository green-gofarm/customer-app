import 'package:customer_app/data/farmstay/farmstay_api.dart';
import 'package:customer_app/main.dart';

import 'package:mobx/mobx.dart';

part 'farmstay_query_autocomplete_store.g.dart';

class FarmstayQueryAutocompleteStore = _FarmstayQueryAutocompleteStore
    with _$FarmstayQueryAutocompleteStore;

abstract class _FarmstayQueryAutocompleteStore with Store {
  final FarmstayApi _api = FarmstayApi();

  @observable
  List<String> suggests = [];

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  @action
  Future<void> getAutocompletes(String query) async {
    isLoading = true;

    if (query.isEmpty) {
      suggests.clear();
      isLoading = false;
      return;
    }

    final result = await _api.getAutoComplete(query);

    await result.fold(
      (error) {
        message = error;
        suggests.clear();
      },
      (r) {
        message = null;
        suggests = r;
      },
    );

    logger.i("Get suggests ${suggests}");
    if (message != null) {
      logger.e("Get suggests error $message");
    }

    isLoading = false;
  }
}
