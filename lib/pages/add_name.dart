// Copyright (c) 2023 KibaOfficial
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:budget_4_you/pages/home.dart';
import 'package:flutter/material.dart';

import '../controllers/db.dart';

class AddName extends StatefulWidget {
  const AddName({super.key});

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  DB db = DB();

  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: const Color(0xFFE2E7EF),
      body: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(12.0),
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
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              "How should We call you?",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Your Name",
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                onChanged: (val) {
                  name = val;
                },
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SizedBox(
              height: 50.0,
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () async {
                  // check if name is entered
                  if (name.isNotEmpty) {
                    await db.addname(name);
                    if (mounted == true) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                          label: "OK",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                        backgroundColor: Colors.white,
                        content: const Text(
                          "Please Enter a name",
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                    );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Icon(
                      Icons.navigate_next_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
