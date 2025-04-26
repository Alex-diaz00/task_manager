import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/auth/domain/entities/user_entity.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return repository.signUp(params.email, params.password, params.name);
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}
