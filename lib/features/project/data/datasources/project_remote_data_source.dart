import 'package:task_manager/features/project/data/models/member_model.dart';
import 'package:task_manager/features/project/data/models/project_model.dart';
import 'package:task_manager/features/project/data/models/project_response_model.dart';
import 'package:task_manager/features/project/domain/usecases/update_members.dart';

abstract class ProjectRemoteDataSource {
  Future<ProjectResponseModel> getProjects(int page);
  Future<ProjectModel> createProject(
    String name,
    String? description,
    List<int> memberIds,
  );
  Future<ProjectModel> updateProject(
    int id,
    String? name,
    String? description,
    bool? isArchived,
  );
  Future<void> deleteProject(int id);
  Future<List<MemberModel>> getAvailableMembers();
  Future<ProjectResponseModel> getMyProjects(int page);
  Future<ProjectModel> updateProjectMembers(UpdateProjectMembersParams params);
}
