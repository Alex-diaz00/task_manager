import 'package:equatable/equatable.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final String? description;
  final bool isArchived;
  final Member owner;
  final List<Member> members;
  final List<Task>? tasks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.isArchived,
    required this.owner,
    required this.members,
    this.tasks,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    isArchived,
    owner,
    members,
    tasks,
    createdAt,
    updatedAt,
  ];
}
