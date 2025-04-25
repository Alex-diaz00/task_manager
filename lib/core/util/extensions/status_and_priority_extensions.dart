import 'package:task_manager/features/task/domain/entities/task.dart';

extension TaskStatusExtension on TaskStatus {
  String get label {
    final words = name.split('_');
    return words.map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}

extension TaskPriorityExtension on TaskPriority {
  String get label {
    return name[0].toUpperCase() + name.substring(1);
  }
}
