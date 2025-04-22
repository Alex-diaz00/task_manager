import 'package:dio/dio.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/core/error/extract_errors.dart';
import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final authHeader = response.headers['authorization']?.first;
        final token = authHeader?.replaceFirst('Bearer ', '') ?? '';

        if (token.isEmpty) {
          throw ServerException('No authentication token received');
        }

        if (response.data == null || response.data is! Map) {
          throw ServerException('Invalid user data received');
        }

        final userData = response.data as Map<String, dynamic>;

        if (userData['id'] == null || userData['email'] == null) {
          throw ServerException('Incomplete user data received');
        }

        return UserModel.fromJson({...userData, 'token': token});
      } else {
        final errorMessage =
            ErrorHelpers.extractErrorMessage(response.data) ??
            'Login failed (status ${response.statusCode})';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      throw ServerException(ErrorHelpers.handleDioError(e));
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'name': name},
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final authHeader = response.headers['authorization']?.first;
        final token = authHeader?.replaceFirst('Bearer ', '') ?? '';

        if (token.isEmpty) {
          throw ServerException(
            'No authentication token received after registration',
          );
        }

        if (response.data == null || response.data is! Map) {
          throw ServerException('Invalid registration data received');
        }

        final userData = response.data as Map<String, dynamic>;

        if (userData['id'] == null || userData['email'] == null) {
          throw ServerException(
            'Incomplete user data received after registration',
          );
        }

        return UserModel.fromJson({...userData, 'token': token});
      } else {
        final errorMessage =
            ErrorHelpers.extractErrorMessage(response.data) ??
            'Registration failed (status ${response.statusCode})';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      throw ServerException(ErrorHelpers.handleDioError(e));
    }
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
        throw ServerException('Session expired - Please login again');
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data == null || response.data is! Map) {
          throw ServerException('Invalid user data format');
        }

        final userData = response.data as Map<String, dynamic>;

        if (userData['id'] == null || userData['email'] == null) {
          throw ServerException('Incomplete user profile data');
        }

        return UserModel.fromJson(userData);
      } else {
        final errorMessage =
            ErrorHelpers.extractErrorMessage(response.data) ??
            'Failed to fetch user profile (status ${response.statusCode})';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      throw ServerException(ErrorHelpers.handleDioError(e));
    }
  }
}
