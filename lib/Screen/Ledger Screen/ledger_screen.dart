import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/profile_provider.dart';
import 'package:salespro_admin/model/personal_information_model.dart';
import '../../Provider/customer_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/customer_model.dart';
import '../../model/transition_model.dart';
import '../PDF/pdfs.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../Widgets/TopBar/top_bar_widget.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({
    Key? key,
  }) : super(key: key);
  static const String route = '/ledger';

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  void getSearchProduct() {
    setState(() {
      searchItems;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // voidLink(context: context);
    searchItems = '';
  }

  double singleCustomersTotalSaleAmount({required List<SaleTransactionModel> allTransitions, required String customerPhoneNumber}) {
    double totalSale = 0;
    for (var transition in allTransitions) {
      if (transition.customerPhone == customerPhoneNumber) {
        totalSale += transition.totalAmount!.toDouble();
      }
    }
    return totalSale;
  }

  double singleSupplierTotalSaleAmount({required List<dynamic> allTransitions, required String customerPhoneNumber}) {
    double totalSale = 0;
    for (var transition in allTransitions) {
      if (transition.customerPhone == customerPhoneNumber) {
        totalSale += transition.totalAmount!.toDouble();
      }
    }
    return totalSale;
  }

  double totalSale({required List<SaleTransactionModel> allTransitions, required String selectedCustomerType}) {
    double totalSale = 0;

    if (selectedCustomerType != 'All') {
      for (var transition in allTransitions) {
        if (transition.customerType == selectedCustomerType) {
          totalSale += transition.totalAmount!.toDouble();
        }
      }
    } else {
      for (var transition in allTransitions) {
        totalSale += transition.totalAmount!.toDouble();
      }
    }

    return totalSale;
  }

  double totalPurchase({required List<dynamic> allTransitions}) {
    double totalPurchase = 0;

    for (var transition in allTransitions) {
      totalPurchase += transition.totalAmount!.toDouble();
    }
    return totalPurchase;
  }

  double totalCustomerDue({required List<CustomerModel> customers, required String selectedCustomerType}) {
    double totalDue = 0;

    if (selectedCustomerType != 'All') {
      for (var c in customers) {
        if (c.type == selectedCustomerType) {
          totalDue += double.parse(c.dueAmount);
        }
      }
    } else {
      for (var c in customers) {
        if (c.type != 'Supplier') {
          totalDue += double.parse(c.dueAmount);
        }
      }
    }
    return totalDue;
  }

  double totalSupplierDue({required List<CustomerModel> customers}) {
    double totalDue = 0;

    for (var c in customers) {
      if (c.type == 'Supplier') {
        totalDue += double.parse(c.dueAmount);
      }
    }
    return totalDue;
  }

  double totalCustomerReceivedAmount({required List<SaleTransactionModel> allTransitions, required String selectedCustomerType}) {
    double totalReceived = 0;

    if (selectedCustomerType != 'All') {
      for (var transition in allTransitions) {
        if (transition.customerType == selectedCustomerType) {
          totalReceived += transition.totalAmount!.toDouble() - transition.dueAmount!.toDouble();
        }
      }
    } else {
      for (var transition in allTransitions) {
        totalReceived += transition.totalAmount!.toDouble() - transition.dueAmount!.toDouble();
      }
    }
    return totalReceived;
  }

  List<CustomerModel> listOfSelectedCustomers = [];

  String selectedLedgerItems = 'All';
  List<String> allPartis = ['All', 'Retailer', 'Dealer', 'Wholesaler', "Supplier"];
  int counter = 0;
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
          child: Consumer(builder: (_, ref, watch) {
            AsyncValue<List<SaleTransactionModel>> saleTransactionReport = ref.watch(transitionProvider);
            final purchaseTransactionReport = ref.watch(purchaseTransitionProvider);

            final allCustomers = ref.watch(allCustomerProvider);
            final personalDetails = ref.watch(profileDetailsProvider);

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 240,
                  child: SideBarWidget(
                    index: 7,
                    isTab: false,
                  ),
                ),
                allCustomers.when(data: (allCustomers) {
                  counter == 0 ? listOfSelectedCustomers = List.from(allCustomers) : null;
                  counter++;
                  return Container(
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
                            child: TopBar(callback: () => getSearchProduct()),
                          ),

                          ///_______All_totals__________________________________________________________
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: kWhiteTextColor,
                              ),
                              child: Row(
                                children: [
                                  ///________Total Sale____________________________________________
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xFFCFF4E3),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$currency${totalSale(allTransitions: saleTransactionReport.value!, selectedCustomerType: selectedLedgerItems)}',
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                        Text(
                                          lang.S.of(context).totalSales,
                                          style: kTextStyle.copyWith(color: kTitleColor),
                                        ),
                                      ],
                                    ),
                                  ).visible(selectedLedgerItems != 'Supplier'),
                                  const SizedBox(width: 10.0),

                                  ///________Total_purchase_________________________________________
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xFF2DB0F6).withOpacity(0.5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$currency${totalPurchase(allTransitions: purchaseTransactionReport.value!).toString()}',
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                        Text(
                                          lang.S.of(context).totalPurchase,
                                          style: kTextStyle.copyWith(color: kTitleColor),
                                        ),
                                      ],
                                    ),
                                  ).visible(selectedLedgerItems == 'Supplier' || selectedLedgerItems == 'All'),
                                  const SizedBox(width: 10.0),

                                  ///____________Total received Amount_________________________________
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xFF15CD75).withOpacity(0.5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$currency${totalCustomerReceivedAmount(allTransitions: saleTransactionReport.value!, selectedCustomerType: selectedLedgerItems).toString()}',
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                        Text(
                                          lang.S.of(context).reciveAmount,
                                          style: kTextStyle.copyWith(color: kTitleColor),
                                        ),
                                      ],
                                    ),
                                  ).visible(selectedLedgerItems != "Supplier"),
                                  const SizedBox(width: 10.0),

                                  ///________total_customer_due___________________________________________________________
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xFFFEE7CB),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$currency${totalCustomerDue(customers: allCustomers, selectedCustomerType: selectedLedgerItems).toString()}',
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                        Text(
                                          lang.S.of(context).customerDue,
                                          style: kTextStyle.copyWith(color: kTitleColor),
                                        ),
                                      ],
                                    ),
                                  ).visible(selectedLedgerItems != "Supplier"),
                                  const SizedBox(width: 10.0),

                                  ///________total_Supplier_due___________________________________________________________
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xFFFEE7CB),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$currency${totalSupplierDue(customers: allCustomers).toString()}',
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                        Text(
                                          lang.S.of(context).supplierDue,
                                          style: kTextStyle.copyWith(color: kTitleColor),
                                        ),
                                      ],
                                    ),
                                  ).visible(selectedLedgerItems == "Supplier" || selectedLedgerItems == "All"),
                                  const SizedBox(width: 10.0),
                                ],
                              ),
                            ),
                          ),

                          ///____________Customers_List_Bord____________________________________________
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: kWhiteTextColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: SizedBox(
                                      width: 300,
                                      height: 40,
                                      child: FormField(
                                        builder: (FormFieldState<dynamic> field) {
                                          return InputDecorator(
                                            decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                              ),
                                              contentPadding: EdgeInsets.all(8.0),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              labelText: 'Select Parties',
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                onChanged: (String? value) {
                                                  listOfSelectedCustomers.clear();
                                                  setState(() {
                                                    selectedLedgerItems = value!;

                                                    for (var element in allCustomers) {
                                                      if (selectedLedgerItems == 'All') {
                                                        listOfSelectedCustomers.add(element);
                                                      } else {
                                                        if (element.type == selectedLedgerItems) {
                                                          listOfSelectedCustomers.add(element);
                                                        }
                                                      }
                                                    }
                                                    toast(selectedLedgerItems);
                                                  });
                                                },
                                                value: selectedLedgerItems,
                                                items: allPartis.map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  ///___________selected_customer_list__________________________________________
                                  const SizedBox(height: 15.0),
                                  listOfSelectedCustomers.isNotEmpty
                                      ? Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(width: 50, child: Text('S.L')),
                                                  SizedBox(width: 180, child: Text('Party Name')),
                                                  SizedBox(width: 75, child: Text('Party Type')),
                                                  SizedBox(width: 100, child: Text('Total Amount')),
                                                  SizedBox(width: 150, child: Text('Due Amount')),
                                                  SizedBox(width: 100, child: Text('Details >')),
                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: listOfSelectedCustomers.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Visibility(
                                                  visible: listOfSelectedCustomers[index].customerFullName.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase()),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(15),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            ///______________S.L__________________________________________________
                                                            SizedBox(
                                                              width: 50,
                                                              child: Text((index + 1).toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                            ),

                                                            ///______________name__________________________________________________
                                                            SizedBox(
                                                              width: 180,
                                                              child: Text(
                                                                listOfSelectedCustomers[index].customerFullName,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),

                                                            ///____________type_________________________________________________
                                                            SizedBox(
                                                              width: 75,
                                                              child: Text(listOfSelectedCustomers[index].type,
                                                                  maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                            ),

                                                            ///______Amount___________________________________________________________
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text(
                                                                listOfSelectedCustomers[index].type == 'Supplier'
                                                                    ? singleSupplierTotalSaleAmount(
                                                                            allTransitions: purchaseTransactionReport.value!,
                                                                            customerPhoneNumber: listOfSelectedCustomers[index].phoneNumber)
                                                                        .toString()
                                                                    : singleCustomersTotalSaleAmount(
                                                                            allTransitions: saleTransactionReport.value!,
                                                                            customerPhoneNumber: listOfSelectedCustomers[index].phoneNumber)
                                                                        .toString(),
                                                                style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),

                                                            ///___________Due____________________________________________________

                                                            SizedBox(
                                                              width: 150,
                                                              child: Text(
                                                                listOfSelectedCustomers[index].dueAmount.toString(),
                                                                // selectedParties == 'Suppliers' ? supplierList[index].dueAmount : customerList[index].dueAmount,
                                                                style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),

                                                            ///_______________actions_________________________________________________
                                                            SizedBox(
                                                              width: 100,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  ledgerDetails(
                                                                    transitionModel: saleTransactionReport.value!,
                                                                    customer: listOfSelectedCustomers[index],
                                                                    personalInformationModel: personalDetails.value!,
                                                                    saleTransactionReport: saleTransactionReport.value!,
                                                                  );
                                                                  // showDialog(
                                                                  //   barrierDismissible: false,
                                                                  //   context: context,
                                                                  //   builder: (BuildContext context) {
                                                                  //     return StatefulBuilder(
                                                                  //       builder: (context, setStates) {
                                                                  //         return Dialog(
                                                                  //           shape: RoundedRectangleBorder(
                                                                  //             borderRadius: BorderRadius.circular(5.0),
                                                                  //           ),
                                                                  //           child: ledgerDetails(
                                                                  //                         transitionModel: saleTransactionReport.value!,
                                                                  //                         customer: listOfSelectedCustomers[index],
                                                                  //                         personalInformationModel: personalDetails.value!,
                                                                  //                         saleTransactionReport: saleTransactionReport.value!,
                                                                  //                       );
                                                                  //         );
                                                                  //       },
                                                                  //     );
                                                                  //   },
                                                                  // );
                                                                },
                                                                child: Text(
                                                                  lang.S.of(context).show,
                                                                  style: const TextStyle(color: Colors.blue),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 1,
                                                        color: kGreyTextColor.withOpacity(0.2),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 20),
                                              const Image(
                                                image: AssetImage('images/empty_screen.png'),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                lang.S.of(context).noTransactionFound,
                                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
              ],
            );
          }),
        ),
      ),
    );
  }

  void ledgerDetails({
    required List<SaleTransactionModel> transitionModel,
    required CustomerModel customer,
    required PersonalInformationModel personalInformationModel,
    required List<SaleTransactionModel> saleTransactionReport,
  }) {
    double totalSale = 0;
    double totalReceive = 0;
    List<SaleTransactionModel> transitions = [];
    List<String> dayLimits = [
      'All',
      '7',
      '15',
      '30',
    ];
    String selectedDate = 'All';
    for (var element in transitionModel) {
      if (element.customerPhone == customer.phoneNumber) {
        transitions.add(element);
        totalSale += element.totalAmount!.toDouble();
        totalReceive += element.totalAmount!.toDouble() - element.dueAmount!.toDouble();
      }
    }

    bool isInTime({required int day, required String date}) {
      if (DateTime.parse(date).isAfter(DateTime.now().subtract(Duration(days: day)))) {
        return true;
      } else if (date == 'All') {
        return true;
      } else {
        return false;
      }
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 820,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Ledger Details',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              const Spacer(),
                              const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
                            ],
                          ),
                        ),
                        const Divider(thickness: 1.0, color: kLitGreyColor),

                        ///_______All_totals__________________________________________________________
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kWhiteTextColor,
                          ),
                          child: Row(
                            children: [
                              ///________Total Sale____________________________________________
                              Container(
                                padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFCFF4E3),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$currency$totalSale',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    Text(
                                      'Total Sale',
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0),

                              ///____________Total received Amount_________________________________
                              Container(
                                padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFF15CD75).withOpacity(0.5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$currency$totalReceive',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    Text(
                                      'Received Amount',
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0),

                              ///________total_customer_due___________________________________________________________
                              Container(
                                padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFFEE7CB),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$currency${customer.dueAmount}',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    Text(
                                      'Total Due',
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0),

                              ///________opening balance___________________________________________________________
                              Container(
                                padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFFEE7CB),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$currency${customer.remainedBalance}',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    Text(
                                      'Opening Balance',
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const SizedBox(width: 10.0),
                            ],
                          ),
                        ),

                        ///________date________&_____________________________________________________
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: 300,
                            height: 40,
                            child: FormField(
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                    ),
                                    contentPadding: EdgeInsets.all(8.0),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: 'Select Parties',
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      onChanged: (String? value) {
                                        transitions.clear();
                                        setState(() {
                                          selectedDate = value!;
                                          totalSale = 0;
                                          totalReceive = 0;

                                          for (var element in transitionModel) {
                                            if (element.customerPhone == customer.phoneNumber && isInTime(day: selectedDate.toInt(), date: element.purchaseDate)) {
                                              transitions.add(element);
                                              totalSale += element.totalAmount!.toDouble();
                                              totalReceive += element.totalAmount!.toDouble() - element.dueAmount!.toDouble();
                                            }
                                          }
                                        });
                                      },
                                      value: selectedDate,
                                      items: dayLimits.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Divider(thickness: 1.0, color: kLitGreyColor),
                        const SizedBox(height: 10),
                        Text('Customer Name: ${customer.customerFullName}'),
                        const SizedBox(height: 10),
                        Text('Customer Phone: ${customer.phoneNumber}'),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                            showBottomBorder: false,
                            columnSpacing: 0.0,
                            columns: [
                              DataColumn(
                                label: Text(
                                  'S.L',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text('Date', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    'Invoice',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Party Name',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                    width: 100.0,
                                    child: Text(
                                      'Payment Type',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ),
                              DataColumn(
                                label: Text('Amount', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text('Due', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text('Status', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                              ),
                              const DataColumn(
                                label: Icon(FeatherIcons.settings, color: kGreyTextColor),
                              ),
                            ],
                            rows: List.generate(
                              transitions.length,
                              (index) => DataRow(cells: [
                                DataCell(
                                  Text((index + 1).toString()),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () async {
                                        // await GeneratePdfAndPrint().printSaleInvoice(personalInformationModel: personalInformationModel, saleTransactionModel: transitions[index],context: context);
                                        // SaleInvoice(
                                        //   isPosScreen: false,
                                        //   transitionModel: transitions[index],
                                        //   personalInformationModel: personalInformationModel,
                                        // ).launch(context);
                                      },
                                      child: Text(transitions[index].purchaseDate.substring(0, 10), style: kTextStyle.copyWith(color: kGreyTextColor))),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () async {
                                        // await GeneratePdfAndPrint().printSaleInvoice(personalInformationModel: personalInformationModel, saleTransactionModel: transitions[index],context: context);
                                        // SaleInvoice(
                                        //   isPosScreen: false,
                                        //   transitionModel: transitions[index],
                                        //   personalInformationModel: personalInformationModel,
                                        // ).launch(context);
                                      },
                                      child: Text(transitions[index].invoiceNumber, style: kTextStyle.copyWith(color: kGreyTextColor))),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () async {
                                        // await GeneratePdfAndPrint().printSaleInvoice(personalInformationModel: personalInformationModel, saleTransactionModel: transitions[index],context: context);
                                        // // SaleInvoice(
                                        // //   isPosScreen: false,
                                        // //   transitionModel: transitions[index],
                                        // //   personalInformationModel: personalInformationModel,
                                        // // ).launch(context);
                                      },
                                      child: Text(transitions[index].customerName, style: kTextStyle.copyWith(color: kGreyTextColor))),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () async {
                                        // await GeneratePdfAndPrint().printSaleInvoice(personalInformationModel: personalInformationModel, saleTransactionModel: transitions[index],context: context);
                                        // SaleInvoice(
                                        //   isPosScreen: false,
                                        //   transitionModel: transitions[index],
                                        //   personalInformationModel: personalInformationModel,
                                        // ).launch(context);
                                      },
                                      child: Text(transitions[index].paymentType.toString(), style: kTextStyle.copyWith(color: kGreyTextColor))),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () async {
                                        // await GeneratePdfAndPrint().printSaleInvoice(personalInformationModel: personalInformationModel, saleTransactionModel: transitions[index],context: context);
                                        // SaleInvoice(
                                        //   isPosScreen: false,
                                        //   transitionModel: transitions[index],
                                        //   personalInformationModel: personalInformationModel,
                                        // ).launch(context);
                                      },
                                      child: Text(transitions[index].totalAmount.toString(), style: kTextStyle.copyWith(color: kGreyTextColor))),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () {
                                        // SaleInvoice(
                                        //   isPosScreen: false,
                                        //   transitionModel: transitions[index],
                                        //   personalInformationModel: personalInformationModel,
                                        // ).launch(context);
                                      },
                                      child: Text(transitions[index].dueAmount.toString(), style: kTextStyle.copyWith(color: kGreyTextColor))),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () {
                                        // SaleInvoice(
                                        //   isPosScreen: false,
                                        //   transitionModel: transitions[index],
                                        //   personalInformationModel: personalInformationModel,
                                        // ).launch(context);
                                      },
                                      child: Text(transitions[index].isPaid! ? 'Paid' : "Due", style: kTextStyle.copyWith(color: kGreyTextColor))),
                                ),
                                DataCell(
                                  PopupMenuButton(
                                    icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (BuildContext bc) => [
                                      PopupMenuItem(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await GeneratePdfAndPrint()
                                                .printSaleInvoice(personalInformationModel: personalInformationModel, saleTransactionModel: transitions[index]);
                                            // SaleInvoice(
                                            //   isPosScreen: false,
                                            //   transitionModel: transitions[index],
                                            //   personalInformationModel: personalInformationModel,
                                            // ).launch(context);
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(FeatherIcons.printer, size: 18.0, color: kTitleColor),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                'Print',
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      Navigator.pushNamed(context, '$value');
                                    },
                                  ),
                                ),
                              ]),
                            ),
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
      },
    );
  }
}
