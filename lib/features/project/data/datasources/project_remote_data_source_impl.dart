
import 'package:dio/dio.dart';
import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/features/project/data/datasources/project_remote_data_source.dart';
import 'package:task_manager/features/project/data/models/member_model.dart';
import 'package:task_manager/features/project/data/models/project_model.dart';
import 'package:task_manager/features/project/data/models/project_response_model.dart';
import 'package:task_manager/features/project/domain/usecases/update_members.dart';

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final DioClient dioClient;

  ProjectRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ProjectResponseModel> getProjects(int page) async {
    final response = await dioClient.dio.get('/project', queryParameters: {
    'page': page,
  });
    return ProjectResponseModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> createProject(String name, String? description, List<int> memberIds) async {
    final response = await dioClient.dio.post('/project', data: {
      'name': name,
      'description': description,
      'members': memberIds,
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
  Future<void> deleteProject(int id) async {
    final response = await dioClient.dio.delete('/project/$id');

    if (response.statusCode != 204) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }

  @override
  Future<List<MemberModel>> getAvailableMembers() async {
    try {
      final response = await dioClient.dio.get('/profile');
      
      return (response.data as List)
          .map((memberJson) => MemberModel.fromJson(memberJson))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Members endpoint not found');
      }
      rethrow;
    }
  }


  @override
  Future<ProjectResponseModel> getMyProjects(int page) async {
  final response = await dioClient.dio.get('/project/owner', queryParameters: {
    'page': page,
  });
  return ProjectResponseModel.fromJson(response.data);
}

  @override
  Future<ProjectModel> updateProjectMembers(UpdateProjectMembersParams params) async {
  final response = await dioClient.dio.patch(
    '/project/${params.projectId}/members',
    data: {
      'memberIds': params.memberIds,
    },
  );
  return ProjectModel.fromJson(response.data);
}


}