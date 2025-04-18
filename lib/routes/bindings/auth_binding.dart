import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:task_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dioClient: Get.find()));
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
      remoteDataSource: Get.find(),
      networkInfo: Get.find(),
      secureStorage: Get.find(),
));
    Get.lazyPut(() => SignInUseCase(Get.find()));
    Get.lazyPut(() => SignUpUseCase(Get.find()));
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find()));
    Get.lazyPut(() => AuthController(
      signInUseCase: Get.find(),
      signUpUseCase: Get.find(),
      getCurrentUserUseCase: Get.find(),
      secureStorage: Get.find(),
    ));
  }
}