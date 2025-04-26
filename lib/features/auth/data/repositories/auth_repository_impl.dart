import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/network/network_info.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/domain/entities/user_entity.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    return _handleRequest(() => remoteDataSource.signIn(email, password));
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      final user = await remoteDataSource.signUp(email, password, name);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on FormatException catch (_) {
      return Left(ServerFailure('Invalid user data format received'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return _handleRequest(() => remoteDataSource.signOut());
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      if (e.message.contains('Session expired')) {
        return Left(UnauthorizedFailure(e.message));
      }
      return Left(ServerFailure(e.message));
    } on FormatException catch (_) {
      return Left(ServerFailure('Invalid user profile data format'));
    }
  }

  Future<Either<Failure, T>> _handleRequest<T>(
    Future<T> Function() request,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await request();
      return Right(response);
    } on DioException catch (e) {
      return await _handleDioError<T>(e);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  Future<Either<Failure, T>> _handleDioError<T>(DioException e) async {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Left(NetworkFailure('Connection problems, check your internet'));
    }

    if (e.response == null) {
      return Left(ServerFailure('No response from server'));
    }

    final statusCode = e.response!.statusCode;
    final responseData = e.response!.data;

    switch (statusCode) {
      case 400:
        final errorMsg = _extractErrorMessage(responseData);
        return Left(BadRequestFailure(errorMsg));

      case 401:
        await secureStorage.delete(key: 'access_token');
        return Left(
          UnauthorizedFailure(
            _extractErrorMessage(responseData, defaultMsg: 'Session expired'),
          ),
        );

      case 404:
        return Left(
          NotFoundFailure(
            _extractErrorMessage(
              responseData,
              defaultMsg: 'Resource not found',
            ),
          ),
        );

      case 500:
        return Left(
          ServerFailure(
            _extractErrorMessage(
              responseData,
              defaultMsg: 'Internal server error',
            ),
          ),
        );

      default:
        return Left(
          ServerFailure(
            _extractErrorMessage(
              responseData,
              defaultMsg: 'Unknown server error',
            ),
          ),
        );
    }
  }

  String _extractErrorMessage(dynamic responseData, {String defaultMsg = ''}) {
    try {
      if (responseData is Map) {
        return responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            defaultMsg;
      }
      return responseData.toString();
    } catch (e) {
      return defaultMsg;
    }
  }
}
