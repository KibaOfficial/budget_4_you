// Copyright (c) 2023 KibaOfficial
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

class TransactionModal {
  final int amount;
  final DateTime date;
  final String note;
  final String type;

  TransactionModal(this.amount, this.date, this.note, this.type);
}