import 'dart:async';
import 'dart:convert';
import 'package:bas_sdk_flutter_demo/Common.dart';
import 'package:bas_sdk_flutter_demo/model/OrderCheckOut.dart';
import 'package:http/http.dart' as http;

import 'model/InitiateTransactionResponse.dart';
import 'model/UserInfo.dart';
import 'api_response.dart';

class RestClient {
  RestClient({required this.httpClient});

  static const String baseUrl = 'https://bas-node-sdk.onrender.com';
  final http.Client httpClient;

  Future<UserInfo> getUserInfo({required String authId}) async {
    const loginUrl = '$baseUrl/auth/userinfo';
    final loginResult = await postAsync<dynamic>(loginUrl, {"authid": authId});

    if (!loginResult.success!) {
      throw Exception(loginResult.error);
    }
    return UserInfo.fromJson(loginResult.result);
  }

  Future<InitiateTransactionResponse> getPayment(
      {required OrderCheckOut order}) async {
    const url = '$baseUrl/order/checkout';
    final result = await postAsync<dynamic>(url, order);
    LOGW("getPayment result : ${result.success}");

    if (!result.success!) {
      LOGW("ERROR getPayment ");
      throw Exception(result.error);
    }
    LOGW("getPayment return result : ${result.success}");

    return result.result;
  }

  Future<InitiateTransactionResponse> getStatus(
      {required String orderId}) async {
    var url = '$baseUrl/order/status/$orderId';
    final result = await getAsync<dynamic>(url);

    if (!result.success!) {
      LOGW("ERROR getStatus result.error :${result.error}");
      throw Exception(result.error);
    }
    return InitiateTransactionResponse.fromJson(result.result);
  }

  // utils

  Future<ApiResponse<T?>> getAsync<T>(String resourcePath) async {
    var url = Uri.parse(resourcePath);

    LOGW('resourcePath : $resourcePath');

    var response = await httpClient.get(url, headers: {
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

    LOGW('resourcePath : $resourcePath');

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

      LOGW("jsonResult : $jsonResult");
      LOGW("response.statusCode : ${response.statusCode}");

      var output = ApiResponse<T?>(
        result: parsedJson,
        success: response.statusCode == 200,
      );
      LOGW("response.statusCode output : ${response.statusCode}");

      if (!output.success!) {
        output.error = parsedJson["messages"] ??
            'ERROR Something went wrong. Please try again';
      }
      LOGW("response.statusCode return output : ${response.statusCode}");

      return output;
    } catch (e) {
      LOGW("ERROR processResponse : $e");
      return ApiResponse<T?>(
          result: null,
          success: false,
          error: 'Something went wrong. Please try again');
    }
  }
}
