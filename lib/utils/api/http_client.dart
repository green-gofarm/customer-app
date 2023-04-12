import 'dart:async';
import 'dart:convert';
import 'package:customer_app/services/auth_service.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/enum/method.dart';

import 'package:http/http.dart';

class HttpClient {
  final String baseUrl = DOMAIN;
  final Map<String, String>? headers;

  HttpClient({this.headers});

  Future<String> getFirebaseToken() async {
    final String? token;

    try {
      token = await AuthService.getFirebaseAuthToken(false);
      if (token == null) {
        throw Exception("Firebase auth token not found.");
      }
    } catch (error) {
      AuthService.signOut();
      rethrow;
    }

    return token;
  }

  Future<void> setupRequestHeader(
      Request request, RequestOptions? options, bool includeToken) async {
    if (headers != null) {
      request.headers.addAll(headers!);
    }

    if (options?.headers != null) {
      request.headers.addAll(options!.headers!);
    }

    if (options?.body != null) {
      request.body = jsonEncode(options!.body);
    }

    if (includeToken) {
      final String token = await getFirebaseToken();
      request.headers.addAll({'Authorization': 'Bearer $token'});
    }
  }

  Future<Response> sendRequest(
      String path, METHOD method, RequestOptions? options) async {
    final Uri uri = Uri.parse('$baseUrl/$path')
        .replace(queryParameters: options?.queryParams);
    final Request request = Request(method.value, uri);

    try {
      await setupRequestHeader(request, options, true);

      final response = await Client().send(request);
      return Response.fromStream(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendRequestCustomUrl(
      String url, METHOD method, RequestOptions? options) async {
    final Uri uri = Uri.parse('$url')
        .replace(queryParameters: options?.queryParams);
    final Request request = Request(method.value, uri);

    try {
      await setupRequestHeader(request, options, true);

      final response = await Client().send(request);
      return Response.fromStream(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendUnAuthRequest(
      String path, METHOD method, RequestOptions? options) async {
    final Uri uri = Uri.parse('$baseUrl/$path')
        .replace(queryParameters: options?.queryParams);
    final Request request = Request(method.value, uri);

    try {
      await setupRequestHeader(request, options, false);
      final response = await Client().send(request);

      return Response.fromStream(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendUnAuthRequestCustomUrl(
      String url, METHOD method, RequestOptions? options) async {
    final Uri uri = Uri.parse('$url')
        .replace(queryParameters: options?.queryParams);
    final Request request = Request(method.value, uri);

    try {
      await setupRequestHeader(request, options, false);

      final response = await Client().send(request);
      return Response.fromStream(response);
    } catch (e) {
      rethrow;
    }
  }
}
