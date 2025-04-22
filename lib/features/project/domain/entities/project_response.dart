import 'package:equatable/equatable.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';

class ProjectResponse extends Equatable {
  final List<Project> items;
  final int totalItems;

  const ProjectResponse({
    required this.items,
    required this.totalItems,
  });

  @override
  List<Object> get props => [items, totalItems];
}