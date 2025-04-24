import 'package:equatable/equatable.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final String? description;
  final bool isArchived;
  final Member owner;
  final List<Member> members;

  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.isArchived,
    required this.owner,
    required this.members,
  });

  @override
  List<Object?> get props => [id, name, description, isArchived, owner, members];
}