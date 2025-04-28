import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/util/extensions/project_extensions.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;
  final bool showActions;
  final bool isOwner;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.showActions = true,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // margin: const EdgeInsets.symmetricx(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w200),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (project.isArchived)
                          const Icon(
                            Icons.archive,
                            color: Colors.grey,
                            size: 20,
                          ),
                        SizedBox(width: 8),
                        if (showActions && isOwner)
                          _buildActionButtons(context),
                      ],
                    ),
                    if (project.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        project.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Owner: ${project.owner.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Members: ${project.members.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final controller = Get.find<ProjectController>();

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          color: Colors.green,
          onPressed:
              isOwner ? () => _showEditDialog(context, controller) : null,
          tooltip: isOwner ? 'Edit project' : 'Only project owner can edit',
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20),
          color: Colors.red,
          onPressed: isOwner ? () => _confirmDelete(context, controller) : null,
          tooltip: isOwner ? 'Delete project' : 'Only project owner can delete',
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, ProjectController controller) {
    final nameController = TextEditingController(text: project.name);
    final descController = TextEditingController(text: project.description);
    final isArchived = project.isArchived.obs;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Project Name'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              Obx(
                () => CheckboxListTile(
                  title: const Text('Archived'),
                  value: isArchived.value,
                  onChanged: (value) {
                    if (value != null) {
                      isArchived.value = value;
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.updateProject(
                  project.copyWith(
                    name: nameController.text.trim(),
                    description:
                        descController.text.trim().isEmpty
                            ? null
                            : descController.text.trim(),
                    isArchived: isArchived.value,
                  ),
                );
                Get.back();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ProjectController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Project'),
            content: const Text(
              'Are you sure you want to delete this project?',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteProject(project.id);
                  Get.back();
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
