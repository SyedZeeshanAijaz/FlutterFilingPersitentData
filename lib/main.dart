import 'package:flutter/material.dart';
import 'package:persistent_filing/service/app_service.dart';

import 'screens/home_page.dart';

void main() {
  AppService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'TodoApp'),
    );
  }
}
