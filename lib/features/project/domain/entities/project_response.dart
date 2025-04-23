import 'package:equatable/equatable.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';

class ProjectResponse extends Equatable {
  final List<Project> items;

  final PaginationMeta meta;
  final PaginationLinks links;

  const ProjectResponse({
    required this.items,
    required this.meta,
    required this.links,
  });

  @override
  List<Object> get props => [items, meta, links];
}

class PaginationMeta {
  final int itemCount;
  final int totalItems;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;

  PaginationMeta({
    required this.itemCount,
    required this.totalItems,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });
}

class PaginationLinks {
  final String first;
  final String? next;
  final String last;

  PaginationLinks({
    required this.first,
    this.next,
    required this.last,
  });
}