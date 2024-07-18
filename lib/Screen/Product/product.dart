// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Product/add_product.dart';
import 'package:salespro_admin/constant.dart';
import 'package:salespro_admin/model/product_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/product_provider.dart';
import '../../subscription.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'edit_product.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  static const String route = '/product';

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  void getSearchProduct() {
    setState(() {
      searchItems;
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // voidLink(context: context);
    searchItems = '';
  }

  ///___________Delete_Product_____________________________________________________________
  void deleteProduct({required String productCode, required WidgetRef updateRef, required BuildContext context}) async {
    EasyLoading.show(status: 'Deleting..');
    String productKey = '';
    await FirebaseDatabase.instance.ref(constUserId).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == productCode) {
          productKey = element.key.toString();
        }
      }
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Products/$productKey");
    await ref.remove();
    updateRef.refresh(productProvider);
    Navigator.pop(context);
    EasyLoading.showSuccess('Done');
  }

  ScrollController mainScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<String> allProductsNameList = [];
    List<String> allProductsCodeList = [];
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Scrollbar(
        controller: mainScroll,
        child: SingleChildScrollView(
          controller: mainScroll,
          scrollDirection: Axis.horizontal,
          child: Consumer(
            builder: (_, ref, watch) {
              AsyncValue<List<ProductModel>> productList = ref.watch(productProvider);
              return productList.when(data: (product) {
                for (var element in product) {
                  allProductsNameList.add(element.productName.removeAllWhiteSpace().toLowerCase());
                  allProductsCodeList.add(element.productCode.removeAllWhiteSpace().toLowerCase());
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 240,
                      child: SideBarWidget(
                        index: 3,
                        isTab: false,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                        decoration: const BoxDecoration(color: kDarkWhite),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                color: kWhiteTextColor,
                              ),
                              child: TopBar(callback: () => getSearchProduct()),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                                    child: Column(
                                      children: [
                                        ///________title and add product_______________________________________
                                        Row(
                                          children: [
                                            Text(
                                              lang.S.of(context).productList,
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
                                                    lang.S.of(context).addProduct,
                                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                  ),
                                                ],
                                              ),
                                            ).onTap(() async {
                                              if (await Subscription.subscriptionChecker(item: Product.route)) {
                                                AddProduct(
                                                  allProductsCodeList: allProductsCodeList,
                                                  allProductsNameList: allProductsNameList,
                                                  sideBarNumber: 3,
                                                ).launch(context);
                                              } else {
                                                EasyLoading.showError('Update your plan first\nAdd Product limit is over.');
                                              }
                                            }),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),
                                        Divider(
                                          thickness: 1.0,
                                          color: kGreyTextColor.withOpacity(0.2),
                                        ),

                                        ///_______________________________________________________________________
                                        Row(
                                          children: [
                                            Text(
                                              lang.S.of(context).show,
                                              style: kTextStyle.copyWith(color: kTitleColor),
                                            ),
                                            const SizedBox(width: 5.0),
                                            SizedBox(
                                              width: 110.0,
                                              height: 40,
                                              child: FormField(
                                                builder: (FormFieldState<dynamic> field) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        borderSide: const BorderSide(color: kGreyTextColor),
                                                      ),
                                                      contentPadding: const EdgeInsets.only(left: 10.0, right: 4.0),
                                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                                    ),
                                                    child: DropdownButtonHideUnderline(child: selectItem()),
                                                  );
                                                },
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 40.0,
                                              width: 300,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: kGreyTextColor)),
                                              child: Center(
                                                child: AppTextField(
                                                  showCursor: true,
                                                  cursorColor: kTitleColor,
                                                  textFieldType: TextFieldType.NAME,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.all(10.0),
                                                    hintText: (lang.S.of(context).searchCustomer),
                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                    border: InputBorder.none,
                                                    suffixIcon: Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Container(
                                                          padding: const EdgeInsets.all(2.0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            color: kGreyTextColor.withOpacity(0.2),
                                                          ),
                                                          child: const Icon(
                                                            FeatherIcons.search,
                                                            color: kTitleColor,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ).visible(false),

                                        ///_______product_list______________________________________________________
                                        const SizedBox(height: 20.0),

                                        product.isNotEmpty
                                            ? Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(15),
                                                    decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const SizedBox(width: 50, child: Text('S.L')),
                                                        SizedBox(width: 230, child: Text(lang.S.of(context).productName)),
                                                        SizedBox(width: 150, child: Text(lang.S.of(context).category)),
                                                        SizedBox(width: 70, child: Text(lang.S.of(context).reTailer)),
                                                        SizedBox(width: 70, child: Text(lang.S.of(context).dealer)),
                                                        SizedBox(width: 70, child: Text(lang.S.of(context).wholeSalePrice)),
                                                        const SizedBox(width: 30, child: Icon(FeatherIcons.settings)),
                                                      ],
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: product.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Visibility(
                                                        visible: product[index].productName.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase()),
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
                                                                      product[index].productName,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),

                                                                  ///____________category_________________________________________________
                                                                  SizedBox(
                                                                    width: 150,
                                                                    child: Text(product[index].productCategory,
                                                                        maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                  ),

                                                                  ///______Retailer Price___________________________________________________________
                                                                  SizedBox(
                                                                    width: 70,
                                                                    child: Text(
                                                                      product[index].productSalePrice,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///___________Dealer Price____________________________________________________
                                                                  SizedBox(
                                                                    width: 70,
                                                                    child: Text(
                                                                      product[index].productDealerPrice,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///___________WholeSale____________________________________________________

                                                                  SizedBox(
                                                                    width: 70,
                                                                    child: Text(
                                                                      product[index].productWholeSalePrice,
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
                                                                                style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                              ),
                                                                            ],
                                                                          ).onTap(
                                                                            () => EditProduct(
                                                                              productModel: product[index],
                                                                              allProductsNameList: allProductsNameList,
                                                                            ).launch(context),
                                                                          ),
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
                                                                                              lang.S.of(context).areyourSureYourWantToDeleteTheProduct,
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
                                                                                                    deleteProduct(
                                                                                                        productCode: product[index].productCode, updateRef: ref, context: bc);
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
                                                    lang.S.of(context).noProductFound,
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
            },
          ),
        ),
      ),
    );
  }
}
