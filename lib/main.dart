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
import 'package:task_manager/features/auth/domain/usecases/sign_in_usecase.dart';
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

  // Basic dependencies
  Get.lazyPut(() => Dio());
  Get.lazyPut(() => GetStorage());
  Get.lazyPut(() => const FlutterSecureStorage());
  Get.lazyPut(() => InternetConnectionChecker.createInstance());
  
  // Network dependencies
  Get.lazyPut(() => DioClient(dio: Get.find(), storage: Get.find()));
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
  
  // Auth dependencies
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
  
  // UseCases
  Get.lazyPut(() => SignInUseCase(Get.find()));
  Get.lazyPut(() => SignUpUseCase(Get.find()));
  
  // Controllers
  Get.lazyPut(() => AuthController(
    signInUseCase: Get.find(),
    signUpUseCase: Get.find(),
    getCurrentUserUseCase: Get.find(),
    secureStorage: Get.find(),
  ));

  
  
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
