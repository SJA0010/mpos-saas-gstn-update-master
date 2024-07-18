import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Repository/subscription_plan_repo.dart';

import '../Screen/Authentication/add_profile.dart';
import '../Screen/Home/home_screen.dart';
import '../constant.dart';
import '../model/subscription_plan_model.dart';
import '../subscription.dart';

final signUpProvider = ChangeNotifierProvider((ref) => SignUpRepo());

class SignUpRepo extends ChangeNotifier {
  String email = '';
  String password = '';

  Future<void> signUp(BuildContext context) async {
    EasyLoading.show(status: 'Registering....');
    try {
      SubscriptionPlanRepo subscriptionRepo = SubscriptionPlanRepo();
      List<SubscriptionPlanModel> allSubscriptionPlans = await subscriptionRepo.getAllSubscriptionPlans();

      for (var element in allSubscriptionPlans) {
        if (element.subscriptionName == 'Free') {
          Subscription.freeSubscriptionPlan.subscriptionName = element.subscriptionName;
          Subscription.freeSubscriptionPlan.subscriptionDate = DateTime.now().toString();
          Subscription.freeSubscriptionPlan.saleNumber = element.saleNumber;
          Subscription.freeSubscriptionPlan.purchaseNumber = element.purchaseNumber;
          Subscription.freeSubscriptionPlan.dueNumber = element.dueNumber;
          Subscription.freeSubscriptionPlan.partiesNumber = element.partiesNumber;
          Subscription.freeSubscriptionPlan.products = element.products;
          Subscription.freeSubscriptionPlan.duration = element.duration;
        }
      }
      mainLoginEmail = email;
      mainLoginPassword = password;

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      EasyLoading.showSuccess('Successful');
      setUserDataOnLocalData(uid: FirebaseAuth.instance.currentUser!.uid, subUserTitle: '', isSubUser: false);
      putUserDataImidiyate(uid: FirebaseAuth.instance.currentUser!.uid, title: '', isSubUse: false);
      // ignore: use_build_context_synchronously
      Subscription.getUserLimitsData(context: context, wannaShowMsg: true);
      userCredential.additionalUserInfo!.isNewUser
          // ignore: use_build_context_synchronously
          ? const ProfileAdd().launch(context)
          // ignore: use_build_context_synchronously
          : const MtHomeScreen().launch(context);
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError('Failed with Error');
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      EasyLoading.showError('Failed with Error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
