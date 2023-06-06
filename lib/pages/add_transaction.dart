// Copyright (c) 2023 KibaOfficial
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:budget_4_you/db.dart';
import 'package:flutter/material.dart';
import 'package:budget_4_you/static.dart' as stc;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  int? amount;
  String note = "No note was made";
  String type = "";
  DateTime newDate = DateTime.now();

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: newDate, 
      firstDate: DateTime(2020, 12), 
      lastDate: DateTime(2100, 01),
    );
    if (picked != null && picked != newDate) {
      setState(() {
        newDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd MMMM yyyy').format(newDate);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),

      backgroundColor: const Color(0xffe2e7ef),
                  
      body: 
      ListView(
        padding: const EdgeInsets.all(
          12.0
        ),
        children: [

          const SizedBox(
            height: 20.0,
          ),

          const Text(
            "Add Transaction",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 20.0,
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: stc.PrimaryColor,
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: const Icon(
                  Icons.attach_money,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                width: 12.0,
              ),

              Expanded(
                child: TextField(
                  decoration: 
                  const InputDecoration(
                    hintText: "0",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val){
                    try {
                      amount = int.parse(val);
                    } catch (e) {}
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20.0,
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: stc.PrimaryColor,
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: const Icon(
                  Icons.description,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                width: 12.0,
              ),

              Expanded(
                child: TextField(
                  decoration: 
                  const InputDecoration(
                    hintText: "Note",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val){
                    note = val;
                  },
                  maxLength: 24,
                ),
              ),
            ],
          ),

          const SizedBox(
            width: 12.0,
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: stc.PrimaryColor,
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: const Icon(
                  Icons.moving,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                width: 12.0,
              ),
              
              ChoiceChip(
                label: Text(
                  "Income",
                  style: TextStyle(
                    color: type == "Income" ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ), 
                selected: type == "Income" ? true : false,
                onSelected: (val){
                  if(val){
                    setState(() {
                      type = "Income";
                    });
                  }
                },
                selectedColor: Colors.lightGreen,
                backgroundColor: stc.PrimaryColor,
              ),

              const SizedBox(
                width: 12.0,
              ),
              
              ChoiceChip(
                label: Text(
                  "Expense",
                  style: TextStyle(
                    color: type == "Expense" ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ), 
                selected: type == "Expense" ? true : false,
                onSelected: (val){
                  if(val){
                    setState(() {
                      type = "Expense";
                    });
                  }
                },
                selectedColor: Colors.red,
                backgroundColor: stc.PrimaryColor,
              ),

            ],
          ),

          const SizedBox(
            height: 20.0,
          ),

          SizedBox(
            height: 50.0,
            child: TextButton(
              onPressed: () {
                _selectedDate(context);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.zero,
                ),
              ),
              child: 
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: stc.PrimaryColor,
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(
                        12.0,
                      ),
                      child: const Icon(
                        Icons.date_range,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(
                      width: 12.0,
                    ),

                    Text(
                      currentDate,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
            ),
          ),

          const SizedBox(
            height: 20.0,
          ),

          SizedBox(
            height: 50.0,
            child: ElevatedButton(
              onPressed: () async {
                if(amount != null && note.isNotEmpty) {
                  DB db = DB();
                  await db.addData(amount!, newDate, note, type);
                  Navigator.of(context).pop();
                } else {
                  print("missing values!");
                }
              }, 
              child: 
                const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
            ),
          ),

        ],
      ),
    );
  }
}