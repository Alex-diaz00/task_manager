
import 'package:task_manager/features/project/data/models/member_model.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    super.description,
    required super.isArchived,
    required super.owner,
    required super.members,
    required super.tasks,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isArchived: json['isArchived'],
      owner: MemberModel.fromJson(json['owner']),
      members: (json['members'] as List)
          .map((e) => MemberModel.fromJson(e))
          .toList(),
      tasks: (json['tasks'] as List?)
              ?.map((e) => TaskModel.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
    );
  }
}