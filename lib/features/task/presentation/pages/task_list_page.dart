import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/task/presentation/controllers/task_controller.dart';
import 'package:task_manager/features/task/presentation/widgets/task_card.dart';
import 'package:task_manager/features/task/presentation/widgets/task_form.dart';

import '../../domain/entities/task.dart';

class TaskListPage extends StatelessWidget {
  final Project project;

  final TaskController taskController = Get.put(TaskController(
    createTaskUseCase: Get.find(),
      updateTaskUseCase: Get.find(),
      deleteTaskUseCase: Get.find(),
      getTaskUseCase: Get.find(),
      getProjectTasksUseCase: Get.find(),
      getTasksByUserUseCase: Get.find(),
  ));
  final AuthController authController = Get.find();
  final isLoading = false.obs;

  TaskListPage({super.key, required this.project}) {
    taskController.currentPage.value = 1;
    taskController.loadProjectTasks(project.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project tasks'), centerTitle: true),
      floatingActionButton:
          project.isArchived
              ? null
              : FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed:
                    () => Get.dialog(
                      TaskForm(
                        projectMembers: project.members,
                        projectId: project.id,
                        onSubmit: (params) async {
                          Get.back();
                          Get.back();
                          await taskController.createTask(params);
                          Get.snackbar(
                            'Success',
                            'Task created successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        task: null,
                      ),
                    ),
              ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            taskController.currentPage.value = 1;
            await taskController.loadProjectTasks(project.id);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: taskController.tasks.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= taskController.tasks.length) {
                if (taskController.hasMore.value) {
                  taskController.loadMoreProjectTasks(project.id);
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox();
              }

              final task = taskController.tasks[index];
              final isAssigned = task.assignees.any(
                (member) =>
                    member.id.toString() ==
                    authController.currentUser.value?.id,
              );
              return TaskCard(
                task: task,
                onEdit:
                    isAssigned ? () => _showEditDialog(context, task) : null,
                onDelete:
                    isAssigned ? () => _confirmDelete(context, task.id) : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await taskController.deleteTask(taskId);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showEditDialog(BuildContext context, Task task) {
    Get.dialog(
      TaskForm(
        projectMembers: project.members,
        projectId: project.id,
        onSubmit: (params) async {
          Get.back();
          Get.back();
          await taskController.updateTask(params);
          Get.snackbar(
            'Success',
            'Task updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        task: task,
      ),
    );
  }
}
