import 'dart:convert';

import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/models/tag_category_model.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

class TagCategoryApi {
  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json; charset=utf-8',
  });

  Future<Either<String, List<TagCategoryModel>>> getAllTagCategories() async {
    final url = ENP.TAG_CATEGORY;

    try {
      final response = await _httpClient.sendUnAuthRequest(url, METHOD.GET, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'];
        if (data is List) {
          final tagCategories = data.map((json) => TagCategoryModel.fromJson(json)).toList();
          return right(tagCategories);
        }
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }


  FutureEither<PagingModel<FarmstayModel>> searchFarmstay(
      Map<String, String> params) async {
    final url = '${ENP.FARMSTAY}/search';
    final options = RequestOptions(queryParams: params);

    try {
      final response = await _httpClient.sendUnAuthRequest(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        final farmstayPaging =PagingModel<FarmstayModel>.fromJson(
            data, (json) => FarmstayModel.fromJson(json));
        return right(farmstayPaging);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }
}
