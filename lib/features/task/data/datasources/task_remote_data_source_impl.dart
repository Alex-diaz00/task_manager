

import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/core/util/pagination.dart';
import 'package:task_manager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';
import 'package:task_manager/features/task/data/models/task_response_model.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final DioClient dioClient;

  TaskRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<TaskModel> createTask(CreateTaskParams params) async {
    final response = await dioClient.dio.post(
      '/task',
      data: {
        'name': params.name,
        'status': params.status.name,
        'priority': params.priority.name,
        'assigneeIds': params.assigneeIds,
        'projectId': params.projectId,
      },
    );
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<TaskModel> updateTask(UpdateTaskParams params) async {
    final response = await dioClient.dio.put(
      '/task/${params.taskId}',
      data: {
        'name': params.name,
        'status': params.status.name,
        'priority': params.priority?.name,
        'assigneeIds': params.assigneeIds,
      },
    );
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await dioClient.dio.delete('/task/$taskId');
  }

  @override
  Future<TaskModel> getTask(int taskId) async {
    final response = await dioClient.dio.get('/task/$taskId');
    return TaskModel.fromJson(response.data);
  }

  @override
  Future<PaginatedResponse<TaskModel>> getProjectTasks(int projectId, int page) async {
    final response = await dioClient.dio.get(
      '/project/$projectId/tasks',
      queryParameters: {'page': page},
    );
    return TaskResponseModel.fromJson(response.data);
  }

}