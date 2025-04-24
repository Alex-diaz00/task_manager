

import 'package:dartz/dartz.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';

class UpdateProjectMembersUseCase implements UseCase<Project, UpdateProjectMembersParams> {
  final ProjectRepository repository;

  UpdateProjectMembersUseCase(this.repository);

  @override
  Future<Either<Failure, Project>> call(UpdateProjectMembersParams params) {
    return repository.updateProjectMembers(params);
  }
}

class UpdateProjectMembersParams {
  final int projectId;
  final List<int> memberIds;

  UpdateProjectMembersParams({
    required this.projectId,
    required this.memberIds,
  });
}