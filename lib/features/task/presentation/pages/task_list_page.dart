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
  final TaskController taskController = Get.find();
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, size: 28),
                onPressed:
                    () => Get.dialog(
                      TaskForm(
                        projectMembers: project.members,
                        projectId: project.id,
                        onSubmit: (params) async {
                          await taskController.createTask(params);
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
                (member) => member.id == authController.currentUser.value?.id);
              
              return TaskCard(
                task: task,
                onEdit: isAssigned ? () => _showEditDialog(context, task) : null,
                onDelete: isAssigned ? () => taskController.deleteTask(task.id) : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context, Task task) {
    Get.dialog(
      TaskForm(
        projectMembers: project.members,
        projectId: project.id,
        onSubmit: (params) async => await taskController.updateTaskUseCase(params),
        task: task,
      ),
    );
  }
}