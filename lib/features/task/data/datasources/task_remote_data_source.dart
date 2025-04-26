import 'package:task_manager/core/util/pagination.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';

abstract class TaskRemoteDataSource {
  Future<TaskModel> createTask(CreateTaskParams params);
  Future<TaskModel> updateTask(UpdateTaskParams params);
  Future<void> deleteTask(int taskId);
  Future<TaskModel> getTask(int taskId);
  Future<PaginatedResponse<TaskModel>> getProjectTasks(int projectId, int page);
  Future<PaginatedResponse<TaskModel>> getTasksByUser(int userId, int page);
}
