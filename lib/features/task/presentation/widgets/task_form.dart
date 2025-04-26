import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/util/extensions/status_and_priority_extensions.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';

class TaskForm extends StatefulWidget {
  final int projectId;
  final List<Member> projectMembers;
  final Task? task;
  final Function(dynamic) onSubmit;

  const TaskForm({
    super.key,
    required this.projectId,
    required this.projectMembers,
    required this.onSubmit,
    this.task,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late final TextEditingController _nameController;
  late TaskPriority _priority;
  late TaskStatus _status;
  final _selectedMembers = <int>{}.obs;
  final _searchQuery = ''.obs;
  final _formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _priority = widget.task?.priority ?? TaskPriority.low;
    _status = widget.task?.status ?? TaskStatus.pending;

    if (widget.task != null) {
      _selectedMembers.addAll(widget.task!.assignees.map((e) => e.id));
    }
  }

  List<Member> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return widget.projectMembers;
    }
    return widget.projectMembers.where((member) {
      return member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showMembersSelectionDialog() {
    showDialog(
      context: Get.context!,
      builder:
          (context) => Obx(() {
            return AlertDialog(
              title: const Text('Assign Team Members'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select members:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search Members',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => _searchQuery.value = value,
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                              _filteredMembers.map((member) {
                                return CheckboxListTile(
                                  title: Text(member.name),
                                  subtitle: Text(member.email),
                                  value: _selectedMembers.contains(member.id),
                                  onChanged: (value) {
                                    if (value == true) {
                                      _selectedMembers.add(member.id);
                                    } else {
                                      _selectedMembers.remove(member.id);
                                    }
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Done'),
                ),
              ],
            );
          }),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMembers.isEmpty) {
      Get.snackbar(
        'Error',
        'You must assign at least one member',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_nameController.text.length < 2) {
      Get.snackbar(
        'Error',
        'Task name must be at least 2 characters',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    _isLoading.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      if (widget.task != null) {
        await widget.onSubmit(
          UpdateTaskParams(
            taskId: widget.task!.id,
            name: _nameController.text,
            status: _status,
            priority: _priority,
            assigneeIds: _selectedMembers.toList(),
          ),
        );
      } else {
        await widget.onSubmit(
          CreateTaskParams(
            projectId: widget.projectId,
            name: _nameController.text,
            status: _status,
            priority: _priority,
            assigneeIds: _selectedMembers.toList(),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create task',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      Get.back();
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items:
                    TaskStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items:
                    TaskPriority.values
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority.label.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Assignees'),
                subtitle: Obx(
                  () => Text('${_selectedMembers.length} selected'),
                ),
                trailing: const Icon(Icons.edit, size: 20, color: Colors.green,),
                onTap: _showMembersSelectionDialog,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading.value ? null : () => Get.back(),
          child: const Text('Cancel'),
        ),
        Obx(
          () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: _isLoading.value ? null : _submitForm,
            child: Text(
              widget.task == null ? 'Create' : 'Update',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
