import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/core/util/pagination.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class GetTasksByUserUseCase
    implements UseCase<PaginatedResponse<Task>, GetTasksByUserParams> {
  final TaskRepository repository;

  GetTasksByUserUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, PaginatedResponse<Task>>> call(
    GetTasksByUserParams params,
  ) {
    return repository.getTasksByUser(params.userId, params.page);
  }
}

class GetTasksByUserParams extends Equatable {
  final int userId;
  final int page;

  const GetTasksByUserParams({required this.userId, required this.page});

  @override
  List<Object> get props => [userId, page];
}
