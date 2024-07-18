// ignore_for_file: use_build_context_synchronously, unused_result, non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Customer%20List/add_customer.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/POS%20Sale/show_sale_payment_popup.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';
import '../../model/category_model.dart';
import '../../model/customer_model.dart';
import '../../model/product_model.dart';
import '../../model/transition_model.dart';
import '../../subscription.dart';
import '../PDF/pdfs.dart';
import '../Product/add_product.dart';
import '../Product/product.dart';
import '../Widgets/Calculator/calculator.dart';
import '../Widgets/Pop UP/Pos Sale/due_sale_popup.dart';
import '../Widgets/Pop UP/Pos Sale/sale_list_popup.dart';

class PosSale extends StatefulWidget {
  const PosSale({Key? key}) : super(key: key);
  static const String route = '/posSale';

  @override
  State<PosSale> createState() => _PosSaleState();
}

class _PosSaleState extends State<PosSale> {
  List<AddToCartModel> cartList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // voidLink(context: context);
  }

  FocusNode serialFocus = FocusNode();

  String searchProductCode = '';

  String isSelected = 'Categories';
  String selectedCategory = 'Categories';
  String? selectedUserId = 'Guest';
  CustomerModel selectedCustomer = CustomerModel(
    customerFullName: "Guest",
    phoneNumber: "00",
    type: "Guest",
    customerAddress: '',
    emailAddress: '',
    profilePicture: '',
    openingBalance: '0',
    remainedBalance: '0',
    dueAmount: '0',
    shippingState: '',
    shippingPINCOD: '',
    shippingName: '',
    shippingLandmark: '',
    shippingAddress: '',
    gstNumber: '',
    billingZip: '',
    billingState: '',
    billingPinCod: '',
    billingCity: '',
    shippingPhoneNumber: '',
  );
  String? invoiceNumber;
  String previousDue = "0";
  FocusNode nameFocus = FocusNode();

  bool searchBySerialNumber({required List<String> serial}) {
    bool result = false;
    for (var element in serial) {
      if (element.toUpperCase().removeAllWhiteSpace().contains(searchProductCode.toUpperCase().removeAllWhiteSpace())) {
        result = true;
        break;
      }
    }
    return result;
  }

  DropdownButton<String> getResult(List<CustomerModel> model) {
    List<DropdownMenuItem<String>> dropDownItems = [const DropdownMenuItem(value: 'Guest', child: Text('Guest'))];
    for (var des in model) {
      var item = DropdownMenuItem(
        value: des.phoneNumber,
        child: Text('${des.customerFullName} ${des.phoneNumber}'),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedUserId,
      onChanged: (value) {
        setState(() {
          selectedUserId = value!;
          for (var element in model) {
            if (element.phoneNumber == selectedUserId) {
              selectedCustomer = element;
              previousDue = element.dueAmount;
              selectedCustomerType == element.type ? null : {selectedCustomerType = element.type, cartList.clear()};
            } else if (selectedUserId == 'Guest') {
              previousDue = '0';
              selectedCustomerType = 'Retailer';
            }
          }
          invoiceNumber = '';
        });
      },
    );
  }

  dynamic productPriceChecker({required ProductModel product, required String customerType}) {
    if (customerType == "Retailer") {
      return product.productSalePrice;
    } else if (customerType == "Wholesaler") {
      return product.productWholeSalePrice == '' ? '0' : product.productWholeSalePrice;
    } else if (customerType == "Dealer") {
      return product.productDealerPrice == '' ? '0' : product.productDealerPrice;
    } else if (customerType == "Guest") {
      return product.productSalePrice;
    }
  }

  String getTotalAmount() {
    double total = 0.0;
    for (var item in cartList) {
      total = total + (double.parse(item.subTotal) * item.quantity);
    }
    return total.toString();
  }

  bool uniqueCheck(String code) {
    bool isUnique = false;
    for (var item in cartList) {
      if (item.productId == code) {
        if (item.quantity < item.stock!.toInt()) {
          item.quantity += 1;
        } else {
          EasyLoading.showError('Out of Stock');
        }

        isUnique = true;
        break;
      }
    }
    return isUnique;
  }

  bool uniqueCheckForSerial({required String code, required List<dynamic> newSerialNumbers}) {
    bool isUnique = false;
    for (var item in cartList) {
      if (item.productId == code) {
        item.serialNumber = newSerialNumbers;
        item.quantity = newSerialNumbers.isEmpty ? 1 : newSerialNumbers.length;
        // item.serialNumber?.add(newSerialNumbers);

        isUnique = true;
        break;
      }
    }
    return isUnique;
  }

  List<String> customerType = [
    'Retailer',
    'Wholesaler',
    'Dealer',
  ];

  String selectedCustomerType = 'Retailer';

  DropdownButton<String> getCategories() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in customerType) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCustomerType,
      onChanged: (value) {
        setState(() {
          cartList.clear();
          selectedCustomerType = value!;
        });
      },
    );
  }

  DateTime selectedDueDate = DateTime.now();

  Future<void> _selectedDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDueDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  void showDueListPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const DueSalePopUp(),
        );
      },
    );
  }

  void showSaleListPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const SaleListPopUP());
          },
        );
      },
    );
  }

  void showHoldPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SizedBox(
                width: 500,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            lang.S.of(context).hold,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          const Spacer(),
                          const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.0, color: kLitGreyColor),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          AppTextField(
                            showCursor: true,
                            cursorColor: kTitleColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: lang.S.of(context).holdNumber,
                              hintText: '2090.00',
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: kRedTextColor,
                                  ),
                                  child: Text(
                                    lang.S.of(context).cancel,
                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                  )).onTap(() => {finish(context)}),
                              const SizedBox(width: 10.0),
                              Container(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: kBlueTextColor,
                                  ),
                                  child: Text(
                                    lang.S.of(context).submit,
                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                  )).onTap(() => {finish(context)})
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  double serviceCharge = 0;
  double discountAmount = 0;

  TextEditingController discountAmountEditingController = TextEditingController();
  TextEditingController CGSTAmountEditingController = TextEditingController();
  TextEditingController SGSTAmountEditingController = TextEditingController();
  TextEditingController IGSTAmountEditingController = TextEditingController();
  TextEditingController discountPercentageEditingController = TextEditingController();
  TextEditingController CGSTPercentageEditingController = TextEditingController();
  TextEditingController SGSTPercentageEditingController = TextEditingController();
  TextEditingController IGSTPercentageEditingController = TextEditingController();
  double vatGst = 0;
  double sgst = 0;
  double igst = 0;

  void showSerialNumberPopUp({required ProductModel productModel}) {
    AddToCartModel productInCart = AddToCartModel(productPurchasePrice: 0, serialNumber: []);
    List<dynamic> selectedSerialNumbers = [];
    List<String> list = [];
    for (var element in cartList) {
      if (element.productId == productModel.productCode) {
        productInCart = element;
        break;
      }
    }
    selectedSerialNumbers = productInCart.serialNumber ?? [];

    for (var element in productModel.serialNumber) {
      if (!selectedSerialNumbers.contains(element)) {
        list.add(element);
      }
    }
    TextEditingController editingController = TextEditingController();
    String searchWord = '';

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        serialFocus.requestFocus();
        return StatefulBuilder(
          builder: (context, setState1) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            lang.S.of(context).selectSerialNumber,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          const Spacer(),
                          const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.0, color: kLitGreyColor),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: editingController,
                            showCursor: true,
                            focus: serialFocus,
                            cursorColor: kTitleColor,
                            onChanged: (value) {
                              setState1(() {
                                searchWord = value;
                              });
                            },
                            onFieldSubmitted: (value) {
                              for (var element in list) {
                                if (value == element) {
                                  setState1(() {
                                    selectedSerialNumbers.add(element);
                                    editingController.clear();
                                    searchWord = '';
                                    list.removeWhere((element1) {
                                      return element1 == element;
                                    });
                                  });
                                  serialFocus.requestFocus();
                                  break;
                                }
                              }
                              serialFocus.requestFocus();
                            },
                            textFieldType: TextFieldType.NAME,
                            suffix: const Icon(Icons.search),
                            decoration: kInputDecoration.copyWith(
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                              labelText: lang.S.of(context).searchSerialNumber,
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(lang.S.of(context).serialNumbers),
                          const SizedBox(height: 10.0),
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: 500,
                            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState1(() {
                                          selectedSerialNumbers.add(list[index]);
                                          list.removeAt(index);
                                        });
                                      },
                                      child: Text(list[index]),
                                    ),
                                  ).visible(list[index].contains(searchWord));
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(lang.S.of(context).selectedSerialNumber),
                          const SizedBox(height: 10.0),
                          Container(
                            width: 500,
                            height: 100,
                            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: selectedSerialNumbers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (selectedSerialNumbers.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState1(() {
                                                  list.add(selectedSerialNumbers[index]);
                                                  selectedSerialNumbers.removeAt(index);
                                                });
                                              },
                                              child: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                                size: 15,
                                              )),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              '${selectedSerialNumbers[index]},',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Text(lang.S.of(context).noSerailNumberFound);
                                  }
                                },
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 7,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 1,
                                  // mainAxisExtent: 1,
                                )),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: kRedTextColor,
                                  ),
                                  child: Text(
                                    lang.S.of(context).cancel,
                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                  )).onTap(() {
                                Navigator.pop(context);
                              }),
                              const SizedBox(width: 10.0),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    AddToCartModel addToCartModel = AddToCartModel(
                                      productName: productModel.productName,
                                      nsnsac: productModel.nsnSAC,
                                      productId: productModel.productCode,
                                      productBrandName: productModel.brandName,
                                      productPurchasePrice: productModel.productPurchasePrice.toDouble(),
                                      subTotal: productPriceChecker(product: productModel, customerType: selectedCustomerType),
                                      serialNumber: selectedSerialNumbers,
                                      quantity: selectedSerialNumbers.isEmpty ? 1 : selectedSerialNumbers.length,
                                      stock: productModel.productStock.toInt(),
                                    );
                                    if (!uniqueCheckForSerial(code: productModel.productCode, newSerialNumbers: selectedSerialNumbers)) {
                                      if (int.parse(productModel.productStock) < 1) {
                                        EasyLoading.showError('Product Out Of Stock');
                                      } else {
                                        cartList.add(addToCartModel);
                                      }
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: kBlueTextColor,
                                  ),
                                  child: Text(
                                    lang.S.of(context).submit,
                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCalcPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SizedBox(
                width: 300,
                height: MediaQuery.of(context).size.height * 0.5,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CalcButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showSaleListInvoicePopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const SaleListPopUP());
          },
        );
      },
    );
  }

  TextEditingController nameCodeCategoryController = TextEditingController();

  final ScrollController mainSideScroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<String> allProductsNameList = [];
    List<String> allProductsCodeList = [];
    return Consumer(
      builder: (context, consumerRef, __) {
        final customerList = consumerRef.watch(allCustomerProvider);
        final personalData = consumerRef.watch(profileDetailsProvider);
        final productList = consumerRef.watch(productProvider);
        return personalData.when(data: (data) {
          return Scaffold(
            backgroundColor: kDarkWhite,
            body: Scrollbar(
              controller: mainSideScroller,
              child: SingleChildScrollView(
                controller: mainSideScroller,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: context.width() < 1080 ? 1080 : MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///__________first_row_______________________________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ///_________date___________________________________________________________________
                              SizedBox(
                                width: context.width() < 1080 ? 1080 * .33 : MediaQuery.of(context).size.width * .33,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          side: const BorderSide(color: kLitGreyColor),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: const BoxDecoration(),
                                          child: Center(
                                            child: Text(
                                              '${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}',
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ).onTap(() => _selectedDueDate(context)),
                                      ),
                                    ),
                                    const SizedBox(width: 15.0),

                                    ///____________previous_due_Section_______________________________________________________

                                    Text(
                                      lang.S.of(context).previousDue,
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                    ),
                                    Card(
                                      color: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: const BorderSide(color: kLitGreyColor),
                                      ),
                                      child: Container(
                                        width: context.width() < 1080 ? 1080 * .13 : MediaQuery.of(context).size.width * .13,
                                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                                        decoration: const BoxDecoration(),
                                        child: Center(
                                          child: Text(
                                            '$currency$previousDue',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              ///_________________Calculator____________________________________________________________
                              const SizedBox(width: 15.0),
                              Text(
                                'Calculator:',
                                style: kTextStyle.copyWith(color: kTitleColor),
                              ),
                              Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: kLitGreyColor),
                                  ),
                                  child: Container(
                                    width: context.width() < 1080 ? 1080 * .13 : MediaQuery.of(context).size.width * .13,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(),
                                    child: const Icon(
                                      FontAwesomeIcons.calculator,
                                      color: kTitleColor,
                                      size: 18.0,
                                    ),
                                  )).onTap(() => showCalcPopUp()),

                              ///__________dashboard___________________________________________________________________
                              const SizedBox(width: 15),
                              Expanded(
                                child: Card(
                                    color: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: const BorderSide(color: kLitGreyColor),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.speed,
                                            color: kTitleColor,
                                            size: 18.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Flexible(
                                            child: Text(
                                              lang.S.of(context).dashBoard,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).onTap(() => Navigator.of(context).pushNamed(MtHomeScreen.route)),
                              ),

                              ///___________welcome_section___________________________________________________________
                              Expanded(
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: kLitGreyColor),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          FeatherIcons.user,
                                          color: kTitleColor,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Flexible(
                                          child: Text(
                                            'Welcome ${data.companyName.toString()}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ///__________second_Row_______________________________________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///______________select_customer___________________________________
                              customerList.when(data: (allCustomers) {
                                List<String> listOfPhoneNumber = [];
                                List<CustomerModel> customersList = [];

                                for (var value1 in allCustomers) {
                                  listOfPhoneNumber.add(value1.phoneNumber.removeAllWhiteSpace().toLowerCase());
                                  if (value1.type != 'Supplier') {
                                    customersList.add(value1);
                                  }
                                }
                                return Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: kLitGreyColor),
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    width: context.width() < 1080 ? (1080 * .33) : (MediaQuery.of(context).size.width * .33),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10),
                                        SizedBox(
                                            width: context.width() < 1080 ? (1080 * .33) - 50 : (MediaQuery.of(context).size.width * .33) - 50,
                                            child: DropdownButtonHideUnderline(child: getResult(customersList))),
                                        const Spacer(),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                            color: kBlueTextColor,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              FeatherIcons.userPlus,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ).onTap(() => finalUserRoleModel.partiesPermission
                                            ? AddCustomer(
                                                typeOfCustomerAdd: 'Buyer',
                                                listOfPhoneNumber: listOfPhoneNumber,
                                                sideBarNumber: 1,
                                              ).launch(context)
                                            : EasyLoading.showError('Access Denied'))
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
                              const SizedBox(width: 15.0),

                              ///_________invoice___________________________________________
                              Text(lang.S.of(context).invoices),
                              SizedBox(
                                width: context.width() < 1080 ? 1080 * .14 : MediaQuery.of(context).size.width * .14,
                                height: 50.0,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: kLitGreyColor),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "#${data.saleInvoiceCounter.toString()}",
                                    style: const TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                              const SizedBox(width: 15.0),

                              ///__________Search_Product__________________________________________________________________
                              productList.when(data: (product) {
                                for (var element in product) {
                                  allProductsNameList.add(element.productName.removeAllWhiteSpace().toLowerCase());
                                  allProductsCodeList.add(element.productCode.removeAllWhiteSpace().toLowerCase());
                                }
                                return Expanded(
                                  child: SizedBox(
                                    height: 50.0,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: const BorderSide(color: kLitGreyColor),
                                      ),
                                      child: AppTextField(
                                        controller: nameCodeCategoryController,
                                        showCursor: true,
                                        focus: nameFocus,
                                        autoFocus: true,
                                        cursorColor: kTitleColor,
                                        onChanged: (value) {
                                          setState(() {
                                            searchProductCode = value;
                                            selectedCategory = 'Categories';
                                            isSelected = "Categories";
                                          });
                                        },
                                        // onFieldSubmitted: (value) {
                                        //   if (value != '') {
                                        //     if (product.isEmpty) {
                                        //       EasyLoading.showError('No Product Found');
                                        //     }
                                        //     for (int i = 0; i < product.length; i++) {
                                        //       if (product[i].productCode == value) {
                                        //         AddToCartModel addToCartModel = AddToCartModel(
                                        //             productName: product[i].productName,
                                        //             productId: product[i].productCode,
                                        //             nsnsac: product[i].nsnSAC,
                                        //             productBrandName: product[i].brandName,
                                        //             quantity: 1,
                                        //             stock: product[i].productStock.toInt(),
                                        //             productPurchasePrice: product[i].productPurchasePrice.toDouble(),
                                        //             subTotal: productPriceChecker(product: product[i], customerType: selectedCustomerType));
                                        //         setState(() {
                                        //           if (!uniqueCheck(product[i].productCode)) {
                                        //             cartList.add(addToCartModel);
                                        //             nameCodeCategoryController.clear();
                                        //             nameFocus.requestFocus();
                                        //             searchProductCode = '';
                                        //           } else {
                                        //             nameCodeCategoryController.clear();
                                        //             nameFocus.requestFocus();
                                        //             searchProductCode = '';
                                        //           }
                                        //         });
                                        //         break;
                                        //       }
                                        //       if (i + 1 == product.length) {
                                        //         nameCodeCategoryController.clear();
                                        //         nameFocus.requestFocus();
                                        //         EasyLoading.showError('Not found');
                                        //         setState(() {
                                        //           searchProductCode = '';
                                        //         });
                                        //       }
                                        //     }
                                        //   }
                                        // },
                                        textFieldType: TextFieldType.NAME,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(FontAwesomeIcons.barcode, color: kTitleColor, size: 18.0),
                                          suffixIcon: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                              color: kBlueTextColor,
                                            ),
                                            child: const Center(
                                              child: Icon(FeatherIcons.plusSquare, color: Colors.white, size: 18.0),
                                            ),
                                          ).onTap(() async {
                                            finalUserRoleModel.productPermission
                                                ? {
                                                    if (await Subscription.subscriptionChecker(item: Product.route))
                                                      {
                                                        AddProduct(
                                                          allProductsCodeList: allProductsCodeList,
                                                          allProductsNameList: allProductsNameList,
                                                          sideBarNumber: 1,
                                                        ).launch(context),
                                                      }
                                                    else
                                                      {
                                                        EasyLoading.showError('Update your plan first\nAdd Product limit is over.'),
                                                      }
                                                  }
                                                : EasyLoading.showError('Access denied');
                                          }),
                                          hintText: lang.S.of(context).searchSerailNumberorCategory,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                          border: InputBorder.none,
                                        ),
                                      ),
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

                              ///____________customer_type__________________________________________________________________
                              SizedBox(
                                width: context.width() < 1080 ? 120 : MediaQuery.of(context).size.width * .20,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: kLitGreyColor),
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: DropdownButtonHideUnderline(child: getCategories()),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),

                          ///_______Sale_Bord__________________________________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///___________Cart_List_Show _and buttons__________________________________
                              IntrinsicWidth(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kWhiteTextColor,
                                    border: Border.all(width: 1, color: kGreyTextColor.withOpacity(0.3)),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: context.width() < 1260 ? 630 : context.width() * 0.5,
                                        height: context.height() < 720 ? 720 - 410 : context.height() - 410,
                                        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: kGreyTextColor.withOpacity(0.3)))),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(15),
                                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: kGreyTextColor.withOpacity(0.3)))),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(width: 250, child: Text(lang.S.of(context).produactName)),
                                                    SizedBox(width: 110, child: Text(lang.S.of(context).quantity)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).price)),
                                                    SizedBox(width: 100, child: Text(lang.S.of(context).subTotal)),
                                                    SizedBox(width: 50, child: Text(lang.S.of(context).action)),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: cartList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  TextEditingController quantityController = TextEditingController(text: cartList[index].quantity.toString());
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          ///______________name__________________________________________________
                                                          Container(
                                                            width: 250,
                                                            padding: const EdgeInsets.only(left: 15),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    cartList[index].productName ?? '',
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                                // Row(
                                                                //   children: [
                                                                //     Flexible(
                                                                //       child: Text(
                                                                //         cartList[index].serialNumber!.isEmpty ? '' : 'IMEI/Serial: ${cartList[index].serialNumber}',
                                                                //         maxLines: 1,
                                                                //         style: kTextStyle.copyWith(fontSize: 12, color: kTitleColor),
                                                                //       ),
                                                                //     ),
                                                                //   ],
                                                                // )
                                                              ],
                                                            ),
                                                          ),

                                                          ///____________quantity_________________________________________________
                                                          SizedBox(
                                                            width: 110,
                                                            child: Center(
                                                              child: Row(
                                                                children: [
                                                                  const Icon(FontAwesomeIcons.solidSquareMinus, color: kBlueTextColor).onTap(() {
                                                                    setState(() {
                                                                      cartList[index].quantity > 1 ? cartList[index].quantity-- : cartList[index].quantity = 1;
                                                                    });
                                                                  }),
                                                                  Container(
                                                                    width: 60,
                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(2.0),
                                                                      color: Colors.white,
                                                                    ),
                                                                    child: TextFormField(
                                                                      controller: quantityController,
                                                                      textAlign: TextAlign.center,
                                                                      onChanged: (value) {
                                                                        if (cartList[index].stock!.toInt() < value.toInt()) {
                                                                          EasyLoading.showError('Out of Stock');
                                                                          quantityController.clear();
                                                                        } else if (value == '') {
                                                                          cartList[index].quantity = 1;
                                                                        } else if (value == '0') {
                                                                          cartList[index].quantity = 1;
                                                                        } else {
                                                                          cartList[index].quantity = value.toInt();
                                                                        }
                                                                      },
                                                                      onFieldSubmitted: (value) {
                                                                        if (value == '') {
                                                                          setState(() {
                                                                            cartList[index].quantity = 1;
                                                                          });
                                                                        } else {
                                                                          setState(() {
                                                                            cartList[index].quantity = value.toInt();
                                                                          });
                                                                        }
                                                                      },
                                                                      decoration: const InputDecoration(border: InputBorder.none),
                                                                    ),
                                                                  ),
                                                                  const Icon(FontAwesomeIcons.solidSquarePlus, color: kBlueTextColor).onTap(() {
                                                                    if (cartList[index].quantity < cartList[index].stock!.toInt()) {
                                                                      setState(() {
                                                                        cartList[index].quantity += 1;
                                                                        toast(cartList[index].quantity.toString());
                                                                      });
                                                                    } else {
                                                                      EasyLoading.showError('Out of Stock');
                                                                    }
                                                                  }),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          ///______price___________________________________________________________
                                                          SizedBox(
                                                            width: 70,
                                                            child: TextFormField(
                                                              initialValue: cartList[index].subTotal,
                                                              onChanged: (value) {
                                                                if (value == '') {
                                                                  setState(() {
                                                                    cartList[index].subTotal = 0.toString();
                                                                  });
                                                                } else if (double.tryParse(value) == null) {
                                                                  EasyLoading.showError('Enter a valid Price');
                                                                } else {
                                                                  setState(() {
                                                                    cartList[index].subTotal = value;
                                                                  });
                                                                }
                                                              },
                                                              onFieldSubmitted: (value) {
                                                                if (value == '') {
                                                                  setState(() {
                                                                    cartList[index].subTotal = 0.toString();
                                                                  });
                                                                } else if (double.tryParse(value) == null) {
                                                                  EasyLoading.showError('Enter a valid Price');
                                                                } else {
                                                                  setState(() {
                                                                    cartList[index].subTotal = value;
                                                                  });
                                                                }
                                                              },
                                                              decoration: const InputDecoration(border: InputBorder.none),
                                                            ),
                                                          ),

                                                          ///___________subtotal____________________________________________________
                                                          SizedBox(
                                                            width: 100,
                                                            child: Text(
                                                              (double.parse(cartList[index].subTotal) * cartList[index].quantity).toString(),
                                                              style: kTextStyle.copyWith(color: kTitleColor),
                                                            ),
                                                          ),

                                                          ///_______________actions_________________________________________________
                                                          SizedBox(
                                                            width: 50,
                                                            child: const Icon(
                                                              Icons.close_sharp,
                                                              color: redColor,
                                                            ).onTap(() {
                                                              setState(() {
                                                                cartList.removeAt(index);
                                                              });
                                                            }),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 1,
                                                        color: kGreyTextColor.withOpacity(0.3),
                                                      )
                                                    ],
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      ///_______price_section_____________________________________________
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            ///__________total__________________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total Item: ${cartList.length}',
                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .125 : MediaQuery.of(context).size.width * .125,
                                                  child: Text(
                                                    lang.S.of(context).subTotal,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .125 : MediaQuery.of(context).size.width * .105,
                                                  child: Container(
                                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 4.0, bottom: 4.0),
                                                    decoration: const BoxDecoration(color: kGreenTextColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                                    child: Center(
                                                      child: Text(
                                                        '$currency ${(getTotalAmount().toDouble() + serviceCharge - discountAmount + vatGst + sgst + igst).toStringAsFixed(1)}',
                                                        style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),

                                            ///__________service/shipping_____________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .158 : MediaQuery.of(context).size.width * .158,
                                                  child: Text(
                                                    lang.S.of(context).serviceorshiping,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .105 : MediaQuery.of(context).size.width * .105,
                                                  height: 40,
                                                  child: TextFormField(
                                                    initialValue: 0.toString(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        serviceCharge = value.toDouble();
                                                      });
                                                    },
                                                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter Amount'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),

                                            ///__________CGST____________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .12 : MediaQuery.of(context).size.width * .12,
                                                  child: Text(
                                                    lang.S.of(context).csgst,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: CGSTPercentageEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                vatGst = 0.0;
                                                                CGSTAmountEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                vatGst = double.parse(((value.toDouble() / 100) * getTotalAmount().toDouble()).toStringAsFixed(1));
                                                                CGSTAmountEditingController.text = vatGst.toString();
                                                              });
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: kTitleColor,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: const Text(
                                                                '%',
                                                                style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: CGSTAmountEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                vatGst = 0;
                                                                CGSTPercentageEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                vatGst = double.parse(value);
                                                                CGSTPercentageEditingController.text = ((vatGst * 100) / getTotalAmount().toDouble()).toStringAsFixed(1);
                                                              });
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: kMainColor,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: Text(
                                                                currency,
                                                                style: const TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),

                                            ///___________SGST____________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .12 : MediaQuery.of(context).size.width * .12,
                                                  child: Text(
                                                    lang.S.of(context).sgst,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: SGSTPercentageEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                sgst = 0.0;
                                                                SGSTAmountEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                sgst = double.parse(((value.toDouble() / 100) * getTotalAmount().toDouble()).toStringAsFixed(1));
                                                                SGSTAmountEditingController.text = sgst.toString();
                                                              });
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: kTitleColor,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: const Text(
                                                                '%',
                                                                style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: SGSTAmountEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                sgst = 0;
                                                                SGSTPercentageEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                sgst = double.parse(value);
                                                                SGSTPercentageEditingController.text = ((sgst * 100) / getTotalAmount().toDouble()).toStringAsFixed(1);
                                                              });
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: kMainColor,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: Text(
                                                                currency,
                                                                style: const TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),

                                            ///___________IGST___________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .12 : MediaQuery.of(context).size.width * .12,
                                                  child: Text(
                                                    lang.S.of(context).igst,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: IGSTPercentageEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                igst = 0.0;
                                                                IGSTAmountEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                igst = double.parse(((value.toDouble() / 100) * getTotalAmount().toDouble()).toStringAsFixed(1));
                                                                IGSTAmountEditingController.text = igst.toString();
                                                              });
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kTitleColor)),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: kTitleColor,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: const Text(
                                                                '%',
                                                                style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: IGSTAmountEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                igst = 0;
                                                                IGSTPercentageEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                igst = double.parse(value);
                                                                IGSTPercentageEditingController.text = ((igst * 100) / getTotalAmount().toDouble()).toStringAsFixed(1);
                                                              });
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: kMainColor,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: Text(
                                                                currency,
                                                                style: const TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),

                                            ///________discount_________________________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: context.width() < 1080 ? 1080 * .12 : MediaQuery.of(context).size.width * .12,
                                                  child: Text(
                                                    lang.S.of(context).discount,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: discountPercentageEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                discountAmountEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              if (value.toInt() <= 100) {
                                                                setState(() {
                                                                  discountAmount = double.parse(((value.toDouble() / 100) * getTotalAmount().toDouble()).toStringAsFixed(1));
                                                                  discountAmountEditingController.text = discountAmount.toString();
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  discountAmount = 0;
                                                                  discountAmountEditingController.clear();
                                                                  discountPercentageEditingController.clear();
                                                                });
                                                                EasyLoading.showError('Enter a valid Discount');
                                                              }
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: Color(0xFFff5f00),
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: const Text(
                                                                '%',
                                                                style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      height: 40.0,
                                                      child: Center(
                                                        child: AppTextField(
                                                          controller: discountAmountEditingController,
                                                          onChanged: (value) {
                                                            if (value == '') {
                                                              setState(() {
                                                                discountAmount = 0;
                                                                discountPercentageEditingController.text = 0.toString();
                                                              });
                                                            } else {
                                                              if (value.toInt() <= getTotalAmount().toDouble()) {
                                                                setState(() {
                                                                  discountAmount = double.parse(value);
                                                                  discountPercentageEditingController.text =
                                                                      ((discountAmount * 100) / getTotalAmount().toDouble()).toStringAsPrecision(1);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  discountAmount = 0;
                                                                  discountPercentageEditingController.clear();
                                                                  discountAmountEditingController.clear();
                                                                });
                                                                EasyLoading.showError('Enter a valid Discount');
                                                              }
                                                            }
                                                          },
                                                          textAlign: TextAlign.right,
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                                            hintText: '0',
                                                            border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                                            prefixIcon: Container(
                                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  color: kMainColor,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                                              child: Text(
                                                                currency,
                                                                style: const TextStyle(fontSize: 20.0, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          textFieldType: TextFieldType.PHONE,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20.0),

                                            ///____________buttons____________________________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ///________________cancel_button_____________________________________
                                                Expanded(
                                                  flex: 1,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(10.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.rectangle,
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: kRedTextColor,
                                                      ),
                                                      child: Text(
                                                        lang.S.of(context).cancel,
                                                        textAlign: TextAlign.center,
                                                        style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  flex: 1,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if (await Subscription.subscriptionChecker(item: PosSale.route)) {
                                                        if (cartList.isEmpty) {
                                                          EasyLoading.showError('Please Add Some Product first');
                                                        } else {
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
                                                                            lang.S.of(context).areYouWantToCreateThisQuantition,
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
                                                                                    color: Colors.red,
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
                                                                                },
                                                                              ),
                                                                              const SizedBox(width: 30),
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
                                                                                      lang.S.of(context).create,
                                                                                      style: const TextStyle(color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                onTap: () async {
                                                                                  SaleTransactionModel transitionModel = SaleTransactionModel(
                                                                                    customerName: selectedCustomer.customerFullName,
                                                                                    customerType: selectedCustomer.type,
                                                                                    customerPhone: selectedCustomer.phoneNumber,
                                                                                    customer: selectedCustomer,
                                                                                    invoiceNumber: data.saleInvoiceCounter.toString(),
                                                                                    purchaseDate: DateTime.now().toString(),
                                                                                    productList: cartList,
                                                                                    totalAmount: double.parse(
                                                                                      (getTotalAmount().toDouble() + serviceCharge - discountAmount + vatGst).toStringAsFixed(1),
                                                                                    ),
                                                                                    discountAmount: discountAmount,
                                                                                    serviceCharge: serviceCharge,
                                                                                    cgst: vatGst,
                                                                                    igst: igst,
                                                                                    sgst: sgst,
                                                                                  );

                                                                                  try {
                                                                                    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                                                    DatabaseReference ref = FirebaseDatabase.instance.ref("${await getUserID()}/Sales Quotation");

                                                                                    transitionModel.isPaid = false;

                                                                                    transitionModel.dueAmount = 0;
                                                                                    transitionModel.lossProfit = 0;
                                                                                    transitionModel.returnAmount = 0;
                                                                                    transitionModel.paymentType = 'Just Quotation';
                                                                                    transitionModel.sellerName = isSubUser ? constSubUserTitle : 'Admin';

                                                                                    ///_________Push_on_dataBase____________________________________________________________________________
                                                                                    await ref.push().set(transitionModel.toJson());

                                                                                    ///_________Invoice Increase____________________________________________________________________________
                                                                                    updateInvoice(
                                                                                        typeOfInvoice: 'saleInvoiceCounter', invoice: transitionModel.invoiceNumber.toInt());

                                                                                    consumerRef.refresh(profileDetailsProvider);

                                                                                    EasyLoading.showSuccess('Added Successfully');
                                                                                    await GeneratePdfAndPrint().printQuotationInvoice(
                                                                                        personalInformationModel: data, saleTransactionModel: transitionModel, context: context);
                                                                                  } catch (e) {
                                                                                    EasyLoading.dismiss();
                                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                                                  }
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
                                                        }
                                                      } else {
                                                        EasyLoading.showError('Update your plan first\nSale Limit is over.');
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(10.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.rectangle,
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: Colors.black,
                                                      ),
                                                      child: Text(
                                                        lang.S.of(context).quotation,
                                                        textAlign: TextAlign.center,
                                                        style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(2.0),
                                                      color: Colors.yellow,
                                                    ),
                                                    child: Text(
                                                      lang.S.of(context).hold,
                                                      textAlign: TextAlign.center,
                                                      style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                    ),
                                                  ).onTap(() => showHoldPopUp()),
                                                ).visible(false),

                                                ///________________payments_________________________________________
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      color: kBlueTextColor,
                                                    ),
                                                    child: Text(
                                                      lang.S.of(context).payment,
                                                      textAlign: TextAlign.center,
                                                      style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                    ),
                                                  ).onTap(
                                                    () async {
                                                      if (await Subscription.subscriptionChecker(item: PosSale.route)) {
                                                        if (cartList.isEmpty) {
                                                          EasyLoading.showError('Please Add Some Product first');
                                                        } else {
                                                          SaleTransactionModel transitionModel = SaleTransactionModel(
                                                            customer: selectedCustomer,
                                                            customerName: selectedCustomer.customerFullName,
                                                            customerType: selectedCustomer.type,
                                                            customerPhone: selectedCustomer.phoneNumber,
                                                            invoiceNumber: data.saleInvoiceCounter.toString(),
                                                            purchaseDate: DateTime.now().toString(),
                                                            productList: cartList,
                                                            totalAmount: double.parse(
                                                                (getTotalAmount().toDouble() + serviceCharge - discountAmount + vatGst + sgst + igst).toStringAsFixed(1)),
                                                            discountAmount: discountAmount,
                                                            serviceCharge: serviceCharge,
                                                            cgst: vatGst,
                                                            sgst: sgst,
                                                            igst: igst,
                                                          );

                                                          ShowPaymentPopUp(
                                                            transitionModel: transitionModel,
                                                            isFromQuotation: false,
                                                          ).launch(context);
                                                        }
                                                      } else {
                                                        EasyLoading.showError('Update your plan first\nSale Limit is over.');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),

                              ///_________selected_category______________________________
                              Consumer(
                                builder: (_, ref, watch) {
                                  AsyncValue<List<CategoryModel>> categoryList = ref.watch(categoryProvider);
                                  return categoryList.when(data: (category) {
                                    return Container(
                                      width: 150,
                                      height: context.height() < 720 ? 720 - 142 : context.height() - 142,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: kWhiteTextColor,
                                          border: Border.all(width: 1, color: kGreyTextColor.withOpacity(0.3)),
                                          borderRadius: const BorderRadius.all(Radius.circular(15))),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5.0), color: isSelected == 'Categories' ? kBlueTextColor : kBlueTextColor.withOpacity(0.1)),
                                                height: 35,
                                                width: 150,
                                                padding: const EdgeInsets.only(left: 15, right: 8),
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      lang.S.of(context).categorys,
                                                      textAlign: TextAlign.start,
                                                      style: kTextStyle.copyWith(color: isSelected == 'Categories' ? Colors.white : kDarkGreyColor, fontWeight: FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: isSelected == 'Categories' ? Colors.white : kDarkGreyColor,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory = 'Categories';
                                                  isSelected = "Categories";
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 5.0),
                                            ListView.builder(
                                              itemCount: category.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (_, i) {
                                                return GestureDetector(
                                                  onTap: (() {
                                                    setState(() {
                                                      isSelected = category[i].categoryName;
                                                      selectedCategory = category[i].categoryName;
                                                    });
                                                  }),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 15.0, right: 8.0, top: 8.0, bottom: 8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          color: isSelected == category[i].categoryName ? kBlueTextColor : kBlueTextColor.withOpacity(0.1)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            category[i].categoryName,
                                                            style: kTextStyle.copyWith(
                                                                color: isSelected == category[i].categoryName ? Colors.white : kDarkGreyColor, fontWeight: FontWeight.bold),
                                                          ),
                                                          Icon(
                                                            Icons.keyboard_arrow_right,
                                                            color: isSelected == category[i].categoryName ? Colors.white : kDarkGreyColor,
                                                            size: 16,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
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
                                  });
                                },
                              ),
                              const SizedBox(width: 10.0),

                              ///________product_List___________________________________________
                              productList.when(data: (products) {
                                List<ProductModel> showProductVsCategory = [];
                                if (selectedCategory == 'Categories') {
                                  for (var element in products) {
                                    if (searchBySerialNumber(serial: element.serialNumber) ||
                                        element.productCategory.toLowerCase().removeAllWhiteSpace().contains(searchProductCode.toLowerCase().removeAllWhiteSpace())) {
                                      productPriceChecker(product: element, customerType: selectedCustomerType) != '0' ? showProductVsCategory.add(element) : null;
                                    }
                                  }
                                } else {
                                  for (var element in products) {
                                    if (element.productCategory == selectedCategory) {
                                      productPriceChecker(product: element, customerType: selectedCustomerType) != '0' ? showProductVsCategory.add(element) : null;
                                    }
                                  }
                                }

                                return showProductVsCategory.isNotEmpty
                                    ? Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          height: context.height() < 720 ? 720 - 136 : context.height() - 136,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: kDarkWhite,
                                            ),
                                            child: GridView.builder(
                                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 180,
                                                mainAxisExtent: 200,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                              ),
                                              itemCount: showProductVsCategory.length,
                                              itemBuilder: (_, i) {
                                                return Container(
                                                  width: 130.0,
                                                  height: 170.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: kWhiteTextColor,
                                                    border: Border.all(
                                                      color: kLitGreyColor,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ///_____image_and_stock_______________________________
                                                      Stack(
                                                        alignment: Alignment.topLeft,
                                                        children: [
                                                          ///_______image______________________________________
                                                          Container(
                                                            height: 120,
                                                            decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                                              image: DecorationImage(image: NetworkImage(showProductVsCategory[i].productPicture), fit: BoxFit.cover),
                                                            ),
                                                          ),

                                                          ///_______stock_________________________
                                                          Positioned(
                                                            left: 5,
                                                            top: 5,
                                                            child: Container(
                                                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                              decoration: BoxDecoration(
                                                                  color: showProductVsCategory[i].productStock == '0' ? kRedTextColor : kBlueTextColor.withOpacity(0.8)),
                                                              child: Text(
                                                                int.parse(showProductVsCategory[i].productStock) > 0
                                                                    ? '${showProductVsCategory[i].productStock} pc'
                                                                    : 'Out of stock',
                                                                style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 10.0, left: 5, right: 3),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            ///______name_______________________________________________
                                                            Text(
                                                              showProductVsCategory[i].productName,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                            ),
                                                            const SizedBox(height: 4.0),

                                                            ///________Purchase_price______________________________________________________
                                                            Container(
                                                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                              decoration: BoxDecoration(
                                                                color: kGreenTextColor,
                                                                borderRadius: BorderRadius.circular(2.0),
                                                              ),
                                                              child: Text(
                                                                "Price: $currency${productPriceChecker(product: showProductVsCategory[i], customerType: selectedCustomerType)}",
                                                                style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold, fontSize: 14.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ).onTap(() {
                                                  if (showProductVsCategory[i].serialNumber.isNotEmpty) {
                                                    showSerialNumberPopUp(productModel: showProductVsCategory[i]);
                                                  } else {
                                                    setState(() {
                                                      AddToCartModel addToCartModel = AddToCartModel(
                                                          nsnsac: showProductVsCategory[i].nsnSAC,
                                                          productBrandName: showProductVsCategory[i].brandName,
                                                          productName: showProductVsCategory[i].productName,
                                                          productId: showProductVsCategory[i].productCode,
                                                          productPurchasePrice: showProductVsCategory[i].productPurchasePrice.toDouble(),
                                                          subTotal: productPriceChecker(product: showProductVsCategory[i], customerType: selectedCustomerType),
                                                          stock: showProductVsCategory[i].productStock.toInt(),
                                                          serialNumber: []);
                                                      if (!uniqueCheck(showProductVsCategory[i].productCode)) {
                                                        if (int.parse(showProductVsCategory[i].productStock) < 1) {
                                                          EasyLoading.showError('Product Out Of Stock');
                                                        } else {
                                                          cartList.add(addToCartModel);
                                                        }
                                                      } else {}
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        flex: 4,
                                        child: Container(
                                          height: context.height() < 720 ? 720 - 136 : context.height() - 136,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 80),
                                              const Image(
                                                image: AssetImage('images/empty_screen.png'),
                                              ),
                                              const SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (await Subscription.subscriptionChecker(item: Product.route)) {
                                                    AddProduct(
                                                      allProductsCodeList: allProductsCodeList,
                                                      allProductsNameList: allProductsNameList,
                                                      sideBarNumber: 1,
                                                    ).launch(context);
                                                  } else {
                                                    EasyLoading.showError('Update your plan first\nAdd Product limit is over.');
                                                  }
                                                },
                                                child: Container(
                                                  decoration: const BoxDecoration(color: kBlueTextColor, borderRadius: BorderRadius.all(Radius.circular(15))),
                                                  width: 200,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child: Text(
                                                        lang.S.of(context).addProduct,
                                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                      ),
                                                    ),
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }, error: (e, stack) {
          return Center(
            child: Text(e.toString()),
          );
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        });
      },
    );
  }
}
