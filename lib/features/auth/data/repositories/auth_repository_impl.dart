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
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    return _handleRequest(() => remoteDataSource.signIn(email, password));
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(String email, String password, String name) async {
    return _handleRequest(() => remoteDataSource.signUp(email, password, name));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return _handleRequest(() => remoteDataSource.signOut());
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final token = await secureStorage.read(key: 'access_token');
      if (token == null || token.isEmpty) {
        return Left(CacheFailure('No authentication token found'));
      }

      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get user data'));
    }
  }

  Future<Either<Failure, T>> _handleRequest<T>(Future<T> Function() request) async {
  if (!await networkInfo.isConnected) {
    return Left(NetworkFailure('No internet connection'));
  }

  try {
    final response = await request();
    return Right(response);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      await secureStorage.delete(key: 'access_token');
      return Left(UnauthorizedFailure('Unauthorized'));
    } else if (e.response?.statusCode == 404) {
      return Left(NotFoundFailure('Resource not found'));
    } else if (e.response?.statusCode == 400) {
      final errorMessage = e.response?.data['message'] ?? 'Invalid request';
      return Left(BadRequestFailure(errorMessage));
    } else if (e.response?.statusCode == 500) {
      return Left(ServerFailure('Internal server error'));
    } else {
      return Left(ServerFailure(
        e.response?.data['message']?.toString() ?? 
        e.message ?? 
        'Unknown error occurred'
      ));
    }
  } catch (e) {
    return Left(ServerFailure('Unknown error: ${e.toString()}'));
  }
}
}