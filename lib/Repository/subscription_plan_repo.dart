import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import '../constant.dart';
import '../model/subscription_model.dart';
import '../model/subscription_plan_model.dart';

class SubscriptionPlanRepo {
  Future<List<SubscriptionPlanModel>> getAllSubscriptionPlans() async {
    List<SubscriptionPlanModel> planList = [];
    await FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Plan').orderByKey().get().then((value) {
      for (var element in value.children) {
        planList.add(SubscriptionPlanModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return planList;
  }
}

class CurrentSubscriptionPlanRepo {
  Future<SubscriptionModel> getCurrentSubscriptionPlans() async {
    SubscriptionModel finalModel = SubscriptionModel(
      subscriptionName: '',
      subscriptionDate: '',
      saleNumber: 0,
      purchaseNumber: 0,
      partiesNumber: 0,
      dueNumber: 0,
      duration: 0,
      products: 0,
    );

    await FirebaseDatabase.instance.ref('${await getUserID()}/Subscription').get().then((value) {
      var data = jsonDecode(jsonEncode(value.value));
      finalModel = SubscriptionModel.fromJson(data);
    });
    return finalModel;
  }
}
