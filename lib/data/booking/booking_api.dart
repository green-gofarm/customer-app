import 'dart:convert';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/booking_model.dart';
import 'package:customer_app/models/customer_booking/CustomerBookingModel.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/http_client.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/error_message.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:fpdart/fpdart.dart';

import '../../utils/enum/order_status.dart';

typedef FutureEither<T> = Future<Either<String, T>>;

class BookingApi {
  final HttpClient _httpClient = HttpClient(headers: {
    'Content-Type': 'application/json; charset=utf-8',
  });

  FutureEither<String> createBooking(int farmstayId) async {
    final url = '${ENP.BOOKING}/create';
    final options = RequestOptions(body: {"farmstayId": farmstayId});

    try {
      final response = await _httpClient.sendRequest(url, METHOD.POST, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String referenceId = payload["data"]["referenceId"];
        return right(referenceId);
      }
      throw (payload['resultMessage'] ?? GET_CART_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<BookingModel> getBookingByReferenceId(String referenceId) async {
    final url = '${ENP.BOOKING}/check-status';
    final options = RequestOptions(queryParams: {"reference-id": referenceId});

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (payload["data"] == null) {
          throw IS_CREATING_BOOKING;
        }

        final booking = BookingModel.fromJson(payload["data"]);
        if (booking.status != OrderStatus.FAILED.value) {
          return right(booking);
        }

        if (booking.status == OrderStatus.FAILED.value) {
          throw CREATE_BOOKING_FAILED;
        }

        throw CREATE_BOOKING_FAILED;
      }

      throw (payload['resultMessage'] ?? GET_BOOKING_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<BookingModel> getBookingById(int id) async {
    final url = '${ENP.BOOKING}/${id}';

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (payload["data"] == null) {
          throw (UNKNOWN_ERROR_MESSAGE);
        }

        final booking = BookingModel.fromJson(payload["data"]);
        right(booking);
      }

      throw (payload['resultMessage'] ?? GET_BOOKING_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<List<CustomerBookingModel>> getAllCustomerBookings() async {
    final url = '${ENP.CUSTOMER}/${ENP.BOOKING}';

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as List<dynamic>;
        final bookings = data
            .map((booking) => CustomerBookingModel.fromJson(booking))
            .toList();
        return right(bookings);
      }

      throw (payload['resultMessage'] ?? GET_BOOKING_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<String> payBooking(int bookingId, String deviceIpAddress) async {
    final url = '${ENP.BOOKING}/payment';
    final options = RequestOptions(body: {
      "bookingId": bookingId,
      "deviceIpAddr": deviceIpAddress,
    });

    try {
      final response = await _httpClient.sendRequest(url, METHOD.POST, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (payload["data"]?["paymentUrl"] == null) {
          logger.i("Payload: ${payload.toString()}");
          throw ("Url không hợp lệ");
        }

        final String url = payload["data"]["paymentUrl"];
        return right(url);
      }
      throw (payload['resultMessage'] ?? GET_CART_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }
}
