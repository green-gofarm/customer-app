import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final HttpClient _httpClient = HttpClient();

  Future<http.Response> signUpCustomer(String token) async {
    final url = '${ENP.SIGN_UP}/customer';
    final options = RequestOptions(
      headers: {
        'Content-Type': 'application/json',
      },
      body: {'accessToken': token},
    );
    return _httpClient.sendRequest(url, METHOD.POST, options);
  }

  Future<http.Response> signInCustomer() async {
    final url = '${ENP.CUSTOMER}/my-profile';
    return _httpClient.sendRequest(url, METHOD.GET, null);
  }

  Future<http.Response> subscribeMessageToken(String token) async {
    final url = '${ENP.USER}/update-notification-token';
    final options = RequestOptions(
      headers: {
        'Content-Type': 'application/json',
      },
      body: {'token': token},
    );
    return _httpClient.sendRequest(url, METHOD.POST, options);
  }

  Future<http.Response> searchNotification(Map<String, String> params) async {
    final url = '${ENP.USER}/my-notification/search';
    final options = RequestOptions(
      headers: {
        'Content-Type': 'application/json',
      },
      queryParams: params,
    );
    return _httpClient.sendRequest(url, METHOD.GET, options);
  }

  Future<http.Response> markAsRedNotification(String id) async {
    final url = '${ENP.USER}/my-notification/$id/read';
    final options = RequestOptions(
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return _httpClient.sendRequest(url, METHOD.PATCH, options);
  }

  Future<http.Response> checkNewlySignupAccount(String token) async {
    final url = '${ENP.USER}/check-status';
    final options = RequestOptions(
      headers: {
        'Content-Type': 'application/json',
      },
      body: {'token': token},
    );
    return _httpClient.sendRequest(url, METHOD.POST, options);
  }
}
