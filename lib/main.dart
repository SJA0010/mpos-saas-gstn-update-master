import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_admin/Language/language.dart';
import 'package:salespro_admin/Screen/Authentication/sign_up.dart';
import 'package:salespro_admin/Screen/Authentication/subscription_plan_page.dart';
import 'package:salespro_admin/Screen/Authentication/tablet_log_in.dart';
import 'package:salespro_admin/Screen/Customer%20List/customer_list.dart';
import 'package:salespro_admin/Screen/Due%20List/due_list_screen.dart';
import 'package:salespro_admin/Screen/Expenses/expenses_list.dart';
import 'package:salespro_admin/Screen/Expenses/new_expense.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/Home/tablate_home.dart';
import 'package:salespro_admin/Screen/Income/income_list.dart';
import 'package:salespro_admin/Screen/Ledger%20Screen/ledger_screen.dart';
import 'package:salespro_admin/Screen/LossProfit/loss_profit_screen.dart';
import 'package:salespro_admin/Screen/POS%20Sale/pos_sale.dart';
import 'package:salespro_admin/Screen/Payment%20Handler/payment_cancel.dart';
import 'package:salespro_admin/Screen/Payment%20Handler/payment_success.dart';
import 'package:salespro_admin/Screen/Product/tablet_add_product.dart';
import 'package:salespro_admin/Screen/Product/tablet_product.dart';
import 'package:salespro_admin/Screen/Purchase/purchase.dart';
import 'package:salespro_admin/Screen/Quotation%20List/quotation_list.dart';
import 'package:salespro_admin/Screen/Reports/report_screen.dart';
import 'package:salespro_admin/Screen/Supplier%20List/supplier_list.dart';
import 'package:salespro_admin/Screen/User%20Role%20System/user_role_screen.dart';
import 'package:salespro_admin/Screen/daily_tanasaction.dart';
import 'package:url_strategy/url_strategy.dart';
import 'Language/language_change_provider.dart';
import 'Screen/Authentication/forgot_password.dart';
import 'Screen/Authentication/login_with_email.dart';
import 'Screen/Authentication/tablet_signup.dart';
import 'Screen/Income/new_income.dart';
import 'Screen/Product/product.dart';
import 'Screen/Purchase List/purchase_list.dart';
import 'Screen/Sale List/sale_list.dart';
import 'Screen/Widgets/Constant Data/constant.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'model/paypal_info_model.dart';
import 'package:provider/provider.dart' as pro;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    getPaypalInfo();
    // Subscription.getUserLimitsData(context: context,wannaShowMsg: true);
    return pro.ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
          builder: (context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              locale:
                  pro.Provider.of<LanguageChangeProvider>(context, listen: true)
                      .currentLocale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              builder: EasyLoading.init(),
              title: 'MPOS',
              theme: ThemeData(fontFamily: 'Display'),
              onGenerateRoute: generateRoute,
              initialRoute: '/',
              routes: {
                '/': (context) =>
                    const LogInEmail(isEmailLogin: true, panelName: ''),
                // '/': (context) => const MtHomeScreen(),
                MtHomeScreen.route: (context) => const MtHomeScreen(),
                PosSale.route: (context) => const PosSale(),
                Purchase.route: (context) => const Purchase(),
                Product.route: (context) => const Product(),
                SupplierList.route: (context) => const SupplierList(),
                CustomerList.route: (context) => const CustomerList(),
                ExpensesList.route: (context) => const ExpensesList(),
                LanguageScreen.route: (context) => const LanguageScreen(),
                IncomeList.route: (context) => const IncomeList(),
                NewExpense.route: (context) => const NewExpense(),
                NewIncome.route: (context) => const NewIncome(),
                UserRoleScreen.route: (context) => const UserRoleScreen(),
                Reports.route: (context) => Reports(
                    name:
                        ModalRoute.of(context)!.settings.arguments.toString()),
                // PricingPage.route: (context) =>  PricingPage(),
                PaymentSuccess.route: (context) => const PaymentSuccess(),
                PaymentCancel.route: (context) => const PaymentCancel(),
                SaleList.route: (context) => const SaleList(),
                QuotationList.route: (context) => const QuotationList(),
                PurchaseList.route: (context) => const PurchaseList(),
                // LogIn.route: (context) => const LogIn(),
                ForgotPassword.route: (context) => const ForgotPassword(),
                SignUp.route: (context) => const SignUp(),
                TabletLogIn.route: (context) => const TabletLogIn(),
                TabletSignUp.route: (context) => const TabletSignUp(),
                DailyTransactionScreen.route: (context) =>
                    const DailyTransactionScreen(),

                //Tablet
                TablateHome.route: (context) => const TablateHome(),
                TabletProductScreen.route: (context) =>
                    const TabletProductScreen(),
                TabletAddProduct.route: (context) => const TabletAddProduct(),
                LedgerScreen.route: (context) => const LedgerScreen(),
                LossProfitScreen.route: (context) => const LossProfitScreen(),
                DueList.route: (context) => const DueList(),
                SubscriptionPage.route: (context) => const SubscriptionPage(),
              } // TabletSaleReport.route: (context) => const TabletSaleReport(),
              )),
    );
  }

  Future<void> getPaypalInfo() async {
    DatabaseReference paypalRef =
        FirebaseDatabase.instance.ref('Admin Panel/Paypal Info');
    final paypalData = await paypalRef.get();
    PaypalInfoModel paypalInfoModel =
        PaypalInfoModel.fromJson(jsonDecode(jsonEncode(paypalData.value)));

    paypalClientId = paypalInfoModel.paypalClientId;
    paypalClientSecret = paypalInfoModel.paypalClientSecret;
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    var uri = Uri.parse(settings.name!);
    switch (uri.path) {
      case 'success/':
        return MaterialPageRoute(builder: (_) => const PaymentSuccess());
      default:
        return MaterialPageRoute(builder: (_) => const PaymentSuccess());
    }
  }
}
