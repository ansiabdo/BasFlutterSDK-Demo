import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'UserInfo.dart';
import 'api_response.dart';

class RestClient {
  RestClient({required this.httpClient});

  static const String baseUrl = 'https://bas-node-sdk.onrender.com';
  final http.Client httpClient;

  Future<UserInfo> getUserInfo({required String authId}) async {
    final loginUrl = '$baseUrl/auth/userinfo';
    final loginResult = await postAsync<dynamic>(loginUrl, {"authid": authId});

    if (!loginResult.success!) {
      throw Exception(loginResult.error);
    }
    return UserInfo.fromJson(loginResult.result);
  }

  Future<dynamic> getPayment({required String authId}) async {
    final loginUrl = '$baseUrl/order/checkout';
    final loginResult =
        await this.postAsync<dynamic>(loginUrl, {"authid": authId});

    if (!loginResult.success!) {
      throw Exception(loginResult.error);
    }
    return loginResult.result;
  }

  // utils

  Future<ApiResponse<T?>> getAsync<T>(String resourcePath) async {
    var url = Uri.parse(resourcePath);

    print('resourcePath : ' + resourcePath);

    var response = await this.httpClient.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    return processResponse<T>(response);
  }

  Future<ApiResponse<T?>> postAsync<T>(
      String resourcePath, dynamic data) async {
    var content = json.encoder.convert(data);
    Map<String, String> headers;

    headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    print('resourcePath : ' + resourcePath);

    var url = Uri.parse(resourcePath);

    var response = await http.post(url, body: content, headers: headers);
    return processResponse<T>(response);
  }

  Future<ApiResponse<T?>> deleteAsync<T>(String resourcePath) async {
    Map<String, String> headers;

    // TODO: throw exception
    headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var url = Uri.parse(resourcePath);
    var response = await http.delete(url, headers: headers);
    return processResponse<T>(response);
  }

  ApiResponse<T?> processResponse<T>(http.Response response) {
    try {
      var jsonResult = response.body;
      dynamic parsedJson = jsonDecode(jsonResult);

      print(jsonResult);

      var output = ApiResponse<T?>(
        result: parsedJson,
        success: response.statusCode == 200,
      );

      if (!output.success!) {
        output.error = parsedJson["messages"];
      }
      return output;
    } catch (e) {
      return ApiResponse<T?>(
          result: null,
          success: false,
          error: 'Something went wrong. Please try again');
    }
  }
}
