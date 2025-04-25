import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/domain/usecases/create_task.dart';
import 'package:task_manager/features/task/domain/usecases/update_task.dart';

class TaskForm extends StatefulWidget {
  final int projectId;
  final Task? task;
  final Function(dynamic) onSubmit;

  const TaskForm({
    super.key,
    required this.projectId,
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _status = widget.task?.status ?? TaskStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Nueva Tarea' : 'Editar Tarea'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la tarea',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: TaskStatus.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                border: OutlineInputBorder(),
              ),
              items: TaskPriority.values
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _priority = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            final params = widget.task == null
                ? CreateTaskParams(
                    projectId: widget.projectId,
                    name: _nameController.text,
                    status: _status,
                    priority: _priority,
                    assigneeIds: [],
                  )
                : UpdateTaskParams(
                    taskId: widget.task!.id,
                    name: _nameController.text,
                    status: _status,
                    priority: _priority,
                    assigneeIds: widget.task!.assignees.map((e) => e.id).toList(),
                  );
            
            widget.onSubmit(params);
            Get.back();
          },
          child: Text(widget.task == null ? 'Crear' : 'Guardar',
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}