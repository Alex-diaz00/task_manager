import 'package:dartz/dartz.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/entities/project_response.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';

class GetMyProjectsUseCase implements UseCase<ProjectResponse, int> {
  final ProjectRepository repository;

  GetMyProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, ProjectResponse>> call(int page) {
    return repository.getMyProjects(page);
  }
}