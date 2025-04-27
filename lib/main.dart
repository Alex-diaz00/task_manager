import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/core/network/network_info.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:task_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/sign_out.dart';
import 'package:task_manager/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'routes/app_pages.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  configureDependencies();
  runApp(MyApp());
}

void configureDependencies() {
  Get.lazyPut(() => Dio());
  Get.lazyPut(() => GetStorage());
  Get.lazyPut(() => const FlutterSecureStorage());
  Get.lazyPut(() => InternetConnectionChecker.createInstance());

  Get.lazyPut(() => DioClient(dio: Get.find(), storage: Get.find()));
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));

  Get.lazyPut<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: Get.find()),
  );

  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: Get.find(),
      networkInfo: Get.find(),
      secureStorage: Get.find(),
    ),
  );

  Get.lazyPut(() => SignInUseCase(Get.find()));
  Get.lazyPut(() => SignUpUseCase(Get.find()));
  Get.lazyPut(() => GetCurrentUserUseCase(Get.find()));
  Get.lazyPut(() => SignOutUseCase(Get.find()));

  Get.lazyPut(
    () => AuthController(
      signInUseCase: Get.find(),
      signUpUseCase: Get.find(),
      getCurrentUserUseCase: Get.find(),
      secureStorage: Get.find(),
      signOutUseCase: Get.find(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: AppPages.pages,
    );
  }
}
