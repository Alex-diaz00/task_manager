import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/features/project/presentation/pages/projects_page.dart';

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
    return GetBuilder<ProjectController>(
      init: ProjectController(
        getProjectsUseCase: Get.find(),
        createProjectUseCase: Get.find(),
        updateProjectUseCase: Get.find(),
        deleteProjectUseCase: Get.find(),
        getAvailableMembersUseCase: Get.find(),
      ),
      builder: (controller) {
        return Scaffold(
          body: ProjectsPage(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.to(() => ProjectsPage()),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Content'));
  }
}