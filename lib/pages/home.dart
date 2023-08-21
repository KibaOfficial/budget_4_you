// Copyright (c) 2023 KibaOfficial
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:budget_4_you/pages/widgets/confirm_dialog.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:budget_4_you/controllers/db.dart';
import 'package:budget_4_you/modals/transaction_modal.dart';
import 'package:budget_4_you/pages/add_transaction.dart';
import 'package:budget_4_you/static.dart' as stc;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DB db = DB();
  DateTime today = DateTime.now();
  SharedPreferences? preferences;
  late Box box;
  int totalAmount = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataSet = [];

  List<FlSpot> getChartPoints(List<TransactionModal> entireData) {
    dataSet = [];
    /* entireData.forEach((key, value) {
      if (value['type'] == 'Expense' && 
        (value['date'] as DateTime).month == today.month) {
          dataSet.add(
            FlSpot(
              (value['date'] as DateTime).day.toDouble(), 
              (value['amount'] as int).toDouble(),
            ),
          );
      }
    }); */

    List tempDataSet = [];

    for (TransactionModal data in entireData) {
      if (data.date.month == today.month && data.type == "Expense") {
        tempDataSet.add(data);
      }
    }

    tempDataSet.sort((a, b) => a.date.day.compareTo(b.date.day));

    for (var i = 0; i < tempDataSet.length; i++) {
      dataSet.add(FlSpot(tempDataSet[i].date.day.toDouble(),
          tempDataSet[i].amount.toDouble()));
    }

    return dataSet;
  }

  getTotalAmount(List<TransactionModal> entireData) {
    totalExpense = 0;
    totalIncome = 0;
    totalAmount = 0;
    for (TransactionModal data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "Income") {
          totalAmount += data.amount;
          totalIncome += data.amount;
        } else {
          totalAmount -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<List<TransactionModal>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModal> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModal(
            element['amount'] as int,
            element['date'] as DateTime,
            element['note'],
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('Budget');
    fetch();
  }

  String getName() {
    if (preferences != null) {
      return preferences!.getString('name')!;
    }
    return "No Name";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.attach_money_outlined,
                color: Colors.lightGreen, size: 40),
            const SizedBox(width: 5),
            Text(
              'Welcome ${getName()}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Icon(
              Icons.settings,
              size: 32.0,
            ),
          ),
        ],
        elevation: 8,
        backgroundColor: stc.PrimaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const AddTransaction(),
            ),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: stc.PrimaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<List<TransactionModal>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Unexpected Error !",
              ),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No data !",
                ),
              );
            }
            getTotalAmount(snapshot.data!);
            getChartPoints(snapshot.data!);
            return ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          stc.PrimaryColor,
                          Colors.blue,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          24.0,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Total Balance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "$totalAmount USD",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(
                                "$totalIncome",
                              ),
                              cardExpense(
                                "$totalExpense",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Expenses",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                dataSet.length < 2
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 40.0,
                        ),
                        margin: const EdgeInsets.all(
                          12.0,
                        ),
                        child: const Text(
                          "No data to render Chart",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 40.0,
                        ),
                        margin: const EdgeInsets.all(
                          12.0,
                        ),
                        height: 300.0,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: getChartPoints(snapshot.data!),
                                isCurved: false,
                                barWidth: 2.5,
                                colors: [
                                  stc.PrimaryColor,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    TransactionModal dataAtIndex;

                    try {
                      dataAtIndex = snapshot.data![index];
                    } catch (e) {
                      return Container();
                    }

                    if (dataAtIndex.type == 'Income') {
                      return incomeTile(
                        dataAtIndex.amount,
                        dataAtIndex.note,
                        dataAtIndex.date,
                        index,
                      );
                    } else {
                      return expenseTile(
                        dataAtIndex.amount,
                        dataAtIndex.note,
                        dataAtIndex.date,
                        index,
                      );
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    "Made with ❤️ by KibaOfficial",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 70.0,
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                "Unexpected Error !",
              ),
            );
          }
        },
      ),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
          // ignore: sort_child_properties_last
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.green[600],
          ),
          margin: const EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
          // ignore: sort_child_properties_last
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.red[600],
          ),
          margin: const EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget expenseTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? awnser = await showConfirmDialog(
          context,
          "WARNING!!",
          "Do You really want to delete this record?",
        );
        // print(awnser.toString());
        if (awnser != null && awnser) {
          db.delData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.all(
          8.0,
        ),
        padding: const EdgeInsets.all(
          16.0,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffced4eb),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      size: 28.0,
                      color: Colors.red[700],
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    const Text(
                      "Expense",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day}.${date.month}.${date.year}",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "- $value USD",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  note,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget incomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? awnser = await showConfirmDialog(
          context,
          "WARNING!!",
          "Do You really want to delete this record?",
        );
        // print(awnser.toString());
        if (awnser != null && awnser) {
          db.delData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.all(
          8.0,
        ),
        padding: const EdgeInsets.all(
          16.0,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffced4eb),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_up_outlined,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    const Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day}.${date.month}.${date.year}",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+ $value USD",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  note,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
