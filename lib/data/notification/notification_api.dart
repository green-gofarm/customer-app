import 'dart:convert';
import 'package:customer_app/models/notification_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

class NotificationApi {
  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json; charset=utf-8',
  });

  FutureEither<bool> updateNotificationToken(String token) async {
    final url = '${ENP.USER}/update-notification-token';
    final options = RequestOptions(body: {"token": token});

    try {
      final response = await _httpClient.sendRequest(url, METHOD.POST, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(true);
      }
      throw (payload['resultMessage'] ?? GET_CART_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<PagingModel<NotificationModel>> getNotifications(
      Map<String, dynamic> params) async {
    final url = '${ENP.USER}/my-notification/search';
    final options = RequestOptions(queryParams: params);

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (payload["data"] == null) {
          throw (UNKNOWN_ERROR_MESSAGE);
        }

        final data = payload['data'] as Map<String, dynamic>;
        final farmstayPaging = PagingModel<NotificationModel>.fromJson(
            data, (json) => NotificationModel.fromJson(json));
        return right(farmstayPaging);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<bool> makeNotificationAsRead(int id) async {
    final url = '${ENP.USER}/my-notification/$id/read';
    final options = RequestOptions(body: {});

    try {
      final response =
          await _httpClient.sendRequest(url, METHOD.PATCH, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(true);
      }
      throw (payload['resultMessage'] ?? GET_CART_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }
}
