import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Due%20List/due_list_screen.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/Ledger%20Screen/ledger_screen.dart';
import 'package:salespro_admin/Screen/LossProfit/loss_profit_screen.dart';
import 'package:salespro_admin/Screen/POS%20Sale/pos_sale.dart';
import 'package:salespro_admin/Screen/Product/product.dart';
import 'package:salespro_admin/Screen/Purchase/purchase.dart';
import 'package:salespro_admin/Screen/User%20Role%20System/user_role_screen.dart';
import 'package:salespro_admin/Screen/daily_tanasaction.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../Repository/subscription_plan_repo.dart';
import '../../../constant.dart';
import '../../../model/subscription_model.dart';
import '../../Authentication/subscription_plan_page.dart';
import '../../Customer List/customer_list.dart';
import '../../Expenses/expenses_list.dart';
import '../../Income/income_list.dart';
import '../../Purchase List/purchase_list.dart';
import '../../Quotation List/quotation_list.dart';
import '../../Reports/report_screen.dart';
import '../../Sale List/sale_list.dart';
import '../../Supplier List/supplier_list.dart';
import '../Constant Data/constant.dart';

List<String> getTitleList({required BuildContext context}) {
  List<String> titleList = [
    lang.S.of(context).dashBoard,
    lang.S.of(context).posSale,
    lang.S.of(context).purchase,
    lang.S.of(context).product,
    lang.S.of(context).suplaierList,
    lang.S.of(context).customerList,
    // 'Sale List',
    // 'Quotation List',
    // 'Purchase List',
    lang.S.of(context).dueList,
    lang.S.of(context).ledger,
    lang.S.of(context).lossProfit,
    lang.S.of(context).expense,
    lang.S.of(context).income,
    lang.S.of(context).dailyTransantion,
    lang.S.of(context).reports,
    lang.S.of(context).subscription,
    lang.S.of(context).userRole
  ];
  return titleList;
}

List<IconData> iconList = [
  Icons.dashboard,
  Icons.style,
  FontAwesomeIcons.cartShopping,
  FeatherIcons.package,
  FontAwesomeIcons.fileLines,
  FontAwesomeIcons.userGroup,
  // MdiIcons.scriptText,
  // Icons.featured_play_list,
  // MdiIcons.scriptText,
  Icons.list_alt,
  Icons.pie_chart,
  Icons.add_chart_outlined,
  Icons.account_balance_wallet_rounded,
  Icons.insert_chart,
  Icons.account_balance_outlined,
  FontAwesomeIcons.fileLines,
  Icons.subscriptions,
  FontAwesomeIcons.usersRectangle,
];

List<String> screenList = [
  MtHomeScreen.route,
  PosSale.route,
  Purchase.route,
  Product.route,
  SupplierList.route,
  CustomerList.route,
  // SaleList.route,
  // QuotationList.route,
  // PurchaseList.route,
  DueList.route,
  LedgerScreen.route,
  LossProfitScreen.route,
  ExpensesList.route,
  IncomeList.route,
  DailyTransactionScreen.route,
  Reports.route,
  SubscriptionPage.route,
  UserRoleScreen.route,
];

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({Key? key, required this.index, required this.isTab, this.subManu}) : super(key: key);
  final int index;
  final bool isTab;
  final String? subManu;

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  CurrentSubscriptionPlanRepo currentSubscriptionPlanRepo = CurrentSubscriptionPlanRepo();

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
  void checkSubscriptionData() async {
    subscriptionModel = await currentSubscriptionPlanRepo.getCurrentSubscriptionPlans();

    setState(() {
      subscriptionModel;
    });
  }

  List<String> titleList = [];

  @override
  void initState() {
    checkSubscriptionData();
    super.initState();
  }

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    titleList = getTitleList(context: context);
    return Container(
      height: context.height(),
      decoration: const BoxDecoration(color: kDarkGreyColor),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 10, bottom: 8),
              child: Image.asset('images/mposlogo.png'),
            ),
            const Divider(
              thickness: 1.0,
              color: kGreyTextColor,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: titleList.length,
                itemBuilder: (_, i) {
                  return titleList[i] == lang.S.of(context).posSale || titleList[i] == lang.S.of(context).purchase
                      ? saleExpandedManu(selected: widget.subManu ?? '', manu: titleList[i], context: context)
                      : Container(
                          color: widget.index == i ? kBlueTextColor : null,
                          child: ListTile(
                            selectedTileColor: kBlueTextColor,
                            onTap: (() {
                              checkPermission(item: titleList[i]) ? Navigator.of(context).pushNamed(screenList[i]) : EasyLoading.showError('Access Denied!');
                            }),
                            leading: Icon(iconList[i], color: kWhiteTextColor),
                            title: Text(
                              titleList[i],
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                            trailing: const Icon(
                              FeatherIcons.chevronRight,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                        ).visible(!((isSubUser && titleList[i] == lang.S.of(context).userRole) || (isSubUser && titleList[i] == lang.S.of(context).subscription)));
                }),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * .50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.green),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: kDarkGreyColor.withOpacity(0.3)), borderRadius: BorderRadius.circular(10)),
                      height: 70,
                      width: 45,
                      child: const Center(
                        child: Icon(
                          FontAwesomeIcons.crown,
                          color: kYellowColor,
                          size: 30.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You are using \n${subscriptionModel.subscriptionName} Plan',
                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                          maxLines: 3,
                        ),
                        Text(
                          'Expires in ${(DateTime.parse(subscriptionModel.subscriptionDate).difference(DateTime.now()).inDays.abs() - subscriptionModel.duration).abs()} Days',
                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                          maxLines: 3,
                        ).visible(subscriptionModel.subscriptionName != 'Lifetime'),
                      ],
                    )
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       'Upgrade On Mobile App',
                    //       style: kTextStyle.copyWith(color: kYellowColor, fontWeight: FontWeight.bold),
                    //     ),
                    //     const Icon(
                    //       FontAwesomeIcons.arrowRight,
                    //       color: kYellowColor,
                    //     ),
                    //   ],
                    // ).visible(false),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget saleExpandedManu({required String selected, required String manu, required BuildContext context}) {
  String selectedItems = selected;
  if (manu == lang.S.of(context).posSale) {
    return StatefulBuilder(builder: (context, manuSetState) {
      return ExpansionTile(
        initiallyExpanded:
            selectedItems == lang.S.of(context).posSale || selectedItems == lang.S.of(context).salesList || selectedItems == lang.S.of(context).quatation ? true : false,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          lang.S.of(context).sales,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ), //add icon
        childrenPadding: const EdgeInsets.only(left: 20), //children padding
        children: [
          ///_______________POS Sale_________________________________________________
          Container(
            color: selectedItems == 'Sales' ? kBlueTextColor : null,
            child: ListTile(
              leading: const Icon(
                Icons.point_of_sale_sharp,
                color: Colors.white,
              ),
              title: Text(
                lang.S.of(context).posSale,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                manuSetState(() {
                  selectedItems = 'POS Sale';
                  // Navigator.pushNamed(context, PosSale.route);
                  checkPermission(item: selectedItems) ? Navigator.of(context).pushNamed(PosSale.route) : EasyLoading.showError('Access Denied!');
                });
                //action on press
              },
            ),
          ),

          ///_______________Sales List_________________________________________________

          Container(
            color: selectedItems == 'Sales List' ? kBlueTextColor : null,
            child: ListTile(
              leading: const Icon(
                Icons.list,
                color: Colors.white,
              ),
              title: Text(
                lang.S.of(context).salesList,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                manuSetState(() {
                  selectedItems = 'Sales List';
                  // Navigator.pushNamed(context, SaleList.route);
                  checkPermission(item: selectedItems) ? Navigator.of(context).pushNamed(SaleList.route) : EasyLoading.showError('Access Denied!');
                });
              },
            ),
          ),

          ///_______________Quotation List_________________________________________________

          Container(
            color: selectedItems == 'Quotation List' ? kBlueTextColor : null,
            child: ListTile(
              leading: const Icon(
                Icons.list,
                color: Colors.white,
              ),
              title: Text(
                lang.S.of(context).quotationList,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                manuSetState(() {
                  selectedItems = 'Quotation List';
                  checkPermission(item: selectedItems) ? Navigator.of(context).pushNamed(QuotationList.route) : EasyLoading.showError('Access Denied!');
                  // Navigator.pushNamed(context, QuotationList.route);
                });
              },
            ),
          ),
          //more child menu
        ],
      );
    });
  } else {
    return StatefulBuilder(builder: (context, manuSetState) {
      return ExpansionTile(
        initiallyExpanded: selectedItems == 'Purchase List' ? true : false,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          lang.S.of(context).purchase,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ), //add icon
        childrenPadding: const EdgeInsets.only(left: 20), //children padding
        children: [
          ///_______________Purchase_________________________________________________
          Container(
            color: selectedItems == 'Purchase' ? kBlueTextColor : null,
            child: ListTile(
              leading: const Icon(
                Icons.point_of_sale_sharp,
                color: Colors.white,
              ),
              title: Text(
                lang.S.of(context).purchase,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                manuSetState(() {
                  selectedItems = 'Purchase';
                  // Navigator.pushNamed(context, Purchase.route);
                  checkPermission(item: selectedItems) ? Navigator.of(context).pushNamed(Purchase.route) : EasyLoading.showError('Access Denied!');
                });
                //action on press
              },
            ),
          ),

          ///_______________Purchase List_________________________________________________

          Container(
            color: selectedItems == 'Purchase List' ? kBlueTextColor : null,
            child: ListTile(
              leading: const Icon(
                Icons.list,
                color: Colors.white,
              ),
              title: Text(
                lang.S.of(context).purchaseList,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              onTap: () {
                manuSetState(() {
                  selectedItems = 'Purchase List';
                  checkPermission(item: selectedItems) ? Navigator.of(context).pushNamed(PurchaseList.route) : EasyLoading.showError('Access Denied!');
                  // Navigator.pushNamed(context, PurchaseList.route);
                });
              },
            ),
          ),

          //more child menu
        ],
      );
    });
  }
}

bool checkPermission({required String item}) {
  if (item == 'POS Sale') {
    return finalUserRoleModel.salePermission;
  } else if (item == 'Supplier List' || item == 'Customer List') {
    return finalUserRoleModel.partiesPermission;
  } else if (item == 'Purchase') {
    return finalUserRoleModel.purchasePermission;
  } else if (item == 'Product') {
    return finalUserRoleModel.productPermission;
  } else if (item == 'Due List') {
    return finalUserRoleModel.dueListPermission;
  } else if (item == 'Stock') {
    return finalUserRoleModel.stockPermission;
  } else if (item == 'Reports') {
    return finalUserRoleModel.reportsPermission;
  } else if (item == 'Sales List') {
    return finalUserRoleModel.salesListPermission;
  } else if (item == 'Purchase List') {
    return finalUserRoleModel.purchaseListPermission;
  } else if (item == 'Loss/Profit') {
    return finalUserRoleModel.lossProfitPermission;
  } else if (item == 'Expenses') {
    return finalUserRoleModel.addExpensePermission;
  } else if (item == 'Ledger') {
    return finalUserRoleModel.ledgerPermission;
  } else if (item == 'Income') {
    return finalUserRoleModel.incomePermission;
  } else if (item == 'Daily Transaction') {
    return finalUserRoleModel.dailyTransActionPermission;
  }
  return true;
}
