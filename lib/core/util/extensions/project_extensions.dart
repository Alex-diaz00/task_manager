import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';

extension ProjectCopyWith on Project {
  Project copyWith({
    int? id,
    String? name,
    String? description,
    bool? isArchived,
    Member? owner,
    List<Member>? members,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      owner: owner ?? this.owner,
      members: members ?? this.members,
    );
  }
}