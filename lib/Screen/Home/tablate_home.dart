import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:salespro_admin/Screen/Widgets/TopBar/top_bar_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../Provider/due_transaction_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../currency.dart';
import '../../model/customer_model.dart';
import '../../model/due_transaction_model.dart';
import '../../model/home_report_model.dart';
import '../../model/product_model.dart';
import '../../model/transition_model.dart';
import '../Widgets/Graph/sample_data.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/report_table_widget.dart';
import '../Widgets/top_customer_table_widget.dart';
import '../Widgets/topselling_table_widget.dart';
import '../Widgets/total_count_widget.dart';

class TablateHome extends StatefulWidget {
  const TablateHome({Key? key}) : super(key: key);

  static const String route = '/mdashboard';

  @override
  State<TablateHome> createState() => _TablateHomeState();
}

class _TablateHomeState extends State<TablateHome> {
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
      HomeReport report = HomeReport(element.customerFullName, element.totalAmount.toString());
      customers.add(report);
    });
    return customers;
  }

  List<TopCustomer> getTopCustomer(List<CustomerModel> model) {
    List<TopCustomer> customers = [];
    model.reversed.toList().forEach((element) {
      TopCustomer report = TopCustomer(element.customerFullName, element.dueAmount, element.phoneNumber, element.profilePicture);
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

  //Daily Sale Report Table
  List<String> dailySalesPerson = [
    'Jonathon Lee',
    'Christopher Henry',
    'Adam L. Gibson',
    'Adison Maya',
    'Morgan Jackman',
  ];
  List<String> dailySalesAmount = [
    '${currency}4726793.75',
    '${currency}582672.49',
    '${currency}3641.99',
    '${currency}87652.99',
    '${currency}5186189.29',
  ];

  // Top Selling Product
  List<String> title = [
    'Smart Watch',
    'Sylish t-shirt For Girl',
    'Men Winter Jacket',
    'Men Winter Jacket',
    'Men Winter Jacket',
  ];
  List<String> productId = [
    '#120237',
    '#120487',
    '#125087',
    '#125087',
    '#125087',
  ];
  List<String> imageList = [
    'images/watch.png',
    'images/tshirt.png',
    'images/watch.png',
    'images/tshirt.png',
    'images/watch.png',
  ];

  //Customer of the Month
  List<String> userName = [
    'Cristopher Henry',
    'Jonathon Lee',
    'Thomas Atkinson',
    'Jonathon Lee',
    'Thomas Atkinson',
  ];
  List<String> userId = [
    '#1000987',
    '#1001987',
    '#1007928',
    '#1001987',
    '#1007928',
  ];
  List<String> amount = [
    '${currency}25794',
    '${currency}24129',
    '${currency}21253',
    '${currency}24129',
    '${currency}21253',
  ];

  List<String> userProfile = [
    'images/profile1.png',
    'images/profile2.png',
    'images/profile1.png',
    'images/profile2.png',
    'images/profile1.png',
  ];

  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: '01', y: 43, secondSeriesYValue: 37, thirdSeriesYValue: 41),
    ChartSampleData(x: '04', y: 45, secondSeriesYValue: 37, thirdSeriesYValue: 45),
    ChartSampleData(x: '07', y: 50, secondSeriesYValue: 39, thirdSeriesYValue: 48),
    ChartSampleData(x: '10', y: 55, secondSeriesYValue: 43, thirdSeriesYValue: 52),
    ChartSampleData(x: '13', y: 63, secondSeriesYValue: 48, thirdSeriesYValue: 57),
    ChartSampleData(x: '16', y: 68, secondSeriesYValue: 54, thirdSeriesYValue: 61),
    ChartSampleData(x: '19', y: 72, secondSeriesYValue: 57, thirdSeriesYValue: 66),
    ChartSampleData(x: '22', y: 70, secondSeriesYValue: 57, thirdSeriesYValue: 66),
    ChartSampleData(x: '25', y: 66, secondSeriesYValue: 54, thirdSeriesYValue: 63),
    ChartSampleData(x: '28', y: 57, secondSeriesYValue: 48, thirdSeriesYValue: 55),
    ChartSampleData(x: '31', y: 50, secondSeriesYValue: 43, thirdSeriesYValue: 50),
  ];

  /// Returns the defaul spline chart.
  SfCartesianChart _buildDefaultSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: const Legend(isVisible: true),
      primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0), labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: NumericAxis(
          minimum: 00,
          maximum: 500,
          axisLine: const AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}k',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultSplineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<ChartSampleData, String>> _getDefaultSplineSeries() {
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
        color: kGreenTextColor,
        name: 'Sales',
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: chartData,
        name: 'Collection',
        markerSettings: const MarkerSettings(isVisible: true),
        color: kRedTextColor,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
      )
    ];
  }

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

  List<TopSellReport> getTopSellingReport(List<ProductModel> model) {
    List<TopSellReport> products = [];
    model.reversed.toList().forEach((element) {
      TopSellReport report = TopSellReport(element.productName, element.productSalePrice, element.productCode, element.productPicture);
      products.add(report);
    });
    return products;
  }

  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: false,
          title: Text(
            'MPOS',
            style: kTextStyle.copyWith(color: kTitleColor),
          ),
          iconTheme: const IconThemeData(color: kTitleColor),
          actions: const [
            Center(
                child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: TopBarTablate(),
            ))
          ],
        ),
        drawer: const Drawer(
          child: SideBarWidget(
            index: 0,
            isTab: true,
          ),
        ),
        body: Consumer(
          builder: (_, ref, watch) {
            AsyncValue<List<SaleTransactionModel>> transactionReport = ref.watch(transitionProvider);
            final purchaseReport = ref.watch(purchaseTransitionProvider);
            final dueReport = ref.watch(dueTransactionProvider);
            final customer = ref.watch(buyerCustomerProvider);
            final product = ref.watch(productProvider);
            return Container(
              decoration: const BoxDecoration(color: kDarkWhite),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            return TotalCountWidget(
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
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.circle_rounded,
                                  color: kGreenTextColor,
                                ),
                                Text(
                                  'Sale (${currency}70,300.00)',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 20.0),
                                const Icon(
                                  Icons.circle_rounded,
                                  color: kRedTextColor,
                                ),
                                Text(
                                  'Expenses (${currency}58,300.00)',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 20.0),
                                SizedBox(
                                  width: 120,
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    child: DropdownButtonHideUnderline(child: selectDate()),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            _buildDefaultSplineChart()
                          ],
                        ),
                      ).visible(false),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          transactionReport.when(data: (dailySales) {
                            return ReportTableWidget(
                              report: getLastCustomerName(dailySales),
                              title: lang.S.of(context).dailySales,
                              color: kGreenTextColor,
                              icon: FontAwesomeIcons.squarePlus,
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
                          dueReport.when(data: (dueReports) {
                            return ReportTableWidget(
                              report: getLastDueName(dueReports),
                              title: lang.S.of(context).dailyCollection,
                              color: kRedTextColor,
                              icon: FontAwesomeIcons.squarePlus,
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
                          purchaseReport.when(data: (purchase) {
                            return ReportTableWidget(
                              report: getLastPurchaserName(purchase),
                              title: lang.S.of(context).purchase,
                              color: kGreenTextColor,
                              icon: Icons.shopping_cart_outlined,
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
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
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
                      // Row(
                      //   children: [
                      //     MtTopListTable(
                      //       topProductList: title,
                      //       imageList: imageList,
                      //       productId: productId,
                      //     ),
                      //     const SizedBox(width: 20.0),
                      //     TopCustomerTable(userName: userName, userProfile: userProfile, userId: userId, amount: amount),
                      //     const SizedBox(width: 20.0),
                      //   ],
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(20.0),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //
                      //
                      //       // //3rd Section
                      //       // Expanded(
                      //       //   flex: 1,
                      //       //   child: Column(
                      //       //     mainAxisAlignment: MainAxisAlignment.start,
                      //       //     crossAxisAlignment: CrossAxisAlignment.start,
                      //       //     children: [
                      //       //       Card(
                      //       //         shape: RoundedRectangleBorder(
                      //       //           borderRadius: BorderRadius.circular(10),
                      //       //         ),
                      //       //         child: ListTile(
                      //       //           title: Text(
                      //       //             'Instant Privacy',
                      //       //             style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //           ),
                      //       //           trailing: Switch(
                      //       //             activeColor: kRedTextColor.withOpacity(0.2),
                      //       //             inactiveThumbColor: kWhiteTextColor,
                      //       //             onChanged: (bool value) {
                      //       //               setState(() {
                      //       //                 isOn = value;
                      //       //               });
                      //       //             },
                      //       //             value: isOn,
                      //       //           ),
                      //       //         ),
                      //       //       ),
                      //       //       const SizedBox(height: 10.0),
                      //       //       Container(
                      //       //         padding: const EdgeInsets.all(10.0),
                      //       //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                      //       //         child: Column(
                      //       //           crossAxisAlignment: CrossAxisAlignment.start,
                      //       //           children: [
                      //       //             Row(
                      //       //               children: [
                      //       //                 const Icon(MdiIcons.hospitalBuilding, color: kGreyTextColor, size: 18.0),
                      //       //                 const SizedBox(width: 10.0),
                      //       //                 Text(
                      //       //                   'Stock Inventory',
                      //       //                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Row(
                      //       //               children: List.generate(
                      //       //                   800 ~/ 10,
                      //       //                       (index) => Expanded(
                      //       //                     child: Container(
                      //       //                       color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                      //       //                       height: 1,
                      //       //                     ),
                      //       //                   )),
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'Stock Value',
                      //       //                   style: kTextStyle.copyWith(color: kTitleColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '${currency}4726793.75',
                      //       //                   style: kTextStyle.copyWith(color: kGreenTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Row(
                      //       //               children: List.generate(
                      //       //                   800 ~/ 10,
                      //       //                       (index) => Expanded(
                      //       //                     child: Container(
                      //       //                       color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                      //       //                       height: 1,
                      //       //                     ),
                      //       //                   )),
                      //       //             ),
                      //       //             const SizedBox(height: 20.0),
                      //       //             Text(
                      //       //               'Low Stocks',
                      //       //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'Smart Watch',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '55',
                      //       //                   style: kTextStyle.copyWith(color: kRedTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'Men Winter Jacket',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '195',
                      //       //                   style: kTextStyle.copyWith(color: kRedTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //           ],
                      //       //         ),
                      //       //       ),
                      //       //       const SizedBox(height: 20.0),
                      //       //       Container(
                      //       //         padding: const EdgeInsets.all(10.0),
                      //       //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                      //       //         child: Column(
                      //       //           crossAxisAlignment: CrossAxisAlignment.start,
                      //       //           children: [
                      //       //             Row(
                      //       //               children: [
                      //       //                 const Icon(MdiIcons.hospitalBuilding, color: kGreyTextColor, size: 18.0),
                      //       //                 const SizedBox(width: 10.0),
                      //       //                 Text(
                      //       //                   'Other',
                      //       //                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Row(
                      //       //               children: List.generate(
                      //       //                   800 ~/ 10,
                      //       //                       (index) => Expanded(
                      //       //                     child: Container(
                      //       //                       color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                      //       //                       height: 1,
                      //       //                     ),
                      //       //                   )),
                      //       //             ),
                      //       //             Row(
                      //       //               mainAxisAlignment: MainAxisAlignment.start,
                      //       //               mainAxisSize: MainAxisSize.min,
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'Other Income',
                      //       //                   style: kTextStyle.copyWith(color: kTitleColor),
                      //       //                 ),
                      //       //                 const SizedBox(width: 70.0),
                      //       //                 Expanded(
                      //       //                   child: FormField(
                      //       //                     builder: (FormFieldState<dynamic> field) {
                      //       //                       return InputDecorator(
                      //       //                         decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, floatingLabelBehavior: FloatingLabelBehavior.never),
                      //       //                         child: DropdownButtonHideUnderline(child: getStatus()),
                      //       //                       );
                      //       //                     },
                      //       //                   ),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             Text(
                      //       //               '${currency}5972468.78',
                      //       //               style: kTextStyle.copyWith(color: kGreenTextColor),
                      //       //             ),
                      //       //           ],
                      //       //         ),
                      //       //       ),
                      //       //       const SizedBox(height: 20.0),
                      //       //       const CashBank(),
                      //       //       const SizedBox(height: 20.0),
                      //       //       Container(
                      //       //         padding: const EdgeInsets.all(10.0),
                      //       //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                      //       //         child: Column(
                      //       //           crossAxisAlignment: CrossAxisAlignment.start,
                      //       //           children: [
                      //       //             Row(
                      //       //               children: [
                      //       //                 const Icon(
                      //       //                   Icons.style,
                      //       //                   color: kGreyTextColor,
                      //       //                   size: 18.0,
                      //       //                 ),
                      //       //                 const SizedBox(width: 10.0),
                      //       //                 Text('Sale', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0)),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Row(
                      //       //               children: List.generate(
                      //       //                   800 ~/ 10,
                      //       //                       (index) => Expanded(
                      //       //                     child: Container(
                      //       //                       color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                      //       //                       height: 1,
                      //       //                     ),
                      //       //                   )),
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Text(
                      //       //               'Sale Orders',
                      //       //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'No. Of Open Orders',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '105',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'Open Sale Orders Amount',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '${currency}31805',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Row(
                      //       //               children: List.generate(
                      //       //                   800 ~/ 10,
                      //       //                       (index) => Expanded(
                      //       //                     child: Container(
                      //       //                       color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                      //       //                       height: 1,
                      //       //                     ),
                      //       //                   )),
                      //       //             ),
                      //       //             const SizedBox(height: 20.0),
                      //       //             Text(
                      //       //               'Delivery Challans',
                      //       //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'No. Of Open Challans',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '10',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'Delivery Challan Amount',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '${currency}31805',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //           ],
                      //       //         ),
                      //       //       ),
                      //       //       const SizedBox(height: 20.0),
                      //       //       Container(
                      //       //         padding: const EdgeInsets.all(10.0),
                      //       //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                      //       //         child: Column(
                      //       //           crossAxisAlignment: CrossAxisAlignment.start,
                      //       //           children: [
                      //       //             Row(
                      //       //               children: [
                      //       //                 const Icon(
                      //       //                   Icons.style,
                      //       //                   color: kGreyTextColor,
                      //       //                   size: 18.0,
                      //       //                 ),
                      //       //                 const SizedBox(width: 10.0),
                      //       //                 Text('Purchase', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0)),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Row(
                      //       //               children: List.generate(
                      //       //                   800 ~/ 10,
                      //       //                       (index) => Expanded(
                      //       //                     child: Container(
                      //       //                       color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                      //       //                       height: 1,
                      //       //                     ),
                      //       //                   )),
                      //       //             ),
                      //       //             const SizedBox(height: 10.0),
                      //       //             Text(
                      //       //               'Purchase Orders',
                      //       //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'No. Of Purchase Orders',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '105',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //             const SizedBox(height: 5.0),
                      //       //             Row(
                      //       //               children: [
                      //       //                 Text(
                      //       //                   'Purchase Orders Amount',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //                 const Spacer(),
                      //       //                 Text(
                      //       //                   '${currency}31805',
                      //       //                   style: kTextStyle.copyWith(color: kGreyTextColor),
                      //       //                 ),
                      //       //               ],
                      //       //             ),
                      //       //           ],
                      //       //         ),
                      //       //       )
                      //       //     ],
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
