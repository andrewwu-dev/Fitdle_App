import 'package:dio/dio.dart';
import 'package:fitdle/repository/api_response.dart';

class BaseRepository {
  // Note: for dev purposes choose a base url depending on ios or android
  final String _baseURL = "http://10.0.2.2:8000";
  //final String _baseURL = "http://localhost:8000";

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
    } on Exception catch(e) {
      return Failure(e.toString());
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
    } on Exception catch(e) {
      return Failure(e.toString());
    }
  }
}