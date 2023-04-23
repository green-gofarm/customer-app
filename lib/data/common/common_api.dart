import 'dart:convert';

import 'package:customer_app/models/address_model.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

class CommonApi {
  static const String PROVINCE_API = 'https://provinces.open-api.vn/api/';

  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json',
  });

  FutureEither<List<ProvinceModel>> getAllProvinces() async {
    final url = PROVINCE_API;

    try {
      final response =
          await _httpClient.sendUnAuthRequestCustomUrl(url, METHOD.GET, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (payload is List) {
          final provinces =
              payload.map((json) => ProvinceModel.fromJson(json)).toList();
          return right(provinces);
        }
      }

      throw (payload['message'] ?? 'Unknown error occurred');
    } catch (e) {
      return left(e.toString());
    }
  }
}
