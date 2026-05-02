import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final Dio _dio = Dio();

  Future<dynamic> getData(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.get(url, queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
