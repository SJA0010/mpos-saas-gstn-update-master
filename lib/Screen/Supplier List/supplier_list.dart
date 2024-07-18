// ignore_for_file: unused_result, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Customer%20List/add_customer.dart';
import 'package:salespro_admin/model/customer_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../constant.dart';
import '../../subscription.dart';
import '../Customer List/edit_customer.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class SupplierList extends StatefulWidget {
  const SupplierList({Key? key}) : super(key: key);

  static const String route = '/supplier';

  @override
  State<SupplierList> createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  List<int> item = [
    10,
    20,
    30,
    50,
    80,
    100,
  ];
  int selectedItem = 10;
  int itemCount = 10;

  DropdownButton<int> selectItem() {
    List<DropdownMenuItem<int>> dropDownItems = [];
    for (int des in item) {
      var item = DropdownMenuItem(
        value: des,
        child: Text('${des.toString()} items'),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedItem,
      onChanged: (value) {
        setState(() {
          selectedItem = value!;
          itemCount = value;
        });
      },
    );
  }

  void deleteCustomer({required String phoneNumber, required WidgetRef updateRef, required BuildContext context}) async {
    EasyLoading.show(status: 'Deleting..');
    String customerKey = '';
    await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'].toString() == phoneNumber) {
          customerKey = element.key.toString();
        }
      }
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Customers/$customerKey");
    await ref.remove();
    updateRef.refresh(allCustomerProvider);
    Navigator.pop(context);

    EasyLoading.showSuccess('Done');
  }

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
              AsyncValue<List<CustomerModel>> allCustomers = ref.watch(allCustomerProvider);
              return allCustomers.when(data: (allCustomers) {
                List<String> listOfPhoneNumber = [];
                List<CustomerModel> supplierList = [];

                for (var value1 in allCustomers) {
                  listOfPhoneNumber.add(value1.phoneNumber.removeAllWhiteSpace().toLowerCase());
                  if (value1.type == 'Supplier') {
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
                        index: 4,
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
                                          lang.S.of(context).suplaierList,
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                          child: Row(
                                            children: [
                                              const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 18.0),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                lang.S.of(context).addSupplaier,
                                                style: kTextStyle.copyWith(color: kWhiteTextColor),
                                              ),
                                            ],
                                          ),
                                        ).onTap(() async {
                                          if (await Subscription.subscriptionChecker(item: SupplierList.route)) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AddCustomer(
                                                    typeOfCustomerAdd: 'Supplier',
                                                    listOfPhoneNumber: listOfPhoneNumber,
                                                    sideBarNumber: 4,
                                                  );
                                                });
                                          } else {
                                            EasyLoading.showError('Update your plan first\nAdd Supplier limit is over.');
                                          }
                                        }),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Divider(
                                      thickness: 1.0,
                                      color: kGreyTextColor.withOpacity(0.2),
                                    ),
                                    const SizedBox(height: 20.0),

                                    ///__________list_______________________________________________________________________

                                    const SizedBox(height: 20.0),
                                    supplierList.isNotEmpty
                                        ? Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(15),
                                                decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const SizedBox(width: 50, child: Text('S.L')),
                                                    SizedBox(width: 230, child: Text(lang.S.of(context).partyName)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).partyType)),
                                                    SizedBox(width: 100, child: Text(lang.S.of(context).phone)),
                                                    SizedBox(width: 150, child: Text(lang.S.of(context).email)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).due)),
                                                    const SizedBox(width: 30, child: Icon(FeatherIcons.settings)),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: supplierList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Visibility(
                                                    visible: supplierList[index].customerFullName.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase()),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(15.0),
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
                                                                width: 230,
                                                                child: Text(
                                                                  supplierList[index].customerFullName,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),

                                                              ///____________type_________________________________________________
                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(supplierList[index].type,
                                                                    maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                              ),

                                                              ///______Phone___________________________________________________________
                                                              SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  supplierList[index].phoneNumber,
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Email____________________________________________________
                                                              SizedBox(
                                                                width: 150,
                                                                child: Text(
                                                                  supplierList[index].emailAddress,
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Due____________________________________________________

                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  supplierList[index].dueAmount,
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///_______________actions_________________________________________________
                                                              SizedBox(
                                                                width: 30,
                                                                child: PopupMenuButton(
                                                                  padding: EdgeInsets.zero,
                                                                  itemBuilder: (BuildContext bc) => [
                                                                    PopupMenuItem(
                                                                      child: Row(
                                                                        children: [
                                                                          const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                                                          const SizedBox(width: 4.0),
                                                                          Text(
                                                                            lang.S.of(context).edit,
                                                                            style: kTextStyle.copyWith(color: kTitleColor),
                                                                          ),
                                                                        ],
                                                                      ).onTap(() {
                                                                        showDialog(
                                                                            barrierDismissible: false,
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return EditCustomer(
                                                                                allPreviousCustomer: allCustomers,
                                                                                customerModel: supplierList[index],
                                                                                typeOfCustomerAdd: 'Supplier',
                                                                                popupContext: bc,
                                                                              );
                                                                            });
                                                                      }),
                                                                    ),
                                                                    PopupMenuItem(
                                                                      value: 'delete',
                                                                      child: Row(
                                                                        children: [
                                                                          const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                                                          const SizedBox(width: 4.0),
                                                                          Text(
                                                                            lang.S.of(context).delete,
                                                                            style: kTextStyle.copyWith(color: kTitleColor),
                                                                          ),
                                                                        ],
                                                                      ).onTap(() {
                                                                        if (double.parse(supplierList[index].dueAmount.toString()) == 0) {
                                                                          showDialog(
                                                                              barrierDismissible: false,
                                                                              context: context,
                                                                              builder: (BuildContext dialogContext) {
                                                                                return Center(
                                                                                  child: Container(
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(15),
                                                                                      ),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(20.0),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Text(
                                                                                            lang.S.of(context).areYouWantTodeletethisCusotmer,
                                                                                            style: const TextStyle(fontSize: 22),
                                                                                          ),
                                                                                          const SizedBox(height: 30),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              GestureDetector(
                                                                                                child: Container(
                                                                                                  width: 130,
                                                                                                  height: 50,
                                                                                                  decoration: const BoxDecoration(
                                                                                                    color: Colors.green,
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                      Radius.circular(15),
                                                                                                    ),
                                                                                                  ),
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      lang.S.of(context).cancel,
                                                                                                      style: const TextStyle(color: Colors.white),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  Navigator.pop(dialogContext);
                                                                                                  Navigator.pop(bc);
                                                                                                },
                                                                                              ),
                                                                                              const SizedBox(width: 30),
                                                                                              GestureDetector(
                                                                                                child: Container(
                                                                                                  width: 130,
                                                                                                  height: 50,
                                                                                                  decoration: const BoxDecoration(
                                                                                                    color: Colors.red,
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                      Radius.circular(15),
                                                                                                    ),
                                                                                                  ),
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      lang.S.of(context).delete,
                                                                                                      style: const TextStyle(color: Colors.white),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  deleteCustomer(
                                                                                                      phoneNumber: supplierList[index].phoneNumber, updateRef: ref, context: bc);
                                                                                                  Navigator.pop(dialogContext);
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        } else {
                                                                          EasyLoading.showError('This customer have previous due');
                                                                          Navigator.pop(bc);
                                                                        }
                                                                      }),
                                                                    )
                                                                  ],
                                                                  onSelected: (value) {
                                                                    Navigator.pushNamed(context, '$value');
                                                                  },
                                                                  child: Center(
                                                                    child: Container(
                                                                        height: 18,
                                                                        width: 18,
                                                                        alignment: Alignment.centerRight,
                                                                        child: const Icon(
                                                                          Icons.more_vert_sharp,
                                                                          size: 18,
                                                                        )),
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
                                              )
                                            ],
                                          )
                                        : const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 20),
                                              Image(
                                                image: AssetImage('images/empty_screen.png'),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'No Supplier Found',
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
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
        ),
      ),
    );
  }
}
