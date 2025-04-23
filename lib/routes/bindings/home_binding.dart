import 'package:get/get.dart';
import 'package:task_manager/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';
import 'package:task_manager/features/project/domain/usecases/get_members.dart';
import 'package:task_manager/features/project/domain/usecases/get_my_projects.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/routes/bindings/project_binding.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {

    ProjectBinding().dependencies();
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find()));
    Get.lazyPut(() => AuthController(
      signInUseCase: Get.find(),
      signUpUseCase: Get.find(),
      getCurrentUserUseCase: Get.find(),
      secureStorage: Get.find(),
    ));

    Get.lazyPut(() => GetAvailableMembersUseCase(Get.find<ProjectRepository>()));
    Get.lazyPut(() => GetMyProjectsUseCase(Get.find<ProjectRepository>()));
    Get.lazyPut(() => ProjectController(
      getProjectsUseCase: Get.find(),
      createProjectUseCase: Get.find(),
      updateProjectUseCase: Get.find(),
      deleteProjectUseCase: Get.find(),
      getAvailableMembersUseCase: Get.find(),
      getMyProjectsUseCase: Get.find(),
    ));
  }
}