// Copyright (c) 2023 KibaOfficial
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:hive/hive.dart';

class DB {
  late Box box;


  DB () {
    openBox();
  }

  openBox(){
    box = Hive.box("Budget");
  }

  Future addData(int amount, DateTime currentDate, String note, String type) async {
    var value = {'amount': amount, 'date': currentDate, 'type': type, 'note': note};
    box.add(value);
  }

  Future<Map> fetch() {
    if (box.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(box.toMap());
    }
  }
}