import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  final GetStorage storage;

  AuthMiddleware(this.storage);

  @override
  RouteSettings? redirect(String? route) {
    return storage.hasData('access_token')
        ? null
        : RouteSettings(name: '/login');
  }
}
