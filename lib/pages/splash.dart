// Copyright (c) 2023 KibaOfficial
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

// ignore_for_file: use_build_context_synchronously

import 'package:budget_4_you/pages/add_name.dart';
import 'package:budget_4_you/pages/home.dart';
import 'package:flutter/material.dart';

import '../controllers/db.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  DB db = DB();

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  Future getSettings() async {

    String? name = await db.getName();
    if(name != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (
            (context) => const AddName()
          ),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: const Color(0xFFE2E7EF),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              12.0
            ),
          ),
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Image.asset(
            "assets/icon.png",
            width: 64.0,
            height: 64.0,
          ),
        ),
      ),
    );
  }
}