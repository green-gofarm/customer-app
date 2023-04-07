import 'dart:convert';

import 'package:customer_app/models/notification_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/models/user_model.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

class FarmstayApi {
  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json',
  });

  FutureEither<PagingModel<NotificationModel>> searchFarmstayWithElastic(
      Map<String, String> params) async {
    final url = '${ENP.FARMSTAY}/elastic-search';
    final options = RequestOptions(queryParams: params);

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, options);
      final payload = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        return right(PagingModel<NotificationModel>.fromJson(
            data, (json) => NotificationModel.fromJson(json)));
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }
}
