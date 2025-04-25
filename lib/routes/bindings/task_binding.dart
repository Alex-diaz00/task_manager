import 'package:get/get.dart';
import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/core/network/network_info.dart';
import 'package:task_manager/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:task_manager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/task/data/datasources/task_remote_data_source_impl.dart';
import 'package:task_manager/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:task_manager/features/task/domain/usecases/get_project_tasks.dart';
import 'package:task_manager/features/task/domain/usecases/get_task.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';
import 'package:task_manager/features/task/presentation/controllers/task_controller.dart';

class TaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DioClient(dio: Get.find(), storage: Get.find()));
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
    Get.lazyPut<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<TaskRepository>(
      () => TaskRepositoryImpl(
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
    );
    
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find()));

    Get.lazyPut(() => CreateTaskUseCase(Get.find()));
    Get.lazyPut(() => UpdateTaskUseCase(Get.find()));
    Get.lazyPut(() => DeleteTaskUseCase(Get.find()));
    Get.lazyPut(() => GetTaskUseCase(Get.find()));
    Get.lazyPut(() => GetProjectTasksUseCase(Get.find()));
    
    Get.lazyPut(() => TaskController(
      createTaskUseCase: Get.find(),
      updateTaskUseCase: Get.find(),
      deleteTaskUseCase: Get.find(),
      getTaskUseCase: Get.find(),
      getProjectTasksUseCase: Get.find(),
    ));
  }
}