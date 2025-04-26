import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/core/util/constants.dart';
import 'package:task_manager/core/util/validators/form_validator.dart';
import 'package:task_manager/features/auth/presentation/controllers/auth_controller.dart';

class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AuthController controller;

  const SignupForm({
    super.key,
    required this.formKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.nameController,
            validator: (value) => nameValidator(value),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Full Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Profile.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          TextFormField(
            controller: controller.emailController,
            validator: (value) => emailValidator(value),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          TextFormField(
            controller: controller.passwordController,
            validator: (value) => passwordValidator(value),
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.defaultPadding * 0.75,
                ),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) return 'Name is required';
  if (value.length < 3) return 'Name must be at least 3 characters';
  return null;
}
