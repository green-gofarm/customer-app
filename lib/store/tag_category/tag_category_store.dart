import 'package:customer_app/data/category/tag_category_api.dart';
import 'package:customer_app/main.dart';

import 'package:customer_app/models/tag_category_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';

part 'tag_category_store.g.dart';

class TagCategoryStore = _TagCategoryStore with _$TagCategoryStore;

const LIMIT = 0;

abstract class _TagCategoryStore with Store {
  final TagCategoryApi _api = TagCategoryApi();

  @observable
  Map<int, TagCategoryModel> categoryMap = {};

  @observable
  List<TagCategoryModel> categories = [];

  @observable
  bool isLoading = false;

  @observable
  String? message = null;

  @action
  Future<void> getAllTagCategories({bool? force}) async {
    if (force != true && categoryMap.size > 0) {
      return;
    }

    isLoading = true;
    categoryMap.clear();

    final result = await _api.getAllTagCategories();

    await result.fold(
      (error) {
        message = error;
      },
      (categories) {
        categories.forEach((category) => categoryMap[category.id] = category);
      },
    );

    logger.i("Get all tag categories ${categoryMap.toString()}");
    if (message != null) {
      logger.e("Get all tag categories error $message");
    }

    isLoading = false;
  }

  @action
  Future<void> getListCategories() async {
    if(categories.length > 0) return;
    isLoading = true;

    final result = await _api.getAllTagCategories();

    await result.fold(
      (error) {
        message = error;
        categories.clear();
      },
      (categories) {
        this.categories = categories;
        message = null;
      },
    );

    logger.i("Get list tag categories ${categories}");
    if (message != null) {
      logger.e("Get list tag categories error $message");
    }

    isLoading = false;
  }
}
