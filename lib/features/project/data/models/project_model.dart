
import 'package:task_manager/features/project/data/models/member_model.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    super.description,
    required super.isArchived,
    required super.owner,
    required super.members,
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
    );
  }
}