// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:salespro_admin/Screen/Widgets/TopBar/top_bar_widget.dart';
import 'package:salespro_admin/model/home_report_model.dart';
import 'package:salespro_admin/model/product_model.dart';
import '../../Provider/customer_provider.dart';
import '../../Provider/due_transaction_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/customer_model.dart';
import '../../model/due_transaction_model.dart';
import '../../model/transition_model.dart';
import '../../subscription.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/report_table_widget.dart';
import '../Widgets/top_customer_table_widget.dart';
import '../Widgets/topselling_table_widget.dart';
import '../Widgets/total_count_widget.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

class MtHomeScreen extends StatefulWidget {
  const MtHomeScreen({Key? key}) : super(key: key);

  static const String route = '/dashBoard';

  @override
  State<MtHomeScreen> createState() => _MtHomeScreenState();
}

class _MtHomeScreenState extends State<MtHomeScreen> {
  int totalStock = 0;
  double totalSalePrice = 0;
  double totalParPrice = 0;

  // List<ChartSampleData> chartData = <ChartSampleData>[
  //   ChartSampleData(x: '01', y: 43, secondSeriesYValue: 37, thirdSeriesYValue: 41),
  //   ChartSampleData(x: '02', y: 45, secondSeriesYValue: 37, thirdSeriesYValue: 45),
  //   ChartSampleData(x: '03', y: 50, secondSeriesYValue: 39, thirdSeriesYValue: 48),
  //   ChartSampleData(x: '04', y: 55, secondSeriesYValue: 43, thirdSeriesYValue: 52),
  //   ChartSampleData(x: '05', y: 63, secondSeriesYValue: 48, thirdSeriesYValue: 57),
  //   ChartSampleData(x: '06', y: 68, secondSeriesYValue: 54, thirdSeriesYValue: 61),
  //   ChartSampleData(x: '07', y: 72, secondSeriesYValue: 57, thirdSeriesYValue: 66),
  //   ChartSampleData(x: '08', y: 70, secondSeriesYValue: 57, thirdSeriesYValue: 66),
  //   ChartSampleData(x: '09', y: 66, secondSeriesYValue: 54, thirdSeriesYValue: 63),
  //   ChartSampleData(x: '10', y: 57, secondSeriesYValue: 48, thirdSeriesYValue: 55),
  //   ChartSampleData(x: '11', y: 50, secondSeriesYValue: 43, thirdSeriesYValue: 50),
  //   ChartSampleData(x: '12', y: 50, secondSeriesYValue: 43, thirdSeriesYValue: 50),
  // ];
  //
  // /// Returns the defaul spline chart.
  // SfCartesianChart _buildDefaultSplineChart() {
  //   return SfCartesianChart(
  //     plotAreaBorderWidth: 0,
  //     legend: Legend(isVisible: true),
  //     primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), labelPlacement: LabelPlacement.onTicks),
  //     primaryYAxis: NumericAxis(minimum: 00, maximum: 500, axisLine: const AxisLine(width: 0), edgeLabelPlacement: EdgeLabelPlacement.shift, labelFormat: '{value}k', majorTickLines: const MajorTickLines(size: 0)),
  //     series: _getDefaultSplineSeries(),
  //     tooltipBehavior: TooltipBehavior(enable: true),
  //   );
  // }
  //
  // /// Returns the list of chart series which need to render on the spline chart.
  // List<SplineSeries<ChartSampleData, String>> _getDefaultSplineSeries() {
  //   return <SplineSeries<ChartSampleData, String>>[
  //     SplineSeries<ChartSampleData, String>(
  //       dataSource: chartData,
  //       xValueMapper: (ChartSampleData sales, _) => sales.x as String,
  //       yValueMapper: (ChartSampleData sales, _) => sales.y,
  //       markerSettings: const MarkerSettings(isVisible: true),
  //       color: kGreenTextColor,
  //       name: 'Sales',
  //     ),
  //     SplineSeries<ChartSampleData, String>(
  //       dataSource: chartData,
  //       name: 'Collection',
  //       markerSettings: const MarkerSettings(isVisible: true),
  //       color: kRedTextColor,
  //       xValueMapper: (ChartSampleData sales, _) => sales.x as String,
  //       yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
  //     )
  //   ];
  // }

  List<String> status = [
    'This Month',
    'Last Month',
    'April',
    'March',
    'February',
  ];

  String selectedStatus = 'This Month';

  DropdownButton<String> getStatus() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in status) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedStatus,
      onChanged: (value) {
        setState(() {
          selectedStatus = value!;
        });
      },
    );
  }

  List<String> dates = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
  ];

  String selectedDate = 'January';

  DropdownButton<String> selectDate() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in dates) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedDate,
      onChanged: (value) {
        setState(() {
          selectedDate = value!;
        });
      },
    );
  }

  bool isOn = false;

  double calculateTotal(List<dynamic> purchases) {
    double totalPurchase = 0.0;
    for (var element in purchases) {
      totalPurchase += element.totalAmount!;
    }
    return totalPurchase;
  }

  double calculateTotalSale(List<SaleTransactionModel> sales) {
    double totalSale = 0.0;
    for (var element in sales) {
      totalSale += element.totalAmount!;
    }
    return totalSale;
  }

  List<HomeReport> getLastCustomerName(List<SaleTransactionModel> model) {
    List<HomeReport> customers = [];
    model.reversed.toList().forEach((element) {
      HomeReport report = HomeReport(element.customerName, element.totalAmount.toString());
      customers.add(report);
    });
    return customers;
  }

  List<HomeReport> getLastPurchaserName(List<dynamic> model) {
    List<HomeReport> customers = [];
    model.reversed.toList().forEach((element) {
      HomeReport report = HomeReport(element.customerName, element.totalAmount.toString());
      customers.add(report);
    });
    return customers;
  }

  List<HomeReport> getLastDueName(List<DueTransactionModel> model) {
    List<HomeReport> customers = [];
    model.reversed.toList().forEach((element) {
      HomeReport report = HomeReport(element.customerName, element.payDueAmount.toString());
      customers.add(report);
    });
    return customers;
  }

  List<TopSellReport> getTopSellingReport(List<ProductModel> model) {
    List<TopSellReport> products = [];
    model.reversed.toList().forEach((element) {
      TopSellReport report = TopSellReport(element.productName, element.productSalePrice, element.productCode, element.productPicture);
      products.add(report);
    });
    return products;
  }

  List<TopCustomer> getTopCustomer(List<CustomerModel> model) {
    List<TopCustomer> customers = [];
    model.reversed.toList().forEach((element) {
      TopCustomer report = TopCustomer(element.customerFullName, element.dueAmount, element.phoneNumber, element.profilePicture);
      customers.add(report);
    });
    return customers;
  }

  @override
  void initState() {
    getAllTotal();
    // getUserPermission();
    super.initState();
  }

  // getUserPermission() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   final data1 = prefs.getString('userPermission');
  //   print(json.decode(json.encode(data1)));
  //   var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(data1)));
  //   finalUserRoleModel = data;
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    printUserData();
    Subscription.getUserLimitsData(context: context, wannaShowMsg: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkWhite,
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 240,
                child: SideBarWidget(
                  index: 0,
                  isTab: false,
                ),
              ),
              SizedBox(
                width: context.width() < 1000 ? 1000 - 240 : MediaQuery.of(context).size.width - 240,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: kWhiteTextColor,
                          ),
                          child: const TopBar(isFromNoSearch: true),
                        ),
                        Consumer(
                          builder: (_, ref, watch) {
                            AsyncValue<List<SaleTransactionModel>> transactionReport = ref.watch(transitionProvider);
                            final purchaseReport = ref.watch(purchaseTransitionProvider);
                            final dueReport = ref.watch(dueTransactionProvider);
                            final customer = ref.watch(buyerCustomerProvider);
                            final product = ref.watch(productProvider);
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///___total_sale_purchase_customer___________________________________________
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            transactionReport.when(data: (saleReport) {
                                              return TotalCountWidget(
                                                title: lang.S.of(context).totalSales,
                                                icon: FeatherIcons.package,
                                                iconColor: kBlueTextColor,
                                                changes: -5,
                                                count: calculateTotalSale(saleReport).toString(),
                                              );
                                            }, error: (e, stack) {
                                              return Center(
                                                child: Text(e.toString()),
                                              );
                                            }, loading: () {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }),
                                            const SizedBox(width: 20.0),
                                            purchaseReport.when(data: (transaction) {
                                              return TotalCountWidget(
                                                title: lang.S.of(context).purchase,
                                                icon: FontAwesomeIcons.truck,
                                                iconColor: kYellowColor,
                                                changes: 4,
                                                count: calculateTotal(transaction).toString(),
                                              );
                                            }, error: (e, stack) {
                                              return Center(
                                                child: Text(e.toString()),
                                              );
                                            }, loading: () {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }),
                                            const SizedBox(width: 20.0),
                                            customer.when(data: (customers) {
                                              return CustomerCountWidget(
                                                title: lang.S.of(context).newCustomer,
                                                icon: FeatherIcons.package,
                                                iconColor: kGreenTextColor,
                                                changes: -1,
                                                count: customers.length.toString(),
                                              );
                                            }, error: (e, stack) {
                                              return Center(
                                                child: Text(e.toString()),
                                              );
                                            }, loading: () {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }),
                                            const SizedBox(width: 20.0),
                                          ],
                                        ),
                                        // const SizedBox(height: 20.0),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(right: 20.0),
                                        //   child: Container(
                                        //     padding: const EdgeInsets.all(10.0),
                                        //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                        //     child: Column(
                                        //       children: [
                                        //         Row(
                                        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        //           children: [
                                        //             const Icon(
                                        //               FontAwesomeIcons.xingSquare,
                                        //               color: kGreyTextColor,
                                        //             ),
                                        //             const SizedBox(width: 5.0),
                                        //             Text(
                                        //               'Statistics',
                                        //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //             ),
                                        //             const SizedBox(width: 20.0),
                                        //             const Icon(
                                        //               MdiIcons.circleMedium,
                                        //               color: kGreenTextColor,
                                        //             ),
                                        //             Text(
                                        //               'Sale (${currency}82,500.00)',
                                        //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //             ),
                                        //             RichText(
                                        //               text: TextSpan(text: '  Growth', style: kTextStyle.copyWith(color: kGreyTextColor), children: [
                                        //                 TextSpan(
                                        //                   text: '(67%)',
                                        //                   style: kTextStyle.copyWith(color: kGreenTextColor),
                                        //                 )
                                        //               ]),
                                        //             ),
                                        //             const SizedBox(width: 20.0),
                                        //             const Icon(
                                        //               MdiIcons.circleMedium,
                                        //               color: kRedTextColor,
                                        //             ),
                                        //             Text(
                                        //               'Expenses (${currency}82,500.00)',
                                        //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //             ),
                                        //             RichText(
                                        //               text: TextSpan(text: '  Growth', style: kTextStyle.copyWith(color: kGreyTextColor), children: [
                                        //                 TextSpan(
                                        //                   text: '(-2%)',
                                        //                   style: kTextStyle.copyWith(color: kGreenTextColor),
                                        //                 )
                                        //               ]),
                                        //             ),
                                        //             const Spacer(),
                                        //             SizedBox(
                                        //               width: 100,
                                        //               child: Container(
                                        //                 decoration: const BoxDecoration(
                                        //                   color: Colors.transparent,
                                        //                 ),
                                        //                 child: DropdownButtonHideUnderline(child: selectDate()),
                                        //               ),
                                        //             )
                                        //           ],
                                        //         ),
                                        //         const SizedBox(height: 10.0),
                                        //         _buildDefaultSplineChart()
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(height: 20.0),

                                        ///_____daily_sale_&_Collection_&_Purchase__________________________________________________________
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ///_____daily_sale_____________________________
                                            transactionReport.when(data: (dailySales) {
                                              return ReportTableWidget(
                                                report: getLastCustomerName(dailySales),
                                                title: lang.S.of(context).dailySales,
                                                color: kGreenTextColor,
                                                icon: FontAwesomeIcons.plusSquare,
                                              );
                                            }, error: (e, stack) {
                                              return Center(
                                                child: Text(e.toString()),
                                              );
                                            }, loading: () {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }),
                                            const SizedBox(width: 20.0),

                                            ///___________daily_collection_________________________________________
                                            dueReport.when(data: (dueReports) {
                                              return ReportTableWidget(
                                                report: getLastDueName(dueReports),
                                                title: lang.S.of(context).dailyCollection,
                                                color: kRedTextColor,
                                                icon: FontAwesomeIcons.plusSquare,
                                              );
                                            }, error: (e, stack) {
                                              return Center(
                                                child: Text(e.toString()),
                                              );
                                            }, loading: () {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }),
                                            const SizedBox(width: 20.0),

                                            ///_____________purchase___________________________________________________
                                            purchaseReport.when(data: (purchase) {
                                              return ReportTableWidget(
                                                report: getLastPurchaserName(purchase),
                                                title: lang.S.of(context).purchase,
                                                color: kGreenTextColor,
                                                icon: FeatherIcons.shoppingCart,
                                              );
                                            }, error: (e, stack) {
                                              return Center(
                                                child: Text(e.toString()),
                                              );
                                            }, loading: () {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }),
                                            const SizedBox(width: 20.0),
                                          ],
                                        ),
                                        const SizedBox(height: 20.0),

                                        ///___________Top_selling_product_and_CustomerOfTheMonths_________________________________________
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              product.when(data: (topSell) {
                                                return MtTopListTable(
                                                  report: getTopSellingReport(topSell),
                                                );
                                              }, error: (e, stack) {
                                                return Center(
                                                  child: Text(e.toString()),
                                                );
                                              }, loading: () {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }),
                                              const SizedBox(width: 20.0),
                                              customer.when(
                                                data: (topCustomer) {
                                                  return TopCustomerTable(
                                                    report: getTopCustomer((topCustomer)),
                                                  );
                                                },
                                                error: (e, stack) {
                                                  return Center(
                                                    child: Text(e.toString()),
                                                  );
                                                },
                                                loading: () {
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///______________stock_inventory__________________________________________________________
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              lang.S.of(context).inistantPrivacy,
                                              style: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                            trailing: Switch(
                                              activeColor: kRedTextColor.withOpacity(0.2),
                                              inactiveThumbColor: kWhiteTextColor,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  isOn = value;
                                                });
                                              },
                                              value: isOn,
                                            ),
                                          ),
                                        ).visible(false),

                                        ///___________stock_______________________________________________________
                                        product.when(data: (productLis) {
                                          return Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(FontAwesomeIcons.hospital, color: kGreyTextColor, size: 18.0),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      lang.S.of(context).stockInventory,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10.0),
                                                Row(
                                                  children: List.generate(
                                                      800 ~/ 10,
                                                      (index) => Expanded(
                                                            child: Container(
                                                              color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                                              height: 1,
                                                            ),
                                                          )),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      lang.S.of(context).stockvalue,
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '$currency$totalSalePrice',
                                                      style: kTextStyle.copyWith(color: kGreenTextColor),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10.0),
                                                Row(
                                                  children: List.generate(
                                                      800 ~/ 10,
                                                      (index) => Expanded(
                                                            child: Container(
                                                              color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                                              height: 1,
                                                            ),
                                                          )),
                                                ),
                                                const SizedBox(height: 20.0),
                                                Text(
                                                  lang.S.of(context).lowStocks,
                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 5.0),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: productLis.length,
                                                    itemBuilder: (_, i) {
                                                      return Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 180,
                                                            child: Text(
                                                              productLis[i].productName,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            productLis[i].productStock,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: kTextStyle.copyWith(color: kRedTextColor),
                                                          ),
                                                        ],
                                                      ).visible(productLis[i].productStock.toInt() < 100);
                                                    })
                                              ],
                                            ),
                                          );
                                        }, error: (e, stack) {
                                          return Center(
                                            child: Text(e.toString()),
                                          );
                                        }, loading: () {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }),

                                        const SizedBox(height: 20.0),
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(FontAwesomeIcons.hospital, color: kGreyTextColor, size: 18.0),
                                                  const SizedBox(width: 10.0),
                                                  Text(
                                                    lang.S.of(context).other,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                children: List.generate(
                                                    800 ~/ 10,
                                                    (index) => Expanded(
                                                          child: Container(
                                                            color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                                            height: 1,
                                                          ),
                                                        )),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    lang.S.of(context).otherIncome,
                                                    style: kTextStyle.copyWith(color: kTitleColor),
                                                  ),
                                                  const SizedBox(width: 70.0),
                                                  Expanded(
                                                    child: FormField(
                                                      builder: (FormFieldState<dynamic> field) {
                                                        return InputDecorator(
                                                          decoration: const InputDecoration(
                                                              border: InputBorder.none, contentPadding: EdgeInsets.zero, floatingLabelBehavior: FloatingLabelBehavior.never),
                                                          child: DropdownButtonHideUnderline(child: getStatus()),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${currency}8962468.78',
                                                style: kTextStyle.copyWith(color: kGreenTextColor),
                                              ),
                                            ],
                                          ),
                                        ).visible(false),
                                        const SizedBox(height: 20.0),
                                        // const CashBank(),
                                        // const SizedBox(height: 20.0),
                                        // Container(
                                        //   padding: const EdgeInsets.all(10.0),
                                        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                        //   child: Column(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       Row(
                                        //         children: [
                                        //           const Icon(
                                        //             Icons.style,
                                        //             color: kGreyTextColor,
                                        //             size: 18.0,
                                        //           ),
                                        //           const SizedBox(width: 10.0),
                                        //           Text('Sale', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0)),
                                        //         ],
                                        //       ),
                                        //       const SizedBox(height: 10.0),
                                        //       Row(
                                        //         children: List.generate(
                                        //             800 ~/ 10,
                                        //             (index) => Expanded(
                                        //                   child: Container(
                                        //                     color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                        //                     height: 1,
                                        //                   ),
                                        //                 )),
                                        //       ),
                                        //       const SizedBox(height: 10.0),
                                        //       Text(
                                        //         'Sale Orders',
                                        //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //       ),
                                        //       const SizedBox(height: 5.0),
                                        //       Row(
                                        //         children: [
                                        //           Text(
                                        //             'No. Of Open Orders',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //           const Spacer(),
                                        //           Text(
                                        //             '105',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //       const SizedBox(height: 5.0),
                                        //       Row(
                                        //         children: [
                                        //           Text(
                                        //             'Open Sale Orders Amount',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //           const Spacer(),
                                        //           Text(
                                        //             '${currency}31805',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //       const SizedBox(height: 10.0),
                                        //       Row(
                                        //         children: List.generate(
                                        //             800 ~/ 10,
                                        //             (index) => Expanded(
                                        //                   child: Container(
                                        //                     color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                        //                     height: 1,
                                        //                   ),
                                        //                 )),
                                        //       ),
                                        //       const SizedBox(height: 20.0),
                                        //       Text(
                                        //         'Delivery Challans',
                                        //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //       ),
                                        //       const SizedBox(height: 5.0),
                                        //       Row(
                                        //         children: [
                                        //           Text(
                                        //             'No. Of Open Challans',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //           const Spacer(),
                                        //           Text(
                                        //             '10',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //       const SizedBox(height: 5.0),
                                        //       Row(
                                        //         children: [
                                        //           Text(
                                        //             'Delivery Challan Amount',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //           const Spacer(),
                                        //           Text(
                                        //             '${currency}31805',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 20.0),
                                        // Container(
                                        //   padding: const EdgeInsets.all(10.0),
                                        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                        //   child: Column(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       Row(
                                        //         children: [
                                        //           const Icon(
                                        //             Icons.style,
                                        //             color: kGreyTextColor,
                                        //             size: 18.0,
                                        //           ),
                                        //           const SizedBox(width: 10.0),
                                        //           Text('Purchase', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0)),
                                        //         ],
                                        //       ),
                                        //       const SizedBox(height: 10.0),
                                        //       Row(
                                        //         children: List.generate(
                                        //             800 ~/ 10,
                                        //             (index) => Expanded(
                                        //                   child: Container(
                                        //                     color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                        //                     height: 1,
                                        //                   ),
                                        //                 )),
                                        //       ),
                                        //       const SizedBox(height: 10.0),
                                        //       Text(
                                        //         'Purchase Orders',
                                        //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //       ),
                                        //       const SizedBox(height: 5.0),
                                        //       Row(
                                        //         children: [
                                        //           Text(
                                        //             'No. Of Purchase Orders',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //           const Spacer(),
                                        //           Text(
                                        //             '105',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //       const SizedBox(height: 5.0),
                                        //       Row(
                                        //         children: [
                                        //           Text(
                                        //             'Purchase Orders Amount',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //           const Spacer(),
                                        //           Text(
                                        //             '${currency}31805',
                                        //             style: kTextStyle.copyWith(color: kGreyTextColor),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getAllTotal() async {
    // voidLink(context: context);
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        totalStock = totalStock + int.parse(data['productStock']);
        totalSalePrice = totalSalePrice + (int.parse(data['productSalePrice']) * int.parse(data['productStock']));
        totalParPrice = totalParPrice + (int.parse(data['productPurchasePrice']) * int.parse(data['productStock']));

        // productList.add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    setState(() {});
  }
}
