import 'package:dartz/dartz.dart' as dartz;
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

  class GetTaskUseCase implements UseCase<Task, int> {
  final TaskRepository repository;

  GetTaskUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, Task>> call(int taskId) {
    return repository.getTask(taskId);
  }
}