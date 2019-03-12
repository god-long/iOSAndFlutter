import 'package:flutter/material.dart';
import 'dart:ui';
import 'present_page.dart';
import 'push_page.dart';

void main() => runApp(_widgetForRoute(window.defaultRouteName));

Widget _widgetForRoute(String route) {
  // 如果用Xcode运行，此打印也会打印到Xcode的控制台
  print('loong route:' + route);

  switch (route) {
    case 'presentPage':
      return PresentPageApp();
    case 'pushPage':
      return PushFirstApp();
    default:
      return PushFirstApp();
  }
}

