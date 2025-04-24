import 'package:equatable/equatable.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';

enum TaskStatus { pending, inProgress, completed }
enum TaskPriority { low, medium, high }

class Task extends Equatable {
  final int id;
  final String name;
  final TaskStatus status;
  final TaskPriority priority;
  final List<Member> assignees;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.name,
    required this.status,
    required this.priority,
    required this.assignees,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, name, status, priority, assignees, createdAt, updatedAt];
}