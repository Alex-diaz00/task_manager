
import 'package:dartz/dartz.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/domain/entities/project_response.dart';
import 'package:task_manager/features/project/domain/usecases/update_members.dart';

abstract class ProjectRepository {
  Future<Either<Failure, ProjectResponse>> getProjects(int page);
  Future<Either<Failure, Project>> createProject(String name, String? description, List<int> memberIds);
  Future<Either<Failure, Project>> updateProject(int id, String? name, String? description, bool? isArchived);
  Future<Either<Failure, void>> deleteProject(int id);
  Future<Either<Failure, List<Member>>> getAvailableMembers();
  Future<Either<Failure, ProjectResponse>> getMyProjects(int page);
  Future<Either<Failure, Project>> updateProjectMembers(UpdateProjectMembersParams params);
}