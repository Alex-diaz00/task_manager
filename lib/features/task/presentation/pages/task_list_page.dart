import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/task/presentation/controllers/task_controller.dart';
import 'package:task_manager/features/task/presentation/widgets/task_card.dart';
import 'package:task_manager/features/task/presentation/widgets/task_form.dart';

import '../../domain/entities/task.dart';

class TaskListPage extends StatelessWidget {
  final int projectId;
  final TaskController taskController = Get.find();
  final AuthController authController = Get.find();

  TaskListPage({super.key, required this.projectId}) {
    taskController.currentPage.value = 1;
    taskController.loadProjectTasks(projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project tasks',),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add, size: 28),
        onPressed: () => Get.dialog(
          TaskForm(
            projectId: projectId,
            onSubmit: (params) async => await taskController.createTaskUseCase.call(params),
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
            await taskController.loadProjectTasks(projectId);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: taskController.tasks.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= taskController.tasks.length) {
                if (taskController.hasMore.value) {
                  taskController.loadMoreProjectTasks(projectId);
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
        projectId: projectId,
        onSubmit: (params) async => await taskController.updateTaskUseCase(params),
        task: task,
      ),
    );
  }
}