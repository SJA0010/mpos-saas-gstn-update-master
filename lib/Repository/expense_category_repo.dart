import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:salespro_admin/model/expense_category_model.dart';
import 'package:salespro_admin/model/income_catehory_model.dart';

import '../constant.dart';

class ExpenseCategoryRepo {
  Future<List<ExpenseCategoryModel>> getAllExpenseCategory() async {
    List<ExpenseCategoryModel> allExpenseCategoryList = [];

    await FirebaseDatabase.instance.ref(await getUserID()).child('Expense Category').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = ExpenseCategoryModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allExpenseCategoryList.add(data);
      }
    });
    return allExpenseCategoryList;
  }
}

class IncomeCategoryRepo {
  Future<List<IncomeCategoryModel>> getAllIncomeCategory() async {
    List<IncomeCategoryModel> allIncomeCategoryList = [];

    await FirebaseDatabase.instance.ref(await getUserID()).child('Income Category').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = IncomeCategoryModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allIncomeCategoryList.add(data);
      }
    });
    return allIncomeCategoryList;
  }
}
