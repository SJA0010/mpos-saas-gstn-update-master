import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:salespro_admin/model/daily_transaction_model.dart';

import '../constant.dart';

class DailyTransactionRepo {
  Future<List<DailyTransactionModel>> getAllDailyTransition() async {
    List<DailyTransactionModel> dailyTransactionLists = [];
    await FirebaseDatabase.instance.ref(await getUserID()).child('Daily Transaction').orderByKey().get().then((value) {
      for (var element in value.children) {
        dailyTransactionLists.add(DailyTransactionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return dailyTransactionLists;
  }
}
