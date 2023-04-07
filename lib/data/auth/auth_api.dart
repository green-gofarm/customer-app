import 'dart:convert';
import 'dart:ffi';

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

class AuthApi {
  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json',
  });

  FutureEither<UserModel> signUpCustomer(String token) async {
    final url = '${ENP.SIGN_UP}/customer';
    final options = RequestOptions(body: {'accessToken': token});

    try {
      final response = await _httpClient.sendRequest(url, METHOD.POST, options);
      final payload = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = payload['data'] as Map<String, dynamic>;
        return right(UserModel.fromJson(data));
      }
      throw (payload['resultMessage'] ?? SIGN_UP_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<UserModel> signInCustomer() async {
    final url = '${ENP.CUSTOMER}/my-profile';

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, null);
      final payload = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = payload['data'] as Map<String, dynamic>;
        return right(UserModel.fromJson(data));
      }

      if (response.statusCode == 404) {
        throw (ACCOUNT_NOT_FOUND);
      }

      throw (payload['resultMessage'] ?? SIGN_IN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<bool> subscribeMessageToken(String messageToken) async {
    final url = '${ENP.USER}/update-notification-token';
    final options = RequestOptions(body: {'token': messageToken});

    try {
      final response = await _httpClient.sendRequest(url, METHOD.POST, options);
      final payload = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return right(true);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<PagingModel<NotificationModel>> searchNotification(
      Map<String, String> params) async {
    final url = '${ENP.USER}/my-notification/search';
    final options = RequestOptions(queryParams: params);

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, options);
      final payload = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = payload['data'] as Map<String, dynamic>;
        return right(PagingModel<NotificationModel>.fromJson(
            data, (json) => NotificationModel.fromJson(json)));
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<bool> markAsRedNotification(String id) async {
    final url = '${ENP.USER}/my-notification/$id/read';

    try {
      final response = await _httpClient.sendRequest(url, METHOD.PATCH, null);
      final payload = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return right(true);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<bool> checkNewlySignupAccount(String authToken) async {
    final url = '${ENP.USER}/check-status';
    final options = RequestOptions(body: {'token': authToken});

    try {
      final response = await _httpClient.sendRequest(url, METHOD.POST, options);
      final payload = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final registered = payload['data']['registered'];
        if (registered != null) {
          return right(!registered);
        }
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }
}
