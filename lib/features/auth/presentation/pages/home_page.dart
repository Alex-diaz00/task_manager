import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/features/project/presentation/pages/project_detail_page.dart';
import 'package:task_manager/features/project/presentation/widgets/project_card.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/presentation/controllers/task_controller.dart';
import 'package:task_manager/features/task/presentation/widgets/task_card.dart';
import 'package:task_manager/features/task/presentation/widgets/task_form.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find();

  HomePage({super.key}) {
    Get.find<ProjectController>();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.currentUser.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              'Welcome ${authController.currentUser.value?.name ?? ''}!',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.account_circle),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: 'logout', child: Text('Logout')),
                  ],
              onSelected: (value) {
                if (value == 'logout') {
                  _confirmLogout(context);
                }
              },
            ),
          ],
        ),
        body: Obx(
          () => IndexedStack(
            index: authController.selectedTab.value,
            children: const [TasksSection(), ProjectsSection()],
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: authController.selectedTab.value,
            onTap: (index) => authController.selectedTab.value = index,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'Projects',
              ),
            ],
          ),
        ),
      );
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  authController.logout();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

class TasksSection extends StatelessWidget {
  const TasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.put(
      TaskController(
        createTaskUseCase: Get.find(),
        updateTaskUseCase: Get.find(),
        deleteTaskUseCase: Get.find(),
        getTaskUseCase: Get.find(),
        getProjectTasksUseCase: Get.find(),
        getTasksByUserUseCase: Get.find(),
      ),
    );
    final authController = Get.find<AuthController>();

    void loadTasks() {
      if (authController.currentUser.value != null) {
        taskController.currentPage.value = 1;
        taskController.tasks.clear();
        taskController.loadTasksByUser(
          int.parse(authController.currentUser.value!.id),
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTasks();
    });

    return Obx(() {
      if (taskController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (taskController.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            taskController.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (taskController.tasks.isEmpty) {
        return const Center(child: Text('You have no tasks yet.'));
      }

      return RefreshIndicator(
        onRefresh: () async {
          taskController.currentPage.value = 1;
          if (authController.currentUser.value != null) {
            await taskController.loadTasksByUser(
              int.parse(authController.currentUser.value!.id),
            );
          }
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount:
              taskController.tasks.length +
              (taskController.hasMore.value ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= taskController.tasks.length) {
              if (taskController.hasMore.value) {
                taskController.loadMoreTasksByUser(
                  int.parse(authController.currentUser.value!.id),
                );
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox();
            }

            final task = taskController.tasks[index];
            final isAssigned = task.assignees.any(
              (member) =>
                  member.id.toString() == authController.currentUser.value?.id,
            );

            return TaskCard(
              task: task,
              onEdit:
                  isAssigned ? () => _showEditTaskDialog(context, task) : null,
              onDelete:
                  isAssigned
                      ? () => _confirmDeleteTask(context, task.id)
                      : null,
            );
          },
        ),
      );
    });
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final TaskController taskController = Get.find();
    Get.dialog(
      TaskForm(
        projectMembers: task.assignees,
        // projectId is not used during update, but the field is required.
        projectId: 0,
        onSubmit: (params) async {
          Get.back();
          Get.back();
          await taskController.updateTask(params);
          Get.snackbar(
            'Success',
            'Task updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
        task: task,
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, int taskId) {
    final TaskController taskController = Get.find();
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
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectController>();
    final authController = Get.find<AuthController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.projects.isEmpty) {
        controller.loadProjects();
      }
    });

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilterChip(
                    label: const Text('My Projects'),
                    selected: controller.showOnlyMyProjects.value,
                    onSelected: (_) => controller.toggleMyProjectsFilter(),
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  controller.loadMoreProjects();
                }
                return false;
              },
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Stack(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount:
                          controller.projects.length +
                          (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= controller.projects.length) {
                          return const SizedBox.shrink();
                        }
                        final project = controller.projects[index];
                        final isOwner =
                            authController.currentUser.value != null &&
                            (project.owner.id.toString() ==
                                authController.currentUser.value!.id);

                        return ProjectCard(
                          project: project,
                          onTap:
                              () => Get.to(
                                () => ProjectDetailPage(project: project),
                              ),
                          showActions: true,
                          isOwner: isOwner,
                        );
                      },
                    ),
                    if (controller.isLoadingMore.value)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Center(child: CircularProgressIndicator()),
                              SizedBox(height: 8),
                              Text(
                                "Loading more projects...",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProjectDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showCreateProjectDialog(BuildContext context) {
  final controller = Get.find<ProjectController>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  controller.loadAvailableMembers();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create New Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Project Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              Obx(() => _buildMemberSelectionSection(controller)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.createProject(
                nameController.text.trim(),
                descriptionController.text.trim(),
              );
              Get.back();
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
}

Widget _buildMemberSelectionSection(ProjectController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Team Members:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      if (controller.isLoadingMembers.value)
        const Center(child: CircularProgressIndicator())
      else if (controller.membersErrorMessage.isNotEmpty)
        Text(
          controller.membersErrorMessage.value,
          style: const TextStyle(color: Colors.red),
        )
      else ...[
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search Members',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: controller.searchQuery.call,
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: _buildMembersList(controller),
        ),
      ],
    ],
  );
}

Widget _buildMembersList(ProjectController controller) {
  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children:
          controller.filteredMembers.map((member) {
            return CheckboxListTile(
              title: Text(member.name),
              subtitle: Text(member.email),
              value: controller.selectedMemberIds.contains(member.id),
              onChanged: (_) => controller.toggleMemberSelection(member.id),
            );
          }).toList(),
    ),
  );
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Content'));
  }
}
