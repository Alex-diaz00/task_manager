import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  ThemeData get theme => Theme.of(this);
}
