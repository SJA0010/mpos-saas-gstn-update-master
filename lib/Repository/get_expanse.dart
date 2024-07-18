import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:salespro_admin/model/expense_model.dart';

import '../constant.dart';

class ExpenseRepo {
  Future<List<ExpenseModel>> getAllExpense() async {
    List<ExpenseModel> allExpense = [];

    await FirebaseDatabase.instance.ref(await getUserID()).child('Expense').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = ExpenseModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allExpense.add(data);
      }
    });
    return allExpense;
  }
}
