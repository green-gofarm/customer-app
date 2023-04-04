
import 'dart:convert';
import 'package:customer_app/auth.dart';
import 'package:customer_app/screens/RFMobileSignInScreen.dart';
import 'package:customer_app/utils/api/end_points.dart';
import 'package:customer_app/utils/api/request_options.dart';
import 'package:customer_app/utils/enum/method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class HttpClient {
  final String baseUrl = DOMAIN;
  final Map<String, String>? headers;

  HttpClient({this.headers});

  Future<void> setupRequestHeader (Request request, RequestOptions? options) async {
    final String? token = await FirebaseAuth.instance.currentUser!.getIdToken();

    if(token == null) {
      FirebaseAuth.instance.signOut();
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RFMobileSignIn()),
            (route) => false,
      );

      return;
    }

    request.headers.addAll({'Authorization': 'Bearer $token'});

    if (headers != null) {
      request.headers.addAll(headers!);
    }

    if (options?.headers != null) {
      request.headers.addAll(options!.headers!);
    }

    if (options?.body != null) {
      request.body = jsonEncode(options!.body);
    }
  }

  Future<Response> sendRequest(
      String path, METHOD method, RequestOptions? options) async {

    final Uri uri = Uri.parse('$baseUrl$path').replace(queryParameters: options?.queryParams);
    final Request request = Request(method.value, uri);

    await setupRequestHeader(request, options);

    final response = await Client().send(request);

    if (response.statusCode >= 400) {
      throw Exception('HTTP request failed: ${response.reasonPhrase}');
    }

    return Response.fromStream(response);
  }
}
