


import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';

class UpdateProjectUseCase implements UseCase<Project, UpdateProjectParams> {
  final ProjectRepository repository;

  UpdateProjectUseCase(this.repository);

  @override
  Future<Either<Failure, Project>> call(UpdateProjectParams params) {
    return repository.updateProject(params.id, params.name, params.description, params.isArchived );
  }
}

class UpdateProjectParams extends Equatable {
  final int id;
  final String? name;
  final String? description;
  final bool? isArchived;

  const UpdateProjectParams({
    required this.id,
    this.name,
    this.description,
    this.isArchived,

  });

  @override
  List<Object?> get props => [id, name, description, isArchived];
}