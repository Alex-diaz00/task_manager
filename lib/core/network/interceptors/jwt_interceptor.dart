import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class JwtInterceptor extends Interceptor {
  final GetStorage storage;

  JwtInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = storage.read('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}