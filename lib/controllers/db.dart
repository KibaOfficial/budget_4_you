// Copyright (c) 2023 KibaOfficial
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DB {
  late Box box;
  late SharedPreferences preferences;


  DB () {
    openBox();
  }

  openBox(){
    box = Hive.box("Budget");
  }
  Future delData(int index) async {
    await box.deleteAt(index);
  }

  Future addData(int amount, DateTime currentDate, String note, String type) async {
    var value = {'amount': amount, 'date': currentDate, 'type': type, 'note': note};
    box.add(value);
  }

  addname(String name) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString('name', name);
  }

  getName() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString('name');
  }
}