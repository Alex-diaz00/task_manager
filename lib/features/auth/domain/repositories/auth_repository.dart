import 'package:dartz/dartz.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String name,
  );
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
