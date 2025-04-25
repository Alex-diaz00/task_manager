import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:task_manager/core/error/extract_errors.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/network/network_info.dart';
import 'package:task_manager/core/util/pagination.dart';
import 'package:task_manager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<dartz.Either<Failure, Task>> createTask(CreateTaskParams params) async {
    return _handleRequest(() => remoteDataSource.createTask(params));
  }

  @override
  Future<dartz.Either<Failure, Task>> updateTask(UpdateTaskParams params) async {
    return _handleRequest(() => remoteDataSource.updateTask(params));
  }

  @override
  Future<dartz.Either<Failure, void>> deleteTask(int taskId) async {
    return _handleRequest(() => remoteDataSource.deleteTask(taskId));
  }

  @override
  Future<dartz.Either<Failure, Task>> getTask(int taskId) async {
    return _handleRequest(() => remoteDataSource.getTask(taskId));
  }

  @override
  Future<dartz.Either<Failure, PaginatedResponse<Task>>> getProjectTasks(
      int projectId, int page) async {
    return _handleRequest(() => remoteDataSource.getProjectTasks(projectId, page));
  }

  Future<dartz.Either<Failure, T>> _handleRequest<T>(Future<T> Function() request) async {
    if (!await networkInfo.isConnected) {
      return dartz.Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await request();
      return dartz.Right(response);
    } on DioException catch (e) {
      return dartz.Left(ServerFailure(ErrorHelpers.handleDioError(e)));
    } catch (e) {
      return dartz.Left(ServerFailure('An unexpected error occurred'));
    }
  }
}