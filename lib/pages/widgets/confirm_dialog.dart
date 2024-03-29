// Copyright (c) 2023 KibaOfficial
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showConfirmDialog(BuildContext context, String title, String content) async {
  return await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, 
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.red,
            ),
          ),
          child: const Text(
            "YES",
          ),
        ),
        ElevatedButton(onPressed: () {
          Navigator.of(context).pop(false);
        }, 
          child: const Text(
            "NO",
          ),
        ),
      ],
    ),
  );
}