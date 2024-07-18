import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Reports/daily_transaction.dart';

import '../../model/transition_model.dart';
import 'Widgets/Constant Data/constant.dart';
import 'Widgets/Sidebar/sidebar_widget.dart';
import 'Widgets/TopBar/top_bar_widget.dart';

class DailyTransactionScreen extends StatefulWidget {
  const DailyTransactionScreen({Key? key}) : super(key: key);
  static const String route = '/Daily_Traction';

  @override
  State<DailyTransactionScreen> createState() => _DailyTransactionScreenState();
}

class _DailyTransactionScreenState extends State<DailyTransactionScreen> {
  List<String> categoryList = [
    'Sale',
    'Purchase',
    'Due',
    'Current Stock',
    'Daily Transaction',
  ];

  String selected = 'Sale';

  List<String> month = [
    'This Month',
    'Last Month',
    'March',
    'February',
    'January',
  ];

  String selectedMonth = 'This Month';

  DropdownButton<String> getMonth() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in month) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedMonth,
      onChanged: (value) {
        setState(() {
          selectedMonth = value!;
        });
      },
    );
  }

  DateTime selectedDate = DateTime.now();

  DateTime selected2ndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // voidLink(context: context);
  }

  double getTotalDue(List<SaleTransactionModel> transitionModel) {
    double total = 0.0;
    for (var element in transitionModel) {
      total += element.dueAmount!;
    }
    return total;
  }

  double calculateTotalSale(List<SaleTransactionModel> transitionModel) {
    double total = 0.0;
    for (var element in transitionModel) {
      total += element.totalAmount!;
    }
    return total;
  }

  ScrollController mainScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Scrollbar(
        controller: mainScroll,
        child: SingleChildScrollView(
          controller: mainScroll,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 240,
                child: SideBarWidget(
                  index: 11,
                  isTab: false,
                ),
              ),
              Container(
                width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                decoration: const BoxDecoration(color: kDarkWhite),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: kWhiteTextColor,
                        ),
                        child: const TopBar(),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         width: context.width(),
                            //         padding: const EdgeInsets.all(10.0),
                            //         decoration: BoxDecoration(
                            //           borderRadius: const BorderRadius.only(
                            //             topLeft: Radius.circular(10.0),
                            //             topRight: Radius.circular(10.0),
                            //           ),
                            //           color: kGreyTextColor.withOpacity(0.1),
                            //         ),
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               'Transaction Report',
                            //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         decoration: const BoxDecoration(
                            //             borderRadius: BorderRadius.only(
                            //               bottomLeft: Radius.circular(10.0),
                            //               bottomRight: Radius.circular(10.0),
                            //             ),
                            //             color: kWhiteTextColor),
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             ListView.builder(
                            //                 itemCount: categoryList.length,
                            //                 shrinkWrap: true,
                            //                 physics: const NeverScrollableScrollPhysics(),
                            //                 itemBuilder: (_, i) {
                            //                   return Container(
                            //                     padding: const EdgeInsets.all(5.0),
                            //                     decoration: BoxDecoration(
                            //                       color: selected == categoryList[i] ? kBlueTextColor.withOpacity(0.1) : null,
                            //                       shape: BoxShape.rectangle,
                            //                     ),
                            //                     child: Padding(
                            //                       padding: const EdgeInsets.all(8.0),
                            //                       child: Text(
                            //                         categoryList[i],
                            //                         style: kTextStyle.copyWith(color: kTitleColor),
                            //                       ),
                            //                     ),
                            //                   ).onTap(() {
                            //                     setState(() {
                            //                       selected = categoryList[i];
                            //                     });
                            //                   });
                            //                 })
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(width: 20.0),
                            DailyTransaction(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
