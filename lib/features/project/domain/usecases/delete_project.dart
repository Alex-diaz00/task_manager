import 'package:dartz/dartz.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';

class DeleteProjectUseCase implements UseCase<void, int> {
  final ProjectRepository repository;

  DeleteProjectUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int projectId) {
    return repository.deleteProject(projectId);
  }
}
