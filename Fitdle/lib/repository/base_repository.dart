import 'package:dio/dio.dart';
import 'package:fitdle/repository/api_response.dart';

class BaseRepository {
  final String _baseURL = "http://10.0.2.2:8000";
  final Dio _dio = Dio();

  Future<Object> fetch(endpoint, params) async {
    try {
      String url = _baseURL + endpoint;
      Response response = await _dio.get(url, queryParameters: params);
      return Success(response.data);
    } on DioError catch (e) {
      //TODO: add logger
      print(e.response?.headers);
      print(e.response?.data);
      return Failure(e.response?.data);
    }
  }

  Future<Object> post(endpoint, data) async {
    try {
      String url = _baseURL + endpoint;
      Response response = await _dio.post(url, data: data);
      return Success(response.data);
    } on DioError catch (e) {
      print(e.response?.headers);
      print(e.response?.data);
      return Failure(e.response?.data);
    }
  }
}