import 'package:flutter/material.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';

class ProjectForm extends StatefulWidget {
  final Project? project;
  final Function(Project) onSubmit;

  const ProjectForm({
    super.key,
    this.project,
    required this.onSubmit,
  });

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late bool _isArchived;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descController = TextEditingController(text: widget.project?.description ?? '');
    _isArchived = widget.project?.isArchived ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Project Name'),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(labelText: 'Description (Optional)'),
            maxLines: 3,
          ),
          if (widget.project != null) ...[
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Archived'),
              value: _isArchived,
              onChanged: (value) => setState(() => _isArchived = value ?? false),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(widget.project == null ? 'Create Project' : 'Update Project'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final project = Project(
        id: widget.project?.id ?? 0,
        name: _nameController.text.trim(),
        description: _descController.text.trim().isEmpty 
          ? null 
          : _descController.text.trim(),
        isArchived: _isArchived,
        owner: widget.project?.owner ?? const Member(id: 0, name: '', email: ''),
        members: widget.project?.members ?? const [],
      );
      widget.onSubmit(project);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}