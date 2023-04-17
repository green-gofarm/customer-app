import 'dart:convert';
import 'package:customer_app/models/Cart.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:fpdart/fpdart.dart';
import 'package:customer_app/models/create_cart_item.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

class CartApi {
  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json; charset=utf-8',
  });

  FutureEither<Cart> getCartOfFarmstay(int id) async {
    final url = '${ENP.FARMSTAY}/$id/${ENP.CART}';

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        return right(Cart.fromJson(data));
      }
      throw (payload['resultMessage'] ?? GET_CART_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<bool> addToCart(int farmstayId, List<CreateCartItem> items) async {
    final url = '${ENP.FARMSTAY}/$farmstayId/${ENP.CART}/multiple';
    final options = RequestOptions(body: items.map((item) => item.toJson()).toList());

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

  FutureEither<bool> removeItems(int farmstayId, int itemId) async {
    final url = '${ENP.FARMSTAY}/$farmstayId/${ENP.CART}/items/$itemId';

    try {
      final response = await _httpClient.sendRequest(url, METHOD.DELETE, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(true);
      }
      throw (payload['resultMessage'] ?? GET_CART_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<bool> clearCart(int farmstayId) async {
    final url = '${ENP.FARMSTAY}/$farmstayId/${ENP.CART}';

    try {
      final response = await _httpClient.sendRequest(url, METHOD.DELETE, null);
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
