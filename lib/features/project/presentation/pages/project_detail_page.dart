import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/project/presentation/controllers/project_controller.dart';
import 'package:task_manager/features/project/presentation/widgets/project_form.dart';

class ProjectDetailPage extends StatelessWidget {
  final int projectId;
  final ProjectController controller = Get.find();

  ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final project = controller.projects.firstWhereOrNull((p) => p.id == projectId);

    return Scaffold(
      appBar: AppBar(
        title: Text(project?.name ?? 'Project Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
            color: Colors.red,
          ),
        ],
      ),
      body: project == null
          ? const Center(child: Text('Project not found'))
          : SingleChildScrollView(
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
                  const Text(
                    'Project Owner',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(project.owner.name),
                    subtitle: Text(project.owner.email),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Team Members',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...project.members.map((member) => ListTile(
                    leading:  CircleAvatar(child: Icon(Icons.person)),
                    title: Text(member.name),
                    subtitle: Text(member.email),
                  )).toList(),
                ],
              ),
            ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final project = controller.projects.firstWhere((p) => p.id == projectId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Project'),
        content: ProjectForm(
          project: project,
          onSubmit: (updatedProject) {
            controller.updateProject(updatedProject);
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
              controller.deleteProject(projectId);
              Get.back();
              Get.back(); // Cerrar también la página de detalle
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}