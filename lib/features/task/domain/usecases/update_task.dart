import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class UpdateTaskUseCase implements UseCase<Task, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, Task>> call(UpdateTaskParams params) {
    return repository.updateTask(params);
  }
}

class UpdateTaskParams extends Equatable {
  final int taskId;
  final String name;
  final TaskStatus status;
  final TaskPriority? priority;
  final List<int> assigneeIds;

  const UpdateTaskParams({
    required this.taskId,
    required this.name,
    required this.status,
    this.priority,
    required this.assigneeIds,
  });

  @override
  List<Object?> get props => [taskId, name, status, priority, assigneeIds];
}