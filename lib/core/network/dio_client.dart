import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_manager/core/network/interceptors/jwt_interceptor.dart';

class DioClient {
  final Dio dio;
  final GetStorage storage;

  DioClient({required this.dio, required this.storage}) {
    dio
      ..options.baseUrl = dotenv.get('API_BASE_URL')
      
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..interceptors.add(JwtInterceptor(storage))
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ))
      ..options.validateStatus = (status) => status! < 500;
  }
}