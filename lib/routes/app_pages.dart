import 'package:get/get.dart';
import 'package:task_manager/features/auth/presentation/pages/home_page.dart';
import 'package:task_manager/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager/features/auth/presentation/pages/signup_page.dart';
import 'package:task_manager/features/project/domain/entities/project.dart';
import 'package:task_manager/features/project/presentation/pages/project_detail_page.dart';
import 'package:task_manager/features/task/presentation/pages/task_list_page.dart';
import 'package:task_manager/routes/bindings/auth_binding.dart';
import 'package:task_manager/routes/bindings/home_binding.dart';
import 'package:task_manager/routes/bindings/project_binding.dart';
import 'package:task_manager/routes/bindings/task_binding.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: '/login', page: () => LoginPage(), binding: AuthBinding()),
    GetPage(name: '/signup', page: () => SignupPage(), binding: AuthBinding()),
    GetPage(name: '/home', page: () => HomePage(), binding: HomeBinding()),
    GetPage(
      name: '/projects/:id',
      page:
          () => ProjectDetailPage(project: Get.arguments as Project),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: '/projects/:id/tasks',
      page: () => TaskListPage(project: Get.arguments as Project),
      binding: TaskBinding(),
    ),
  ];
}
