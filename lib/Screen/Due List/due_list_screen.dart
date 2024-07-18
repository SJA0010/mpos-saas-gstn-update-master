import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Widgets/no_data_found.dart';
import 'package:salespro_admin/model/customer_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../constant.dart';
import '../../subscription.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'due_pop_up.dart';

class DueList extends StatefulWidget {
  const DueList({Key? key}) : super(key: key);

  static const String route = '/Due_List';

  @override
  State<DueList> createState() => _DueListState();
}

class _DueListState extends State<DueList> {
  int selectedItem = 10;
  int itemCount = 10;
  String selectedParties = 'Customers';
  ScrollController mainScroll = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kDarkWhite,
          body: Scrollbar(
            controller: mainScroll,
            child: SingleChildScrollView(
              controller: mainScroll,
              scrollDirection: Axis.horizontal,
              child: Consumer(builder: (_, ref, watch) {
                AsyncValue<List<CustomerModel>> customers = ref.watch(allCustomerProvider);
                return customers.when(data: (allCustomerList) {
                  List<CustomerModel> customerList = [];
                  List<CustomerModel> supplierList = [];
                  for (var value1 in allCustomerList) {
                    if (value1.type != 'Supplier') {
                      customerList.add(value1);
                    } else {
                      supplierList.add(value1);
                    }
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 240,
                        child: SideBarWidget(
                          index: 6,
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
                                child: TopBar(callback: () => getSearchProduct()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            selectedParties == 'Customers' ? 'Customer List' : 'Supplier List',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: (() {
                                                  setState(() {
                                                    selectedParties = 'Customers';
                                                  });
                                                }),
                                                child: Container(
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: selectedParties == 'Customers' ? kBlueTextColor : Colors.white,
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                    border: Border.all(width: 1, color: selectedParties == 'Customers' ? kBlueTextColor : Colors.grey),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      lang.S.of(context).customer,
                                                      style: TextStyle(
                                                        color: selectedParties == 'Customers' ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: (() {
                                                  setState(() {
                                                    selectedParties = 'Suppliers';
                                                  });
                                                }),
                                                child: Container(
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: selectedParties == 'Suppliers' ? kBlueTextColor : Colors.white,
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                    border: Border.all(width: 1, color: selectedParties == 'Suppliers' ? kBlueTextColor : Colors.grey),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      lang.S.of(context).suppliers,
                                                      style: TextStyle(
                                                        color: selectedParties == 'Suppliers' ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Divider(
                                        thickness: 1.0,
                                        color: kGreyTextColor.withOpacity(0.2),
                                      ),

                                      ///__________customer_list_________________________________________________________
                                      // const SizedBox(height: 20.0),
                                      // SizedBox(
                                      //   width: double.infinity,
                                      //   child: DataTable(
                                      //     headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                                      //     showBottomBorder: false,
                                      //     dataTextStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                      //     headingTextStyle: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      //     columns: const [
                                      //       DataColumn(label: Text('S.L')),
                                      //       DataColumn(label: Text('Name')),
                                      //       DataColumn(label: Text('Party type')),
                                      //       DataColumn(label: Text('Phone')),
                                      //       DataColumn(label: Text('Email')),
                                      //       DataColumn(label: Text('Due')),
                                      //       DataColumn(label: Text('Action')),
                                      //     ],
                                      //     rows: List.generate(
                                      //       selectedParties == 'Suppliers' ? supplierList.length : customerList.length,
                                      //       (index) => DataRow(cells: [
                                      //         DataCell(Text((index + 1).toString())),
                                      //         DataCell(
                                      //           Text(
                                      //             selectedParties == 'Suppliers' ? supplierList[index].customerName : customerList[index].customerName,
                                      //             maxLines: 2,
                                      //             overflow: TextOverflow.ellipsis,
                                      //           ),
                                      //         ),
                                      //         DataCell(
                                      //           Text(selectedParties == 'Suppliers' ? supplierList[index].type : customerList[index].type),
                                      //         ),
                                      //         DataCell(
                                      //             Text(selectedParties == 'Suppliers' ? supplierList[index].phoneNumber : customerList[index].phoneNumber)),
                                      //         DataCell(Text(
                                      //           selectedParties == 'Suppliers' ? supplierList[index].emailAddress : customerList[index].emailAddress,
                                      //           maxLines: 2,
                                      //           overflow: TextOverflow.ellipsis,
                                      //         )),
                                      //         DataCell(Text(selectedParties == 'Suppliers' ? supplierList[index].dueAmount : customerList[index].dueAmount)),
                                      //         DataCell(
                                      //           GestureDetector(
                                      //             onTap: () {
                                      //               showDialog(
                                      //                 barrierDismissible: false,
                                      //                 context: context,
                                      //                 builder: (BuildContext context) {
                                      //                   return StatefulBuilder(
                                      //                     builder: (context, setStates) {
                                      //                       return Dialog(
                                      //                         shape: RoundedRectangleBorder(
                                      //                           borderRadius: BorderRadius.circular(5.0),
                                      //                         ),
                                      //                         child: ShowDuePaymentPopUp(
                                      //                           customerModel: selectedParties == 'Suppliers' ? supplierList[index] : customerList[index],
                                      //                         ),
                                      //                       );
                                      //                     },
                                      //                   );
                                      //                 },
                                      //               );
                                      //             },
                                      //             child: const Text(
                                      //               'Collect Due >',
                                      //               style: TextStyle(color: Colors.blue),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ]),
                                      //     ),
                                      //   ),
                                      // ),
                                      const SizedBox(height: 20.0),
                                      selectedParties == 'Suppliers' && supplierList.isNotEmpty || selectedParties != 'Suppliers' && customerList.isNotEmpty
                                          ? Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(15),
                                                  decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const SizedBox(width: 50, child: Text('S.L')),
                                                      SizedBox(width: 180, child: Text(lang.S.of(context).partyName)),
                                                      SizedBox(width: 75, child: Text(lang.S.of(context).partyType)),
                                                      SizedBox(width: 100, child: Text(lang.S.of(context).phone)),
                                                      SizedBox(width: 150, child: Text(lang.S.of(context).email)),
                                                      SizedBox(width: 70, child: Text(lang.S.of(context).due)),
                                                      SizedBox(width: 100, child: Text(lang.S.of(context).collectdue)),
                                                    ],
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: selectedParties == 'Suppliers' ? supplierList.length : customerList.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Visibility(
                                                      visible: selectedParties == 'Suppliers'
                                                          ? supplierList[index].customerFullName.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase())
                                                          : customerList[index].customerFullName.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase()),
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
                                                                    selectedParties == 'Suppliers' ? supplierList[index].customerFullName : customerList[index].customerFullName,
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),

                                                                ///____________type_________________________________________________
                                                                SizedBox(
                                                                  width: 75,
                                                                  child: Text(selectedParties == 'Suppliers' ? supplierList[index].type : customerList[index].type,
                                                                      maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                ),

                                                                ///______Phone___________________________________________________________
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: Text(
                                                                    selectedParties == 'Suppliers' ? supplierList[index].phoneNumber : customerList[index].phoneNumber,
                                                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                ///___________Email____________________________________________________
                                                                SizedBox(
                                                                  width: 150,
                                                                  child: Text(
                                                                    selectedParties == 'Suppliers' ? supplierList[index].emailAddress : customerList[index].emailAddress,
                                                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                ///___________Due____________________________________________________

                                                                SizedBox(
                                                                  width: 70,
                                                                  child: Text(
                                                                    selectedParties == 'Suppliers' ? supplierList[index].dueAmount : customerList[index].dueAmount,
                                                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                ///_______________actions_________________________________________________
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: GestureDetector(
                                                                    onTap: () async {
                                                                      if (await Subscription.subscriptionChecker(item: DueList.route)) {
                                                                        // ignore: use_build_context_synchronously
                                                                        showDialog(
                                                                          barrierDismissible: false,
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return StatefulBuilder(
                                                                              builder: (context, setStates) {
                                                                                return Dialog(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                                  ),
                                                                                  child: ShowDuePaymentPopUp(
                                                                                    customerModel: selectedParties == 'Suppliers' ? supplierList[index] : customerList[index],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                        );
                                                                      } else {
                                                                        EasyLoading.showError('Update your plan first,\nDue Collection limit is over.');
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      lang.S.of(context).collectdue,
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
                                          : noDataFoundImage(text: lang.S.of(context).nodueTrasactionFound),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
              }),
            ),
          )),
    );
  }
}
