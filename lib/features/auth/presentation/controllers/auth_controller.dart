import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/error/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/auth/domain/entities/user_entity.dart';
import 'package:task_manager/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:task_manager/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/features/auth/domain/usecases/sign_up_usecase.dart';

class AuthController extends GetxController {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final FlutterSecureStorage secureStorage;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isSignUp = false.obs;
  final agreeTerms = false.obs;
  final selectedTab = 0.obs;
  final currentUser = Rxn<UserEntity>();

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }
  Future<void> fetchCurrentUser() async {
  isLoading.value = true;
  final result = await getCurrentUserUseCase(NoParams());
  result.fold(
    (failure) {
      if (failure is ServerFailure && failure.message.contains('Unauthorized')) {
        // Token inválido o expirado
        secureStorage.delete(key: 'access_token');
        Get.offAllNamed('/login');
      }
      Get.snackbar('Error', failure.message);
    },
    (user) => currentUser.value = user,
  );
  isLoading.value = false;
}

  void _handleAuthSuccess(UserEntity user) async {
  await secureStorage.write(key: 'access_token', value: user.token);
  // Guardamos también el usuario completo
  await secureStorage.write(
    key: 'current_user',
    value: jsonEncode(user.toJson()),
  );
  currentUser.value = user;
  Get.offAllNamed('/home');
  Get.snackbar(
    'Welcome!',
    'You have successfully logged in',
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}
  
  AuthController({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.secureStorage,
    required this.getCurrentUserUseCase,
  });

   Future<void> signIn() async {
    isLoading.value = true;
    final result = await signInUseCase(SignInParams(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ));
    
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (user) => _handleAuthSuccess(user),
    );
    isLoading.value = false;
  }

  Future<void> signUp() async {
    isLoading.value = true;
    final result = await signUpUseCase(SignUpParams(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim(),
    ));

    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (user) => _handleAuthSuccess(user),
    );
    isLoading.value = false;
  }

  void toggleAuthMode() {
    isSignUp.value = !isSignUp.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void clearFields() {
  emailController.clear();
  passwordController.clear();
  nameController.clear();
}

}