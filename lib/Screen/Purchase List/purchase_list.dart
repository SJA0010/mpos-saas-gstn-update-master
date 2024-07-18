import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Purchase%20List/purchase_edit.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../PDF/pdfs.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class PurchaseList extends StatefulWidget {
  const PurchaseList({Key? key}) : super(key: key);

  static const String route = '/purchaseList';

  @override
  State<PurchaseList> createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
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
              final purchaseList = ref.watch(purchaseTransitionProvider);
              final profile = ref.watch(profileDetailsProvider);
              return purchaseList.when(data: (purchase) {
                final reTransaction = purchase.reversed.toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 240,
                      child: SideBarWidget(
                        index: 1,
                        isTab: false,
                        subManu: 'Purchase List',
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
                                          lang.S.of(context).purchaseList,
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Divider(
                                      thickness: 1.0,
                                      color: kGreyTextColor.withOpacity(0.2),
                                    ),
                                    // const SizedBox(height: 20.0),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       'Show:',
                                    //       style: kTextStyle.copyWith(color: kTitleColor),
                                    //     ),
                                    //     const SizedBox(width: 5.0),
                                    //     SizedBox(
                                    //       width: 110.0,
                                    //       height: 40,
                                    //       child: FormField(
                                    //         builder: (FormFieldState<dynamic> field) {
                                    //           return InputDecorator(
                                    //             decoration: InputDecoration(
                                    //               border: OutlineInputBorder(
                                    //                 borderRadius: BorderRadius.circular(10.0),
                                    //                 borderSide: const BorderSide(color: kGreyTextColor),
                                    //               ),
                                    //               contentPadding: const EdgeInsets.only(left: 10.0, right: 4.0),
                                    //               floatingLabelBehavior: FloatingLabelBehavior.never,
                                    //             ),
                                    //             child: DropdownButtonHideUnderline(child: selectItem()),
                                    //           );
                                    //         },
                                    //       ),
                                    //     ),
                                    //     const Spacer(),
                                    //     Container(
                                    //       height: 40.0,
                                    //       width: 300,
                                    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kGreyTextColor.withOpacity(0.1))),
                                    //       child: AppTextField(
                                    //         showCursor: true,
                                    //         cursorColor: kTitleColor,
                                    //         textFieldType: TextFieldType.NAME,
                                    //         decoration: InputDecoration(
                                    //           contentPadding: const EdgeInsets.all(10.0),
                                    //           hintText: ('Search...'),
                                    //           hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                    //           border: InputBorder.none,
                                    //           suffixIcon: Padding(
                                    //             padding: const EdgeInsets.all(4.0),
                                    //             child: Container(
                                    //                 padding: const EdgeInsets.all(2.0),
                                    //                 decoration: BoxDecoration(
                                    //                   borderRadius: BorderRadius.circular(8.0),
                                    //                   color: kGreyTextColor.withOpacity(0.1),
                                    //                 ),
                                    //                 child: const Icon(
                                    //                   FeatherIcons.search,
                                    //                   color: kTitleColor,
                                    //                 )),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 20.0),
                                    // const ExportButton2(),
                                    // const SizedBox(height: 20.0),
                                    ///_______sale_List_____________________________________________________

                                    const SizedBox(height: 20.0),
                                    reTransaction.isNotEmpty
                                        ? Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(15),
                                                decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                                child: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(width: 50, child: Text('S.L')),
                                                    SizedBox(width: 75, child: Text('Date')),
                                                    SizedBox(width: 50, child: Text('Invoice')),
                                                    SizedBox(width: 180, child: Text('Party Name')),
                                                    SizedBox(width: 100, child: Text('Payment Type')),
                                                    SizedBox(width: 70, child: Text('Amount')),
                                                    SizedBox(width: 70, child: Text('Due')),
                                                    SizedBox(width: 50, child: Text('Status')),
                                                    SizedBox(width: 30, child: Icon(FeatherIcons.settings)),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: reTransaction.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Visibility(
                                                    visible: reTransaction[index].customerName.toLowerCase().contains(searchItems.toLowerCase()) ||
                                                        reTransaction[index].invoiceNumber.toLowerCase().contains(searchItems.toLowerCase()),
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

                                                              ///______________Date__________________________________________________
                                                              SizedBox(
                                                                width: 75,
                                                                child: Text(
                                                                  reTransaction[index].purchaseDate.substring(0, 10),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),

                                                              ///____________Invoice_________________________________________________
                                                              SizedBox(
                                                                width: 50,
                                                                child: Text(reTransaction[index].invoiceNumber,
                                                                    maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                              ),

                                                              ///______Party Name___________________________________________________________
                                                              SizedBox(
                                                                width: 180,
                                                                child: Text(
                                                                  reTransaction[index].customerName,
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Party Type______________________________________________

                                                              SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  reTransaction[index].paymentType.toString(),
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Amount____________________________________________________
                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  reTransaction[index].totalAmount.toString(),
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Due____________________________________________________

                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  reTransaction[index].dueAmount.toString(),
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Due____________________________________________________

                                                              SizedBox(
                                                                width: 50,
                                                                child: Text(
                                                                  reTransaction[index].isPaid! ? 'Paid' : "Due",
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
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          GeneratePdfAndPrint().printPurchaseInvoice(
                                                                              personalInformationModel: profile.value!, purchaseTransactionModel: reTransaction[index]);
                                                                          // PurchaseInvoice(
                                                                          //   isPurchase: false,
                                                                          //   personalInformationModel: profile.value!,
                                                                          //   transitionModel: reTransaction[index],
                                                                          // ).launch(context);
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            const Icon(FeatherIcons.printer, size: 18.0, color: kTitleColor),
                                                                            const SizedBox(width: 4.0),
                                                                            Text(
                                                                              lang.S.of(context).print,
                                                                              style: kTextStyle.copyWith(color: kTitleColor),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    PopupMenuItem(
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          PurchaseEdit(
                                                                            personalInformationModel: profile.value!,
                                                                            isPosScreen: false,
                                                                            purchaseTransitionModel: reTransaction[index],
                                                                            popupContext: bc,
                                                                          ).launch(context);
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                                                            const SizedBox(width: 4.0),
                                                                            Text(
                                                                              lang.S.of(context).edit,
                                                                              style: kTextStyle.copyWith(color: kTitleColor),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
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
                                                  lang.S.of(context).noPurchaseTransactionFound,
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
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
