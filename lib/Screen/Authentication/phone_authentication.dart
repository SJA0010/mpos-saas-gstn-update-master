// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:salespro_admin/Screen/Home/home_screen.dart';
//
// import '../../Repository/subscription_plan_repo.dart';
// import '../../model/subscription_plan_model.dart';
// import '../../subscription.dart';
// import 'add_profile.dart';
//
// class FirebaseAuthentication {
//   sendOTP(String phoneNumber) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
//       phoneNumber,
//     );
//
//     return confirmationResult;
//   }
//
//   authenticateMe(
//       {required ConfirmationResult confirmationResult,
//       required String otp,
//       required BuildContext context,
//       required TextEditingController otpController,
//       required String phone}) async {
//     try {
//       SubscriptionPlanRepo subscriptionRepo = SubscriptionPlanRepo();
//       List<SubscriptionPlanModel> allSubscriptionPlans = await subscriptionRepo.getAllSubscriptionPlans();
//
//       for (var element in allSubscriptionPlans) {
//         if (element.subscriptionName == 'Free') {
//           Subscription.freeSubscriptionPlan.subscriptionName = element.subscriptionName;
//           Subscription.freeSubscriptionPlan.subscriptionDate = DateTime.now().toString();
//           Subscription.freeSubscriptionPlan.saleNumber = element.saleNumber;
//           Subscription.freeSubscriptionPlan.purchaseNumber = element.purchaseNumber;
//           Subscription.freeSubscriptionPlan.dueNumber = element.dueNumber;
//           Subscription.freeSubscriptionPlan.partiesNumber = element.partiesNumber;
//           Subscription.freeSubscriptionPlan.products = element.products;
//           Subscription.freeSubscriptionPlan.duration = element.duration;
//         }
//       }
//       UserCredential userCredential = await confirmationResult.confirm(otp);
//       Subscription.getUserLimitsData(context: context, wannaShowMsg: true);
//
//       userCredential.additionalUserInfo!.isNewUser
//           // ignore: use_build_context_synchronously
//           ? ProfileAdd(phoneNumber: phone).launch(context)
//           // ignore: use_build_context_synchronously
//           : const MtHomeScreen().launch(context);
//     } catch (e) {
//       otpController.clear();
//       EasyLoading.showError('Wrong OTP');
//     }
//   }
// }
