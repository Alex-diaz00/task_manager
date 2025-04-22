import 'package:task_manager/features/project/data/models/project_model.dart';
import 'package:task_manager/features/project/domain/entities/project_response.dart';

class ProjectResponseModel extends ProjectResponse {
  const ProjectResponseModel({
    required super.items,
    required super.totalItems,
  });

  factory ProjectResponseModel.fromJson(Map<String, dynamic> json) {
    return ProjectResponseModel(
      items: (json['items'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList(),
      totalItems: json['meta']['totalItems'],
    );
  }
}