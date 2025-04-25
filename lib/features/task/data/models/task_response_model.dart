import 'package:task_manager/core/util/pagination.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';

class TaskResponseModel extends PaginatedResponse<TaskModel> {
  const TaskResponseModel({
    required super.items,
    required super.meta,
    required super.links,
  });

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskResponseModel(
      items: (json['items'] as List)
          .map((e) => TaskModel.fromJson(e))
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
        last: json['links']['last'] ?? json['links']['first'],
      ),
    );
  }
}