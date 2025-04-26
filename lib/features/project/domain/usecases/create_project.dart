import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';

class CreateProjectUseCase implements UseCase<Project, CreateProjectParams> {
  final ProjectRepository repository;

  CreateProjectUseCase(this.repository);

  @override
  Future<Either<Failure, Project>> call(CreateProjectParams params) {
    return repository.createProject(
      params.name,
      params.description,
      params.members,
    );
  }
}

class CreateProjectParams extends Equatable {
  final String name;
  final String? description;
  final List<int> members;

  const CreateProjectParams({
    required this.name,
    this.description,
    required this.members,
  });

  @override
  List<Object?> get props => [name, description, members];
}
