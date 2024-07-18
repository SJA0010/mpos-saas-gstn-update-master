import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:salespro_admin/Repository/subscription_plan_repo.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../model/subscription_model.dart';
import '../../model/subscription_plan_model.dart';
import '../Widgets/Constant Data/constant.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({Key? key}) : super(key: key);
  static const String route = '/pricing/success/';
  static void updateSubscription(String userId, String planName, BuildContext context) async {
    SubscriptionModel subscriptionModel = SubscriptionModel(
      subscriptionName: '',
      subscriptionDate: DateTime.now().toString(),
      saleNumber: 0,
      purchaseNumber: 0,
      partiesNumber: 0,
      dueNumber: 0,
      duration: 0,
      products: 0,
    );
    SubscriptionPlanRepo subscriptionPlanRepo = SubscriptionPlanRepo();
    EasyLoading.show(status: 'Loading...', dismissOnTap: false);

    List<SubscriptionPlanModel> planList = await subscriptionPlanRepo.getAllSubscriptionPlans();

    for (var element in planList) {
      if (element.subscriptionName == planName) {
        subscriptionModel = SubscriptionModel(
          subscriptionName: element.subscriptionName,
          subscriptionDate: DateTime.now().toString(),
          saleNumber: element.saleNumber,
          purchaseNumber: element.purchaseNumber,
          partiesNumber: element.partiesNumber,
          dueNumber: element.dueNumber,
          duration: element.duration,
          products: element.products,
        );
      }
    }

    final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(userId).child('Subscription');

    await subscriptionRef.set(subscriptionModel.toJson());
    EasyLoading.showSuccess('Added Successfully', duration: const Duration());
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, MtHomeScreen.route);
    // MtHomeScreen().launch(context);
    // Navigator.pop(context);
  }

  @override
  // ignore: library_private_types_in_public_api
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  void postPacakge(BuildContext context) {
    String userId = Uri.base.queryParameters["userId"].toString();
    String plan = Uri.base.queryParameters["plan"].toString();
    PaymentSuccess.updateSubscription(userId, plan, context);
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    counter == 0 ? postPacakge(context) : null;
    counter++;
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/mpos.png'),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: kGreyTextColor.withOpacity(0.1),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          lang.S.of(context).yourPaymentisSuccesful,
                          style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
