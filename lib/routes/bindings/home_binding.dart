import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/routes/bindings/project_binding.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {

    ProjectBinding().dependencies();
    Get.lazyPut(() => AuthController(
      signInUseCase: Get.find(),
      signUpUseCase: Get.find(),
      getCurrentUserUseCase: Get.find(),
      secureStorage: Get.find(),
    ));

    Get.lazyPut(() => ProjectController(
      getProjectsUseCase: Get.find(),
      createProjectUseCase: Get.find(),
      updateProjectUseCase: Get.find(),
      deleteProjectUseCase: Get.find(),
    ));
  }
}