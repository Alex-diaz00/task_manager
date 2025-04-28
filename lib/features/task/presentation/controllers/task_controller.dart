import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:task_manager/features/task/domain/usecases/get_project_tasks.dart';
import 'package:task_manager/features/task/domain/usecases/get_task.dart';
import 'package:task_manager/features/task/domain/usecases/get_tasks_by_user.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';

class TaskController extends GetxController {
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetTaskUseCase getTaskUseCase;
  final GetProjectTasksUseCase getProjectTasksUseCase;
  final GetTasksByUserUseCase getTasksByUserUseCase;

  final tasks = <Task>[].obs;
  final selectedTask = Rxn<Task>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxString('');
  final currentPage = 0.obs;
  final hasMore = true.obs;

  TaskController({
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getTaskUseCase,
    required this.getProjectTasksUseCase,
    required this.getTasksByUserUseCase,
  });

  Future<void> loadProjectTasks(int projectId, {bool loadMore = false}) async {
    if (isLoading.value || (loadMore && isLoadingMore.value)) return;

    loadMore ? isLoadingMore.value = true : isLoading.value = true;
    final result = await getProjectTasksUseCase(
      GetProjectTasksParams(projectId: projectId, page: currentPage.value),
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar('Error', failure.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),);
      },
      (response) {
        if (loadMore) {
          tasks.addAll(response.items);
        } else {
          tasks.assignAll(response.items);
        }
        currentPage.value = response.meta.currentPage;
        hasMore.value = response.links.next != null;
      },
    );

    loadMore ? isLoadingMore.value = false : isLoading.value = false;
  }


  Future<void> loadTasksByUser(int userId, {bool loadMore = false}) async {
    if (isLoading.value || (loadMore && isLoadingMore.value)) return;

    loadMore ? isLoadingMore.value = true : isLoading.value = true;
    final result = await getTasksByUserUseCase(
      GetTasksByUserParams(userId: userId, page: currentPage.value),
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar('Error', failure.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),);
      },
      (response) {
        if (loadMore) {
          tasks.addAll(response.items);
        } else {
          tasks.assignAll(response.items);
        }
        currentPage.value = response.meta.currentPage;
        hasMore.value = response.links.next != null;
      },
    );

    loadMore ? isLoadingMore.value = false : isLoading.value = false;
  }

  Future<void> createTask(CreateTaskParams task) async {
    isLoading.value = true;

    try {
      final result = await createTaskUseCase(task);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.back();
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          );
        },
        (createdTask) {
          tasks.insert(0, createdTask);
          Get.snackbar(
            'Success',
            'Task created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          );
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = 'Unexpected error occurred';
      Get.snackbar(
        'Error',
        'Unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreTasksByUser(int userId) async {
    if (hasMore.value && !isLoadingMore.value) {
      currentPage.value++;
      await loadTasksByUser(userId, loadMore: true);
    }
  }

  Future<void> loadMoreProjectTasks(int projectId) async {
    if (hasMore.value && !isLoadingMore.value) {
      currentPage.value++;
      await loadProjectTasks(projectId, loadMore: true);
    }
  }

  Future<void> updateTaskStatus(int taskId, TaskStatus newStatus) async {
    isLoading.value = true;

    final taskResult = await getTaskUseCase(taskId);

    await taskResult.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar('Error', failure.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),);
      },
      (task) async {
        final updateResult = await updateTaskUseCase(
          UpdateTaskParams(
            taskId: taskId,
            name: task.name,
            priority: task.priority,
            assigneeIds: task.assignees.map((a) => a.id).toList(),
            status: newStatus,
          ),
        );
        updateResult.fold((failure) => errorMessage.value = failure.message, (
          updatedTask,
        ) {
          final index = tasks.indexWhere((t) => t.id == updatedTask.id);
          if (index != -1) {
            tasks[index] = updatedTask;
          }
        });
      },
    );

    isLoading.value = false;
  }

  Future<void> deleteTask(int taskId) async {
    isLoading.value = true;
    final result = await deleteTaskUseCase(taskId);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        );
      },
      (_) {
        tasks.removeWhere((t) => t.id == taskId);
        Get.snackbar(
          'Success',
          'Task deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );
      },
    );

    isLoading.value = false;
  }

  Future<void> updateTask(UpdateTaskParams params) async {
    isLoading.value = true;

    try {
      final result = await updateTaskUseCase(params);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.back();
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          );
        },
        (updatedTask) {
          final index = tasks.indexWhere((t) => t.id == updatedTask.id);
          if (index != -1) {
            tasks[index] = updatedTask;
            Get.snackbar(
              'Successd',
              'Task updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Unexpected error occurred';
      Get.snackbar(
        'Error',
        'Unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
