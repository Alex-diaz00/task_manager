

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/core/error/extract_errors.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/network/network_info.dart';
import 'package:task_manager/features/project/data/datasources/project_remote_data_source.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/domain/entities/project_response.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProjectResponse>> getProjects() async {
    return _handleRequest(() => remoteDataSource.getProjects());
  }

  @override
  Future<Either<Failure, Project>> createProject(String name, String? description,List<int> memberIds) async {
    return _handleRequest(() => remoteDataSource.createProject(name, description, memberIds));
  }

  @override
  Future<Either<Failure, Project>> updateProject(int id, String? name, String? description, bool? isArchived) async {
    return _handleRequest(() => remoteDataSource.updateProject(id, name, description, isArchived));
  }

  @override
  Future<Either<Failure, void>> deleteProject(int id) async {
    return _handleRequest(() => remoteDataSource.deleteProject(id));
  }

  @override
  Future<Either<Failure, List<Member>>> getAvailableMembers() async {
    return _handleRequest(() => remoteDataSource.getAvailableMembers());
  }
  
  Future<Either<Failure, T>> _handleRequest<T>(Future<T> Function() request) async {
  if (!await networkInfo.isConnected) {
    return Left(NetworkFailure('No internet connection'));
  }

  try {
    final response = await request();
    return Right(response);
  } on DioException catch (e) {
    if (e.response?.statusCode == 204) {
      return Right(null as T);
    }
    return Left(ServerFailure(ErrorHelpers.handleDioError(e)));
  } catch (e) {
    return Left(ServerFailure('An unexpected error occurred'));
  }
  }
}