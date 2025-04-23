import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/features/project/presentation/pages/project_detail_page.dart';
import 'package:task_manager/features/project/presentation/pages/projects_page.dart';
import 'package:task_manager/features/project/presentation/widgets/project_card.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find();

  HomePage({super.key}) {
    Get.find<ProjectController>();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
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
                  const PopupMenuItem(value: 'logout', child: Text('Logout')),
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
          children: const [TasksSection(), ProjectsSection(), ProfileSection()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: authController.selectedTab.value,
          onTap: (index) => authController.selectedTab.value = index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
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
                onPressed: ()  {
                  Get.back();    
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
    return const Center(child: Text('Tasks Content'));
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectController>();
    final authController = Get.find<AuthController>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProjects();
    });

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        body: ListView.builder(
          itemCount: controller.projects.length,
          itemBuilder: (context, index) {
            final project = controller.projects[index];
            final isOwner = authController.currentUser.value != null && 
                (project.owner.id.toString() == authController.currentUser.value!.id);

            return ProjectCard(
              project: project,
              onTap: () => Get.to(() => ProjectDetailPage(projectId: project.id)),
              showActions: true,
              isOwner: isOwner,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateProjectDialog(context),
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}

void _showCreateProjectDialog(BuildContext context) {
    final controller = Get.find<ProjectController>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    controller.loadAvailableMembers();
    showDialog(
      context: context,
      builder:
          (context) => Obx(() {
            return AlertDialog(
              title: const Text('Create New Project'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Project Name',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMemberSelectionSection(controller),
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
          }),
    );
  }

  Widget _buildMemberSelectionSection(ProjectController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text('Team Members:', style: TextStyle(fontWeight: FontWeight.bold)),
      if (controller.isLoadingMembers.value)
        const Center(child: CircularProgressIndicator())
      else if (controller.membersErrorMessage.isNotEmpty)
        Text(controller.membersErrorMessage.value, 
             style: const TextStyle(color: Colors.red))
      else ...[
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search Members',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: controller.searchQuery,
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 200,
          ),
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
      children: controller.filteredMembers.map((member) {
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