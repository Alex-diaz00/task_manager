
import 'package:get/get.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/domain/usecases/create_project.dart';
import 'package:task_manager/features/project/domain/usecases/delete_project.dart';
import 'package:task_manager/features/project/domain/usecases/get_projects.dart';
import 'package:task_manager/features/project/domain/usecases/update_project.dart';

class ProjectController extends GetxController {
  final GetProjectsUseCase getProjectsUseCase;
  final CreateProjectUseCase createProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;

  final projects = <Project>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxString('');

  ProjectController({
    required this.getProjectsUseCase,
    required this.createProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
  });

  Future<void> loadProjects() async {
    isLoading.value = true;
    final result = await getProjectsUseCase(NoParams());
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (response) => projects.assignAll(response.items),
    );
    isLoading.value = false;
  }

  Future<void> createProject(String name, String? description) async {
    isLoading.value = true;
    final result = await createProjectUseCase(CreateProjectParams(
      name: name,
      description: description,
    ));
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (project) => projects.insert(0, project),
    );
    isLoading.value = false;
  }

  Future<void> updateProject(Project project) async {
    isLoading.value = true;
    final result = await updateProjectUseCase(UpdateProjectParams(
      id: project.id,
      name: project.name,
      description: project.description,
      isArchived: project.isArchived,
    ));
    
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (updatedProject) {
        final index = projects.indexWhere((p) => p.id == updatedProject.id);
        if (index != -1) {
          projects[index] = updatedProject;
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> deleteProject(int projectId) async {
    isLoading.value = true;
    final result = await deleteProjectUseCase(projectId);
    
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (_) => projects.removeWhere((p) => p.id == projectId),
    );
    isLoading.value = false;
  }

}