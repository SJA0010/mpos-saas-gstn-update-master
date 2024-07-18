import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Customer%20List/edit_customer.dart';
import 'package:salespro_admin/Screen/Supplier%20List/supplier_list.dart';
import 'package:salespro_admin/model/customer_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../constant.dart';
import '../../subscription.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'add_customer.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  static const String route = '/customerList';

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  int selectedItem = 10;
  int itemCount = 10;

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
    // ignore: unused_result
    updateRef.refresh(allCustomerProvider);
    // ignore: use_build_context_synchronously
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
                AsyncValue<List<CustomerModel>> customers = ref.watch(allCustomerProvider);
                return customers.when(data: (allCustomerList) {
                  List<String> listOfPhoneNumber = [];
                  List<CustomerModel> customerList = [];
                  for (var value1 in allCustomerList) {
                    listOfPhoneNumber.add(value1.phoneNumber.removeAllWhiteSpace().toLowerCase());
                    if (value1.type != 'Supplier') {
                      customerList.add(value1);
                    }
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 240,
                        child: SideBarWidget(
                          index: 5,
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
                                            lang.S.of(context).customerList,
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
                                                  lang.S.of(context).addCustomer,
                                                  style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                ),
                                              ],
                                            ),
                                          ).onTap(() async {
                                            if (await Subscription.subscriptionChecker(item: SupplierList.route)) {
                                              // ignore: use_build_context_synchronously
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AddCustomer(
                                                      typeOfCustomerAdd: 'Buyer',
                                                      listOfPhoneNumber: listOfPhoneNumber,
                                                      sideBarNumber: 5,
                                                    );
                                                  });
                                            } else {
                                              EasyLoading.showError('Update your plan first\nAdd Customer limit is over.');
                                            }
                                          })
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Divider(
                                        thickness: 1.0,
                                        color: kGreyTextColor.withOpacity(0.2),
                                      ),

                                      ///__________Customer_List________________________________________________

                                      const SizedBox(height: 20.0),
                                      customerList.isNotEmpty
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
                                                      SizedBox(width: 75, child: Text(lang.S.of(context).partyType)),
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
                                                  itemCount: customerList.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Visibility(
                                                      visible: customerList[index].customerFullName.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase()),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 5),
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
                                                                      customerList[index].customerFullName,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),

                                                                  ///____________type_________________________________________________
                                                                  SizedBox(
                                                                    width: 75,
                                                                    child: Text(
                                                                      customerList[index].type,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    ),
                                                                  ),

                                                                  ///______Phone___________________________________________________________
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Text(
                                                                      customerList[index].phoneNumber,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///___________Email____________________________________________________
                                                                  SizedBox(
                                                                    width: 150,
                                                                    child: Text(
                                                                      customerList[index].emailAddress,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///___________Due____________________________________________________

                                                                  SizedBox(
                                                                    width: 70,
                                                                    child: Text(
                                                                      customerList[index].dueAmount,
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
                                                                        ///____________Edit____________________________________________________
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
                                                                                    allPreviousCustomer: allCustomerList,
                                                                                    customerModel: customerList[index],
                                                                                    typeOfCustomerAdd: 'Buyer',
                                                                                    popupContext: bc,
                                                                                  );
                                                                                });
                                                                          }),
                                                                        ),

                                                                        ///____________delete___________________________________________________
                                                                        PopupMenuItem(
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
                                                                            if (double.parse(customerList[index].dueAmount.toString()) == 0) {
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
                                                                                              const Text(
                                                                                                'Are you want to delete this Customer?',
                                                                                                style: TextStyle(fontSize: 22),
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
                                                                                                          phoneNumber: customerList[index].phoneNumber,
                                                                                                          updateRef: ref,
                                                                                                          context: bc);
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
                                                                        ),
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
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 20),
                                                const Image(
                                                  image: AssetImage('images/empty_screen.png'),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  lang.S.of(context).noCustomerFound,
                                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                ),
                                                const SizedBox(height: 20),
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
          )),
    );
  }
}
