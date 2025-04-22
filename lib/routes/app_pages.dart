import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/pages/home_page.dart';
import 'package:task_manager/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager/features/auth/presentation/pages/signup_page.dart';
import 'package:task_manager/features/project/presentation/pages/projects_page.dart';
import 'package:task_manager/routes/bindings/auth_binding.dart';
import 'package:task_manager/routes/bindings/home_binding.dart';
import 'package:task_manager/routes/bindings/project_binding.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: '/login', page: () => LoginPage(), binding: AuthBinding()),
    GetPage(name: '/signup', page: () => SignupPage(), binding: AuthBinding()),
    GetPage(name: '/home', page: () => HomePage(), binding: HomeBinding()),
    GetPage(
      name: '/projects',
      page: () => ProjectsPage(),
      binding: ProjectBinding(),
    ),
  ];
}
