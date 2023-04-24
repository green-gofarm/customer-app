import 'dart:convert';

import 'package:customer_app/data/auth/auth_api.dart';
import 'package:customer_app/models/user_model.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

class UserApi {
  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json; charset=utf-8',
  });

  FutureEither<bool> updateProfile(Map<String, dynamic> body) async {
    final url = '${ENP.CUSTOMER}/my-profile';
    final options = RequestOptions(body: body);

    try {
      final response =
          await _httpClient.sendRequest(url, METHOD.PATCH, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(true);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<List<String>> uploadImage(List<XFile> files) async {
    final url = '${ENP.IMAGES}';

    try {
      final response = await _httpClient.uploadMultipleFiles(url, files, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'];
        if (data is List) {
          final urls = data.map((json) => json as String).toList();
          return right(urls);
        }
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }
}
