import 'package:get/get.dart';
import 'package:task_manager/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';
import 'package:task_manager/features/project/domain/usecases/get_members.dart';
import 'package:task_manager/features/project/domain/usecases/get_my_projects.dart';
import 'package:task_manager/features/project/domain/usecases/update_members.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:task_manager/features/task/domain/usecases/get_project_tasks.dart';
import 'package:task_manager/features/task/domain/usecases/get_task.dart';
import 'package:task_manager/features/task/domain/usecases/get_tasks_by_user.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';
import 'package:task_manager/features/task/presentation/controllers/task_controller.dart';
import 'package:task_manager/routes/bindings/project_binding.dart';
import 'package:task_manager/routes/bindings/task_binding.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {

    ProjectBinding().dependencies();
    TaskBinding().dependencies();
    
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find()));
    Get.lazyPut(() => AuthController(
      signInUseCase: Get.find(),
      signUpUseCase: Get.find(),
      getCurrentUserUseCase: Get.find(),
      secureStorage: Get.find(),
    ));

    Get.lazyPut(() => GetAvailableMembersUseCase(Get.find<ProjectRepository>()));
    Get.lazyPut(() => GetMyProjectsUseCase(Get.find<ProjectRepository>()));
    Get.lazyPut(() => UpdateProjectMembersUseCase(Get.find<ProjectRepository>()));
    Get.lazyPut(() => ProjectController(
      getProjectsUseCase: Get.find(),
      createProjectUseCase: Get.find(),
      updateProjectUseCase: Get.find(),
      deleteProjectUseCase: Get.find(),
      getAvailableMembersUseCase: Get.find(),
      getMyProjectsUseCase: Get.find(),
      updateProjectMembersUseCase: Get.find(),
    ));

    Get.lazyPut(() => CreateTaskUseCase(Get.find<TaskRepository>()));
    Get.lazyPut(() => UpdateTaskUseCase(Get.find<TaskRepository>()));
    Get.lazyPut(() => DeleteTaskUseCase(Get.find<TaskRepository>()));
    Get.lazyPut(() => GetTaskUseCase(Get.find<TaskRepository>()));
    Get.lazyPut(() => GetProjectTasksUseCase(Get.find<TaskRepository>()));
    Get.lazyPut(() => GetTasksByUserUseCase(Get.find<TaskRepository>()));
    
    Get.lazyPut(() => TaskController(
      createTaskUseCase: Get.find(),
      updateTaskUseCase: Get.find(),
      deleteTaskUseCase: Get.find(),
      getTaskUseCase: Get.find(),
      getProjectTasksUseCase: Get.find(),
      getTasksByUserUseCase: Get.find(),
    ));
  }
}