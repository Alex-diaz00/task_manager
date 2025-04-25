import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class CreateTaskUseCase implements UseCase<Task, CreateTaskParams> {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, Task>> call(CreateTaskParams params) {
    return repository.createTask(params);
  }
}

class CreateTaskParams extends Equatable {
  final int projectId;
  final String name;
  final TaskStatus status;
  final TaskPriority priority;
  final List<int> assigneeIds;

  const CreateTaskParams({
    required this.projectId,
    required this.name,
    required this.status,
    required this.priority,
    required this.assigneeIds,
  });

  @override
  List<Object> get props => [projectId, name, status, priority, assigneeIds];
}