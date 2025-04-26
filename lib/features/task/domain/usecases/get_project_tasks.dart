import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/core/util/pagination.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class GetProjectTasksUseCase
    implements UseCase<PaginatedResponse<Task>, GetProjectTasksParams> {
  final TaskRepository repository;

  GetProjectTasksUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, PaginatedResponse<Task>>> call(
    GetProjectTasksParams params,
  ) {
    return repository.getProjectTasks(params.projectId, params.page);
  }
}

class GetProjectTasksParams extends Equatable {
  final int projectId;
  final int page;

  const GetProjectTasksParams({required this.projectId, required this.page});

  @override
  List<Object> get props => [projectId, page];
}
