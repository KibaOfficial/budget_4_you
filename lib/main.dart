// Copyright (c) 2023 KibaOfficial
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:budget_4_you/pages/splash.dart';
import 'package:budget_4_you/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("Budget");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget 4 You',
      theme: myTheme,
      home: const Splash(),
    );
  }
}