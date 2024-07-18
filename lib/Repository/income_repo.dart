import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:salespro_admin/model/income_modle.dart';

import '../constant.dart';

class IncomeRepo {
  Future<List<IncomeModel>> getAllIncome() async {
    List<IncomeModel> allIncome = [];

    await FirebaseDatabase.instance.ref(await getUserID()).child('Income').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = IncomeModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allIncome.add(data);
      }
    });
    return allIncome;
  }
}
