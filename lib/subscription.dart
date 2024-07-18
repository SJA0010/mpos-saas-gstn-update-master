// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Customer%20List/customer_list.dart';
import 'package:salespro_admin/Screen/Due%20List/due_list_screen.dart';
import 'package:salespro_admin/Screen/Supplier%20List/supplier_list.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:salespro_admin/constant.dart';
import 'generated/l10n.dart' as lang;
import 'Repository/subscription_plan_repo.dart';
import 'Screen/Authentication/subscription_plan_page.dart';
import 'Screen/POS Sale/pos_sale.dart';
import 'Screen/Product/product.dart';
import 'Screen/Purchase/purchase.dart';
import 'model/subscription_model.dart';

class Subscription {
  CurrentSubscriptionPlanRepo currentSubscriptionPlanRepo =
      CurrentSubscriptionPlanRepo();
  static const String currency = 'USD';
  static bool isExpiringInFiveDays = false;
  static bool isExpiringInOneDays = false;

  static SubscriptionModel freeSubscriptionPlan = SubscriptionModel(
    subscriptionName: 'Free',
    subscriptionDate: DateTime.now().toString(),
    saleNumber: 50,
    purchaseNumber: 50,
    partiesNumber: 50,
    dueNumber: 50,
    duration: 30,
    products: 50,
  );
  static late SubscriptionModel dataModel;
  static late String subscriptionName;
  static late int remainingSales;
  static late int remainingPurchase;
  static late int remainingParties;
  static late int remainingDue;
  static late int remainingProducts;
  static late Duration remainingTime;
  static late int subscriptionDuration;

  static Future<void> getUserLimitsData(
      {required BuildContext context, required bool wannaShowMsg}) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('$constUserId/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    dataModel = SubscriptionModel.fromJson(data);
    remainingTime =
        DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());

    subscriptionName = dataModel.subscriptionName;
    subscriptionDuration = dataModel.duration;
    remainingSales = dataModel.saleNumber;
    remainingPurchase = dataModel.purchaseNumber;
    remainingParties = dataModel.partiesNumber;
    remainingDue = dataModel.dueNumber;
    remainingProducts = dataModel.products;
    if (subscriptionDuration != -202 && wannaShowMsg) {
      if (remainingTime.inHours.abs().isBetween(
          (subscriptionDuration * 24) - 24, subscriptionDuration * 24)) {
        isExpiringInOneDays = true;
        isExpiringInFiveDays = false;
      } else if (remainingTime.inHours.abs().isBetween(
          (subscriptionDuration * 24) - 120, subscriptionDuration * 24)) {
        isExpiringInFiveDays = true;
        isExpiringInOneDays = false;
      }

      if (isExpiringInFiveDays) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: const CircleBorder(side: BorderSide.none),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lang.S.of(context).yourCurrentPackageWillExpireIn5days,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kGreyTextColor),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          lang.S.of(context).cancel,
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      if (isExpiringInOneDays) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: const CircleBorder(side: BorderSide.none),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          lang.S.of(context).yourPackageWillBeExpireToday,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kGreyTextColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lang.S.of(context).pleasePurchaseAgain,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kGreyTextColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            const SubscriptionPage().launch(context);
                          },
                          child: Text(
                            lang.S.of(context).purchase,
                            style: const TextStyle(
                                fontSize: 18, color: kBlueTextColor),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            lang.S.of(context).cancel,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  static Future<bool> subscriptionChecker({
    required String item,
  }) async {
    final DatabaseReference subscriptionRef = FirebaseDatabase.instance
        .ref()
        .child(constUserId)
        .child('Subscription');

    if (remainingTime.inHours.abs() > subscriptionDuration * 24) {
      await subscriptionRef.set(freeSubscriptionPlan.toJson());
    } else if (item == PosSale.route &&
        remainingSales <= 0 &&
        remainingSales != -202) {
      return false;
    } else if ((item == SupplierList.route || item == CustomerList.route) &&
        remainingParties <= 0 &&
        remainingParties != -202) {
      return false;
    } else if (item == Purchase.route &&
        remainingPurchase <= 0 &&
        remainingPurchase != -202) {
      return false;
    } else if (item == Product.route &&
        remainingProducts <= 0 &&
        remainingProducts != -202) {
      return false;
    } else if (item == DueList.route &&
        remainingDue <= 0 &&
        remainingDue != -202) {
      return false;
    }
    return true;
  }

  static void decreaseSubscriptionLimits(
      {required String itemType, required BuildContext context}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref(userId).child('Subscription');
    ref.keepSynced(true);
    ref.child(itemType).get().then((value) {
      int beforeAction = int.parse(value.value.toString());
      if (beforeAction != -202) {
        int afterAction = beforeAction - 1;
        ref.update({itemType: afterAction});
        Subscription.getUserLimitsData(context: context, wannaShowMsg: false);
      }
    });
  }
}
