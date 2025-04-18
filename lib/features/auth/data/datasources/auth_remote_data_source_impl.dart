import 'package:dio/dio.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> signIn(String email, String password) async {
    final response = await dioClient.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final authHeader = response.headers['authorization']?.first;
    final token = authHeader?.replaceFirst('Bearer ', '') ?? '';
    final userData = response.data is Map ? response.data as Map<String, dynamic> : {};
    return UserModel.fromJson({
    ...userData,
    'token': token.isNotEmpty ? token : (userData['token'] ?? ''),
  });
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    final response = await dioClient.dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
    });
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> signOut() async {
    await dioClient.dio.post('/auth/logout');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.dio.get(
        '/auth/me',
        options: Options(validateStatus: (status) => status! < 500),
      );
      
      if (response.statusCode == 401) {
        throw ServerException('Unauthorized - Please login again');
      }
      
      if (response.data == null) {
        throw ServerException('No user data received');
      }
      
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch user data');
    }
  }
}