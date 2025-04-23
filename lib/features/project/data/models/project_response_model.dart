import 'package:task_manager/features/project/data/models/project_model.dart';
import 'package:task_manager/features/project/domain/entities/project_response.dart';

class ProjectResponseModel extends ProjectResponse {
  const ProjectResponseModel({
    required super.items,
    required super.meta,
    required super.links,
  });

  factory ProjectResponseModel.fromJson(Map<String, dynamic> json) {
    return ProjectResponseModel(
      items: (json['items'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList(),
      meta: PaginationMeta(
        itemCount: json['meta']['itemCount'],
        totalItems: json['meta']['totalItems'],
        itemsPerPage: json['meta']['itemsPerPage'],
        totalPages: json['meta']['totalPages'],
        currentPage: json['meta']['currentPage'],
      ),
      links: PaginationLinks(
        first: json['links']['first'],
        next: json['links']['next'],
        last: json['links']['last'],
      ),
    );
  }
}