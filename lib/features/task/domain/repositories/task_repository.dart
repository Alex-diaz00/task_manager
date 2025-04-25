import 'package:dartz/dartz.dart' as dartz;
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/util/pagination.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';

abstract class TaskRepository {
  Future<dartz.Either<Failure, Task>> createTask(CreateTaskParams params);
  Future<dartz.Either<Failure, Task>> updateTask(UpdateTaskParams params);
  Future<dartz.Either<Failure, void>> deleteTask(int taskId);
  Future<dartz.Either<Failure, Task>> getTask(int taskId);
  Future<dartz.Either<Failure, PaginatedResponse<Task>>> getProjectTasks(
      int projectId, int page);
}