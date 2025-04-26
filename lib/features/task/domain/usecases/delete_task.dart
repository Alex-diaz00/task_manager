import 'package:dartz/dartz.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class DeleteTaskUseCase implements UseCase<void, int> {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int taskId) {
    return repository.deleteTask(taskId);
  }
}
