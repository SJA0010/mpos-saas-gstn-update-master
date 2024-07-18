import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../model/customer_model.dart';
import '../../model/transition_model.dart';
import '../Widgets/Constant Data/constant.dart';

class LedgerDetails extends StatefulWidget {
  const LedgerDetails({Key? key}) : super(key: key);

  @override
  State<LedgerDetails> createState() => _LedgerDetailsState();
}

class _LedgerDetailsState extends State<LedgerDetails> {
  List<String> allPartis = ['All', 'Retailer', 'Dealer', 'Wholesaler', "Supplier"];
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

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      AsyncValue<List<SaleTransactionModel>> saleTransactionReport = ref.watch(transitionProvider);
      final purchaseTransactionReport = ref.watch(purchaseTransitionProvider);

      final allCustomers = ref.watch(allCustomerProvider);

      return allCustomers.when(data: (allCustomers) {
        counter == 0 ? listOfSelectedCustomers = List.from(allCustomers) : null;
        counter++;
        return allCustomers.isNotEmpty
            ? Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///_______All_totals__________________________________________________________
                    // Container(
                    //   padding: const EdgeInsets.all(10.0),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //     color: kWhiteTextColor,
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           ///________Total Sale____________________________________________
                    //           Container(
                    //             padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10.0),
                    //               color: const Color(0xFFCFF4E3),
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   '${currency}${totalSale(allTransitions: saleTransactionReport.value!,selectedCustomerType: selectedLedgerItems)}',
                    //                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    //                 ),
                    //                 Text(
                    //                   'Total Sale',
                    //                   style: kTextStyle.copyWith(color: kTitleColor),
                    //                 ),
                    //               ],
                    //             ),
                    //           ).visible(selectedLedgerItems != 'Supplier'),
                    //           const SizedBox(width: 10.0),
                    //
                    //           ///________Total_purchase_________________________________________
                    //           Container(
                    //             padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10.0),
                    //               color: const Color(0xFF2DB0F6).withOpacity(0.5),
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   '${currency}${totalPurchase(allTransitions: purchaseTransactionReport.value!).toString()}',
                    //                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    //                 ),
                    //                 Text(
                    //                   'Total Purchase',
                    //                   style: kTextStyle.copyWith(color: kTitleColor),
                    //                 ),
                    //               ],
                    //             ),
                    //           ).visible(selectedLedgerItems == 'Supplier' || selectedLedgerItems == 'All'),
                    //           const SizedBox(width: 10.0),
                    //
                    //           ///____________Total received Amount_________________________________
                    //           Container(
                    //             padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10.0),
                    //               color: const Color(0xFF15CD75).withOpacity(0.5),
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   '${currency}${totalCustomerReceivedAmount(allTransitions: saleTransactionReport.value!,selectedCustomerType: selectedLedgerItems).toString()}',
                    //                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    //                 ),
                    //                 Text(
                    //                   'Received Amount',
                    //                   style: kTextStyle.copyWith(color: kTitleColor),
                    //                 ),
                    //               ],
                    //             ),
                    //           ).visible(selectedLedgerItems !="Supplier"),
                    //           const SizedBox(width: 10.0),
                    //
                    //           ///________total_customer_due___________________________________________________________
                    //           Container(
                    //             padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10.0),
                    //               color: const Color(0xFFFEE7CB),
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   '${currency}${totalCustomerDue(customers: allCustomers,selectedCustomerType: selectedLedgerItems).toString()}',
                    //                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    //                 ),
                    //                 Text(
                    //                   'Customer Due',
                    //                   style: kTextStyle.copyWith(color: kTitleColor),
                    //                 ),
                    //               ],
                    //             ),
                    //           ).visible(selectedLedgerItems !="Supplier"),
                    //           const SizedBox(width: 10.0),
                    //
                    //           ///________total_Supplier_due___________________________________________________________
                    //           Container(
                    //             padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10.0),
                    //               color: const Color(0xFFFEE7CB),
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   '${currency}${totalSupplierDue(customers: allCustomers).toString()}',
                    //                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    //                 ),
                    //                 Text(
                    //                   'Supplier Due',
                    //                   style: kTextStyle.copyWith(color: kTitleColor),
                    //                 ),
                    //               ],
                    //             ),
                    //           ).visible(selectedLedgerItems =="Supplier" ||selectedLedgerItems =="All"),
                    //           const SizedBox(width: 10.0),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 20.0),

                    ///____________Customers_List_Bord____________________________________________
                    Container(
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
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                      ),
                                      contentPadding: const EdgeInsets.all(8.0),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: lang.S.of(context).selectParctise,
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
                          const SizedBox(height: 10.0),
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
                                  label: SizedBox(width: 200, child: Text(lang.S.of(context).name, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold))),
                                ),
                                DataColumn(
                                  label: Text(
                                    lang.S.of(context).customerType,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    lang.S.of(context).totalAmount,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    lang.S.of(context).totalDues,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    lang.S.of(context).details,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                listOfSelectedCustomers.length,
                                (index) => DataRow(cells: [
                                  DataCell(
                                    Text((index + 1).toString()),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(listOfSelectedCustomers[index].customerFullName, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(listOfSelectedCustomers[index].type, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                          listOfSelectedCustomers[index].type == 'Supplier'
                                              ? singleSupplierTotalSaleAmount(
                                                      allTransitions: purchaseTransactionReport.value!, customerPhoneNumber: listOfSelectedCustomers[index].phoneNumber)
                                                  .toString()
                                              : singleCustomersTotalSaleAmount(
                                                      allTransitions: saleTransactionReport.value!, customerPhoneNumber: listOfSelectedCustomers[index].phoneNumber)
                                                  .toString(),
                                          style: kTextStyle.copyWith(color: kGreyTextColor)),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(listOfSelectedCustomers[index].dueAmount, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                    ),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text('Show >', style: kTextStyle.copyWith(color: kBlueTextColor)),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  lang.S.of(context).pleaseAddCusotmer,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
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
      });
    });
  }
}
