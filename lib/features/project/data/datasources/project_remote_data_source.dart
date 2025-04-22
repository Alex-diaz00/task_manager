
import 'package:task_manager/features/project/data/models/project_model.dart';
import 'package:task_manager/features/project/data/models/project_response_model.dart';

abstract class ProjectRemoteDataSource {
  Future<ProjectResponseModel> getProjects();
  Future<ProjectModel> createProject(String name, String? description);
  Future<ProjectModel> updateProject(int id, String? name, String? description, bool? isArchived);
  Future<ProjectModel> deleteProject(int id);
}