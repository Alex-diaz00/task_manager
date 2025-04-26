import 'package:dartz/dartz.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/project/domain/entities/member.dart';
import 'package:task_manager/features/project/domain/repositories/project_repository.dart';

class GetAvailableMembersUseCase implements UseCase<List<Member>, NoParams> {
  final ProjectRepository repository;

  GetAvailableMembersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Member>>> call(NoParams params) {
    return repository.getAvailableMembers();
  }
}
