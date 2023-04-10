import 'dart:convert';

import 'package:customer_app/models/activity_model.dart';
import 'package:customer_app/models/activity_schedule_model.dart';
import 'package:customer_app/models/farmstay_model.dart';
import 'package:customer_app/models/farmstay_schedule_model.dart';
import 'package:customer_app/models/notification_model.dart';
import 'package:customer_app/models/paging_model.dart';
import 'package:customer_app/models/room_model.dart';
import 'package:customer_app/models/room_schedule_model.dart';
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
    'Content-Type': 'application/json; charset=utf-8;',
  });

  FutureEither<PagingModel<FarmstayModel>> searchFarmstayWithElastic(
      Map<String, String> params) async {
    final url = '${ENP.FARMSTAY}/elastic-search';
    final options = RequestOptions(queryParams: params);

    try {
      final response = await _httpClient.sendRequest(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        return right(PagingModel<FarmstayModel>.fromJson(
            data, (json) => FarmstayModel.fromJson(json)));
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<List<FarmstayModel>> getTopRatedFarmstay(int limit) async {
    final url = '$DOMAIN_V2/${ENP.FARMSTAY}/top-rated';
    final options = RequestOptions(queryParams: {"limit": "$limit"});

    try {
      final response =
          await _httpClient.sendRequestCustomUrl(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as List<dynamic>;
        final farmstayList =
            data.map((json) => FarmstayModel.fromJson(json)).toList();
        return right(farmstayList);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<List<ActivityModel>> getTopBookedActivities(int limit) async {
    final url = '$DOMAIN_V2/${ENP.ACTIVITIES}/top-booked';
    final options = RequestOptions(queryParams: {"limit": "$limit"});

    try {
      final response =
          await _httpClient.sendRequestCustomUrl(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as List<dynamic>;
        final activities =
            data.map((json) => ActivityModel.fromJson(json)).toList();
        return right(activities);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<List<RoomModel>> getTopBookedRooms(int limit) async {
    final url = '$DOMAIN_V2/${ENP.ROOMS}/top-booked';
    final options = RequestOptions(queryParams: {"limit": "$limit"});

    try {
      final response =
          await _httpClient.sendRequestCustomUrl(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as List<dynamic>;
        final rooms = data.map((json) => RoomModel.fromJson(json)).toList();
        return right(rooms);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<FarmstayScheduleModel> getFarmstaySchedule(
      int farmstayId, String date, int limit) async {
    final url = '$DOMAIN_V2/${ENP.FARMSTAY}/$farmstayId/schedule';
    final options =
        RequestOptions(queryParams: {"date": "$date", "limit": "$limit"});

    try {
      final response =
          await _httpClient.sendRequestCustomUrl(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        final farmstaySchedule = FarmstayScheduleModel.fromJson(data);
        return right(farmstaySchedule);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<ActivityScheduleModel> getActivitySchedule(
      int farmstayId, int activityId, String date, int limit) async {
    final url =
        '$DOMAIN_V2/${ENP.FARMSTAY}/$farmstayId/${ENP.ACTIVITIES}/$activityId/schedule';
    final options =
        RequestOptions(queryParams: {"date": "$date", "limit": "$limit"});

    try {
      final response =
          await _httpClient.sendRequestCustomUrl(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        final roomSchedule = ActivityScheduleModel.fromJson(data);
        return right(roomSchedule);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<RoomScheduleModel> getRoomSchedule(
      int farmstayId, int roomId, String date, int limit) async {
    final url =
        '$DOMAIN_V2/${ENP.FARMSTAY}/$farmstayId/${ENP.ROOMS}/$roomId/schedule';
    final options =
        RequestOptions(queryParams: {"date": "$date", "limit": "$limit"});

    try {
      final response =
          await _httpClient.sendRequestCustomUrl(url, METHOD.GET, options);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        final roomSchedule = RoomScheduleModel.fromJson(data);
        return right(roomSchedule);
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<FarmstayModel> getFarmstayDetail(int id) async {
    final url = '$DOMAIN_V2/${ENP.FARMSTAY}/$id';

    try {
      final response =
          await _httpClient.sendRequestCustomUrl(url, METHOD.GET, null);
      final payload = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = payload['data'] as Map<String, dynamic>;
        return right(FarmstayModel.fromJson(data));
      }
      throw (payload['resultMessage'] ?? UNKNOWN_ERROR_MESSAGE);
    } catch (e) {
      return left(e.toString());
    }
  }
}
