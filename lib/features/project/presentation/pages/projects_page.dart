import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/features/project/presentation/pages/project_detail_page.dart';
import 'package:task_manager/features/project/presentation/widgets/project_card.dart';

class ProjectsPage extends StatelessWidget {
  final ProjectController controller = Get.find();

  ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProjectDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return ListView.builder(
          itemCount: controller.projects.length,
          itemBuilder: (context, index) {
            final project = controller.projects[index];
            return ProjectCard(
              project: project,
              onTap:
                  () => Get.to(() => ProjectDetailPage(projectId: project.id)),
            );
          },
        );
      }),
    );
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
            maxHeight: 200, // Altura máxima fija
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
}
