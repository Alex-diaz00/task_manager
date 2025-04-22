
import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/features/project/data/datasources/project_remote_data_source.dart';
import 'package:task_manager/features/project/data/models/project_model.dart';
import 'package:task_manager/features/project/data/models/project_response_model.dart';

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final DioClient dioClient;

  ProjectRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ProjectResponseModel> getProjects() async {
    final response = await dioClient.dio.get('/project');
    return ProjectResponseModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> createProject(String name, String? description) async {
    final response = await dioClient.dio.post('/project', data: {
      'name': name,
      'description': description,
    });
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> updateProject(int id, String? name, String? description, bool? isArchived) async {
    final response = await dioClient.dio.put('/project/$id', data: {
      'name': name,
      'description': description,
      'isArchived': isArchived,
    });
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> deleteProject(int id) async {
    final response = await dioClient.dio.delete('/project/$id');

    return ProjectModel.fromJson(response.data);
  }
}