import 'package:flutter/material.dart';
import 'package:task_manager/core/util/extensions/status_and_priority_extensions.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/core/widgets/info_chip.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({super.key, required this.task, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildStatusAndPriorityAndAssigneesButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            task.name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w200),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: Colors.green,
            onPressed: onEdit,
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            onPressed: onDelete,
          ),
      ],
    );
  }

  Widget _buildStatusAndPriorityAndAssigneesButton(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        InfoChip(
          label: task.status.label.toUpperCase(),
          color: _getStatusColor(task.status),
        ),
        InfoChip(
          label: task.priority.label.toUpperCase(),
          color: _getPriorityColor(task.priority),
        ),
        _buildAssigneesButton(context),
      ],
    );
  }

  Widget _buildAssigneesButton(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: const Icon(Icons.group, size: 20),
      label: Text('Assigned to ${task.assignees.length}'),
      onPressed: () => _showAssigneesDialog(context),
    );
  }

  void _showAssigneesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Assigned Members',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  task.assignees.isEmpty
                      ? const Text('No members assigned')
                      : Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children:
                              task.assignees
                                  .map(
                                    (member) => ListTile(
                                      leading: const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      title: Text(member.name),
                                      subtitle: Text(member.email),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.in_progress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}
