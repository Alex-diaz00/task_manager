import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          'Welcome, ${authController.currentUser.value?.name ?? 'User'}!',
          style: const TextStyle(fontSize: 20),
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Get.toNamed('/profile'),
          )
        ],
      ),
      body: Obx(() => IndexedStack(
        index: authController.selectedTab.value,
        children: const [
          TasksSection(),
          ProjectsSection(),
          ProfileSection(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: authController.selectedTab.value,
        onTap: (index) => authController.selectedTab.value = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}

// Secciones placeholder
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
    return const Center(child: Text('Projects Content'));
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Content'));
  }
}