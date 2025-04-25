import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/features/project/presentation/widgets/project_form.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;
  final ProjectController controller = Get.find();
  final AuthController authController = Get.find();

  ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
    final isOwner = 
        (project.owner.id.toString() == authController.currentUser.value?.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          if (isOwner) IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          if (isOwner) IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
            color: Colors.red,
          ),
        ],
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (project.isArchived)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('ARCHIVED', style: TextStyle(color: Colors.grey)),
                    ),
                  const SizedBox(height: 16),
                  if (project.description != null) ...[
                    Text(
                      project.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                      ],
                      Row(
                        children: [
                          const Text(
                            'Project Owner',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: SizedBox()),
                          IconButton(
                            icon: const Icon(Icons.task),
                            onPressed:
                                () => Get.toNamed(
                                  '/projects/${project.id}/tasks', arguments: project 
                                ),
                            tooltip: 'View tasks',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(project.owner.name),
                        subtitle: Text(project.owner.email),
                      ),
                      const SizedBox(height: 24),
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Team Members',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isOwner) TextButton(
                        onPressed: () => _showEditMembersDialog(context, project),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...project.members.map((member) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(member.name),
                    subtitle: Text(member.email),
                  )),
                ],
              ),
            ),
    );
    });
  }

  void _showEditMembersDialog(BuildContext context, Project project) {
  final controller = Get.find<ProjectController>();
  final isLoading = false.obs;
  
  controller.loadAvailableMembers();
  
  final selectedMembers = <int>{...project.members.map((m) => m.id)}.obs;

  showDialog(
    context: context,
    builder: (context) => Obx(() {
      return AlertDialog(
        title: const Text('Edit Project Members'),
        content: isLoading.value
            ? Column(
              mainAxisSize: MainAxisSize.min,
              children: 
            [
              const Center(child: CircularProgressIndicator()),
            ])
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Team Members:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: SingleChildScrollView(
                          child: Column(
                            children: controller.filteredMembers.map((member) {
                              return CheckboxListTile(
                                title: Text(member.name),
                                subtitle: Text(member.email),
                                value: selectedMembers.contains(member.id),
                                onChanged: isLoading.value
                                    ? null
                                    : (value) {
                                        if (value == true) {
                                          selectedMembers.add(member.id);
                                        } else {
                                          selectedMembers.remove(member.id);
                                        }
                                      },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: isLoading.value ? null : () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: 
                 () async {
                    isLoading.value = true;
                    final success = await controller.updateProjectMembers(
                      projectId: project.id,
                      memberIds: selectedMembers.toList(),
                    );         
                    if (success) {
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Members updated successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                      );
                    }
                    isLoading.value = false;
                  },
            child: const Text('Update'),
          )
        ],
      );
    }),
  );
}

  void _showEditDialog(BuildContext context) {
    final p = controller.projects.firstWhere((p) => p.id == project.id);

    showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Project'),
      content: ProjectForm(
        project: p,
        onSubmit: (updatedProject) async {
          Get.back(); 
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
          await controller.updateProject(updatedProject);
          Get.back();
        },
      ),
    ),
  );
}

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteProject(project.id);
              Get.back();
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}