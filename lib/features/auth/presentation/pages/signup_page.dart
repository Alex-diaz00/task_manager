import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/util/constants.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';
import 'package:task_manager/features/auth/presentation/widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  final AuthController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.png",
              height: size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding / 2),
                  const Text(
                    "Please enter your valid data in order to create an account.",
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  SignupForm(formKey: _formKey, controller: controller),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: controller.agreeTerms.value,
                            onChanged: (value) {
                              controller.agreeTerms.value = value!;
                            },
                          )),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree with the ",
                            children: [
                              TextSpan(
                                text: "Terms of service ",
                                style: const TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Get.toNamed(termsOfServicesScreenRoute);
                                  },
                              ),
                              const TextSpan(text: "& "),
                              TextSpan(
                                text: "privacy policy",
                                style: const TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Get.toNamed(privacyPolicyScreenRoute);
                                  },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: AppConstants.defaultPadding * 2),
                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() && 
                                controller.agreeTerms.value) {
                              controller.signUp();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text("CREATE ACCOUNT"),
                        )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () => Get.toNamed('/login'),
                        child: const Text("Log in"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}