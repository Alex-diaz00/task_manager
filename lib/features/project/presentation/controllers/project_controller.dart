
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/domain/usecases/create_project.dart';
import 'package:task_manager/features/project/domain/usecases/delete_project.dart';
import 'package:task_manager/features/project/domain/usecases/get_members.dart';
import 'package:task_manager/features/project/domain/usecases/get_my_projects.dart';
import 'package:task_manager/features/project/domain/usecases/get_projects.dart';
import 'package:task_manager/features/project/domain/usecases/update_project.dart';

class ProjectController extends GetxController {
  final GetProjectsUseCase getProjectsUseCase;
  final CreateProjectUseCase createProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;
  final GetAvailableMembersUseCase getAvailableMembersUseCase;
  final GetMyProjectsUseCase getMyProjectsUseCase;

  final projects = <Project>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxString('');
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final showOnlyMyProjects = false.obs;
  final isFilterLoading = false.obs;
  
  final RxList<Member> availableMembers = <Member>[].obs;
  final RxList<int> selectedMemberIds = <int>[].obs;
  final RxBool isLoadingMembers = false.obs;
  final RxString membersErrorMessage = RxString('');

  ProjectController({
    required this.getProjectsUseCase,
    required this.createProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
    required this.getAvailableMembersUseCase,
    required this.getMyProjectsUseCase,
  });

  Future<void> toggleMyProjectsFilter() async {
    showOnlyMyProjects.toggle();
    currentPage.value = 1;
    await loadProjects();
  }

  Future<void> loadProjects({bool loadMore = false}) async {
    if (isLoading.value || (loadMore && isLoadingMore.value)) return;
    
    loadMore ? isLoadingMore.value = true : isLoading.value = true;
    if (!loadMore) isFilterLoading.value = true;
    
    final result = showOnlyMyProjects.value
        ? await getMyProjectsUseCase(currentPage.value)
        : await getProjectsUseCase(currentPage.value);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar('Error', failure.message);
      },
      (response) {
        if (loadMore) {
          projects.addAll(response.items);
        } else {
          projects.assignAll(response.items);
        }
        currentPage.value = response.meta.currentPage;
        hasMore.value = response.links.next != null;
      },
    );
    
    loadMore ? isLoadingMore.value = false : isLoading.value = false;
    isFilterLoading.value = false;
  }

  Future<void> loadMoreProjects() async {
    if (hasMore.value && !isLoadingMore.value) {
      currentPage.value++;
      await loadProjects(loadMore: true);
    }
  }


  Future<void> createProject(String name, String? description) async {
    isLoading.value = true;
    final result = await createProjectUseCase(CreateProjectParams(
      name: name,
      description: description,
      members: selectedMemberIds.toList(),
    ));
    
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (project) {
        projects.insert(0, project);
        selectedMemberIds.clear();
      },
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
    (failure) {
      errorMessage.value = failure.message;
      Get.snackbar(
        'Error',
        failure.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5));
      loadProjects();
    },
    (_) {
      projects.removeWhere((p) => p.id == projectId);
      Get.snackbar(
        'Success',
        'Project deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5));
      
    },
  );
    isLoading.value = false;
  }


  Future<void> loadAvailableMembers() async {
    isLoadingMembers.value = true;
    membersErrorMessage.value = '';
    
    final result = await getAvailableMembersUseCase(NoParams());
    
    result.fold(
      (failure) {
        membersErrorMessage.value = _mapFailureToMessage(failure);
        availableMembers.clear();
      },
      (members) {
        availableMembers.assignAll(members);
        selectedMemberIds.retainWhere(
          (id) => members.any((m) => m.id == id)
        );
      },
    );
    
    isLoadingMembers.value = false;
  }

  void toggleMemberSelection(int memberId) {
    if (selectedMemberIds.contains(memberId)) {
      selectedMemberIds.remove(memberId);
    } else {
      selectedMemberIds.add(memberId);
    }
  }

  void clearMemberSelection() {
    selectedMemberIds.clear();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }

  final RxString searchQuery = RxString('');
  List<Member> get filteredMembers {
    if (searchQuery.isEmpty) return availableMembers;
    return availableMembers.where((member) =>
      member.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      (member.email?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
    ).toList();
  }


}