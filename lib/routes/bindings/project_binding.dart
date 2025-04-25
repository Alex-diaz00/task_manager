
import 'package:get/get.dart';
import 'package:task_manager/features/project/data/datasources/project_remote_data_source.dart';
import 'package:task_manager/features/project/data/datasources/project_remote_data_source_impl.dart';
import 'package:task_manager/features/project/data/repositories/project_repository_impl.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';
import 'package:task_manager/features/project/domain/usecases/create_project.dart';
import 'package:task_manager/features/project/domain/usecases/delete_project.dart';
import 'package:task_manager/features/project/domain/usecases/get_members.dart';
import 'package:task_manager/features/project/domain/usecases/get_my_projects.dart';
import 'package:task_manager/features/project/domain/usecases/get_projects.dart';
import 'package:task_manager/features/project/domain/usecases/update_members.dart';
import 'package:task_manager/features/project/domain/usecases/update_project.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/routes/bindings/task_binding.dart';

class ProjectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectRemoteDataSource>(
      () => ProjectRemoteDataSourceImpl(dioClient: Get.find()),
    );

    Get.lazyPut<ProjectRepository>(
      () => ProjectRepositoryImpl(
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
    );


    Get.lazyPut(() => GetProjectsUseCase(Get.find()));
    Get.lazyPut(() => CreateProjectUseCase(Get.find()));
    Get.lazyPut(() => UpdateProjectUseCase(Get.find()));
    Get.lazyPut(() => DeleteProjectUseCase(Get.find()));
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

    TaskBinding().dependencies();
  }
}