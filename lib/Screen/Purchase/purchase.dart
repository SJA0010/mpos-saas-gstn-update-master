// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Customer%20List/add_customer.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:salespro_admin/model/product_model.dart';

import '../../Provider/customer_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/category_model.dart';
import '../../model/customer_model.dart';
import '../../model/transition_model.dart';
import '../../subscription.dart';
import '../Product/add_product.dart';
import '../Product/product.dart';
import '../Widgets/Calculator/calculator.dart';
import '../Widgets/Pop UP/Purchase/purchase_due_sale_popup.dart';
import '../Widgets/Pop UP/Purchase/purchase_payment_popup.dart';
import '../Widgets/Pop UP/Purchase/purchase_sale_list_popup.dart';
import '../Widgets/Pop UP/Purchase/purchase_show_add_item_popup.dart';

class Purchase extends StatefulWidget {
  const Purchase({Key? key}) : super(key: key);

  static const String route = '/purchase';

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  bool uniqueCheck(String code) {
    bool isUnique = false;
    for (var item in cartList) {
      if (item.productCode == code) {
        item.productStock = (item.productStock.toInt() + 1).toString();
        isUnique = true;
        break;
      }
    }
    return isUnique;
  }

  String getTotalAmount() {
    double total = 0.0;
    for (var item in cartList) {
      total = total + (double.parse(item.productPurchasePrice) * item.productStock.toInt());
    }
    return total.toString();
  }

  List<ProductModel> cartList = [];

  bool isChecked = true;
  String isSelected = 'Categories';
  String selectedUser = 'Name  Phone  Due';
  String searchProductCode = '';
  String selectedCategory = 'Categories';

  List<String> categories = [
    'Purchase Price',
  ];

  String selectedCategories = 'Purchase Price';

  DropdownButton<String> getCategories() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in categories) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCategories,
      onChanged: (value) {
        setState(() {
          selectedCategories = value!;
        });
      },
    );
  }

//Create Customer
  List<CustomerModel> customerLists = [];
  String? selectedUserId = 'Guest';
  String? invoiceNumber;
  String previousDue = "0";
  CustomerModel selectedUserName = CustomerModel(
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
            if (selectedUserId == 'Guest') {
              previousDue = '0';
              selectedUserName = CustomerModel(
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
            } else if (element.phoneNumber == selectedUserId) {
              selectedUserName = element;
              previousDue = element.dueAmount;
            }
          }
          invoiceNumber = '';
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

  DateTime selectedSaleDate = DateTime.now();

  DateTime selectedBirthDate = DateTime.now();

  String selectedCategoryList = 'Accessories';

// Import Image
  File? image;

  Future pickImage(ImageSource gallery) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Field to pick image: $e');
      }
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
          child: const PurchaseDueSalePopUp(),
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
                child: const PurchaseSaleListPopUp());
          },
        );
      },
    );
  }

  void productEditPopUp({required ProductModel product, required int index}) {
    FocusNode serialFocus = FocusNode();
    String editedPurchasePrice = '';
    String editedSalePrice = '';
    String editDealerPrice = '';
    String editWholesalerPrice = '';
    List<String> serialNumberList = product.serialNumber;
    TextEditingController serialController = TextEditingController();
    GlobalKey<FormState> priceKey = GlobalKey<FormState>();
    bool validateAndSave() {
      final form = priceKey.currentState;
      if (form!.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    bool isWantToAddSerial = serialNumberList.isNotEmpty ? true : false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState1) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SizedBox(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
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
                                "${product.productName} (${product.productStock})",
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              const Spacer(),
                              const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
                            ],
                          ),
                        ),
                        const Divider(thickness: 1.0, color: kLitGreyColor),
                        const SizedBox(height: 10.0),
                        Form(
                          key: priceKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmptyOrNull) {
                                          return 'Please enter Purchase Price';
                                        } else if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                          return 'Enter Price in number.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      initialValue: product.productPurchasePrice,
                                      showCursor: true,
                                      cursorColor: kTitleColor,
                                      onSaved: (value) {
                                        editedPurchasePrice = value!;
                                      },
                                      decoration: kInputDecoration.copyWith(
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                        labelText: lang.S.of(context).purchasePrice,
                                        hintText: lang.S.of(context).enterPurchasePrice,
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmptyOrNull) {
                                          return 'Please enter Sale Price';
                                        } else if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                          return 'Enter Price in number.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      initialValue: product.productSalePrice,
                                      showCursor: true,
                                      cursorColor: kTitleColor,
                                      onSaved: (value) {
                                        editedSalePrice = value!;
                                      },
                                      decoration: kInputDecoration.copyWith(
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                        labelText: lang.S.of(context).salePrice,
                                        hintText: lang.S.of(context).enterSalePrice,
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        return null;
                                      },
                                      initialValue: product.productDealerPrice,
                                      showCursor: true,
                                      cursorColor: kTitleColor,
                                      onSaved: (value) {
                                        editDealerPrice = value!;
                                      },
                                      decoration: kInputDecoration.copyWith(
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                        labelText: lang.S.of(context).dealerPice,
                                        hintText: lang.S.of(context).enterDealerPrice,
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        return null;
                                      },
                                      initialValue: product.productWholeSalePrice,
                                      showCursor: true,
                                      cursorColor: kTitleColor,
                                      onSaved: (value) {
                                        editWholesalerPrice = value!;
                                      },
                                      decoration: kInputDecoration.copyWith(
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                        labelText: lang.S.of(context).wholeSalePrice,
                                        hintText: lang.S.of(context).enterWholeSalePrice,
                                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(lang.S.of(context).addingSerialNumber),
                              const SizedBox(width: 10),
                              CupertinoSwitch(
                                  value: isWantToAddSerial,
                                  onChanged: (value) {
                                    setState1(() {
                                      isWantToAddSerial = value;
                                    });
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                controller: serialController,
                                focus: serialFocus,
                                autoFocus: true,
                                showCursor: true,
                                cursorColor: kTitleColor,
                                onFieldSubmitted: (value) {
                                  if (!serialNumberList.contains(value)) {
                                    setState1(() {
                                      serialNumberList.add(value);
                                      serialController.text = '';
                                      serialFocus.requestFocus();
                                    });
                                  } else {
                                    EasyLoading.showError('Already Added');
                                    serialFocus.requestFocus();
                                  }
                                },
                                textFieldType: TextFieldType.NAME,
                                decoration: kInputDecoration.copyWith(
                                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                  labelText: lang.S.of(context).serialNumber,
                                  hintText: lang.S.of(context).enterserialNumber,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
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
                                    itemCount: serialNumberList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (serialNumberList.isNotEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 110,
                                                child: Text(
                                                  '${serialNumberList[index]},',
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              GestureDetector(
                                                  onTap: () {
                                                    setState1(() {
                                                      serialNumberList.removeAt(index);
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 15,
                                                  )),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Text(lang.S.of(context).noSerailNumberFound);
                                      }
                                    },
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 4,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1,
                                      // mainAxisExtent: 1,
                                    )),
                              ),
                            ],
                          ),
                        ).visible(isWantToAddSerial),
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
                                if (validateAndSave()) {
                                  cartList[index].serialNumber = serialNumberList;
                                  cartList[index].productPurchasePrice = editedPurchasePrice.toString();
                                  cartList[index].productSalePrice = editedSalePrice.toString();
                                  cartList[index].productDealerPrice = editDealerPrice.toString();
                                  cartList[index].productWholeSalePrice = editWholesalerPrice.toString();
                                  serialNumberList.isNotEmpty ? cartList[index].productStock = serialNumberList.length.toString() : null;

                                  setState(() {});

                                  Navigator.pop(context);
                                }
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showAddItemPopUp() {
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
                child: const PurchaseShowAddItemPopUp());
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
                  children: [CalcButton()],
                ),
              ),
            );
          },
        );
      },
    );
  }

  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController nameCodeCategoryController = TextEditingController();
  TextEditingController discountPercentageEditingController = TextEditingController();
  TextEditingController discountAmountEditingController = TextEditingController();
  double discountAmount = 0;
  double percentage = 0;

  FocusNode nameFocus = FocusNode();

  final ScrollController mainSideScroller = ScrollController();
  final ScrollController sideScroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<String> allProductsNameList = [];
    List<String> allProductsCodeList = [];

    return Consumer(
      builder: (context, consumerRef, __) {
        AsyncValue<List<ProductModel>> productList = consumerRef.watch(productProvider);
        final customers = consumerRef.watch(allCustomerProvider);
        final personalData = consumerRef.watch(profileDetailsProvider);
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
                              ///_______Date_________________________________________________
                              SizedBox(
                                width: context.width() < 1080 ? 1080 * .13 : MediaQuery.of(context).size.width * .13,
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
                                    ).onTap(() => _selectedDueDate(context))),
                              ),
                              const SizedBox(width: 15.0),

                              ///_________Previous_Due__________________________________
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(),
                                  child: Center(
                                    child: Text(
                                      '$currency$previousDue',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),

                              ///_________Calculator_____________________________________
                              const SizedBox(width: 15.0),
                              Text(
                                lang.S.of(context).calculator,
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
                                          Text(
                                            lang.S.of(context).dashBoard,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )).onTap(
                                  () => Navigator.pushNamed(context, MtHomeScreen.route),
                                ),
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
                                      decoration: const BoxDecoration(),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            FeatherIcons.user,
                                            color: kTitleColor,
                                            size: 18.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Welcome ${data.companyName.toString()}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),

                          ///__________second_Row______________________________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///__________select_customer__________________________________
                              customers.when(data: (allCustomers) {
                                List<String> listOfPhoneNumber = [];
                                List<CustomerModel> suppliersList = [];

                                for (var value1 in allCustomers) {
                                  listOfPhoneNumber.add(value1.phoneNumber.removeAllWhiteSpace().toLowerCase());
                                  if (value1.type == 'Supplier') {
                                    suppliersList.add(value1);
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
                                    height: 40.0,
                                    width: context.width() < 1080 ? (1080 * .32) : (MediaQuery.of(context).size.width * .32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10),
                                        SizedBox(
                                            width: context.width() < 1080 ? (1080 * .32) - 50 : (MediaQuery.of(context).size.width * .32) - 50,
                                            child: DropdownButtonHideUnderline(child: getResult(suppliersList))),
                                        const Spacer(),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            color: kBlueTextColor,
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                          ),
                                          child: const Icon(
                                            FeatherIcons.userPlus,
                                            color: Colors.white,
                                            size: 18.0,
                                          ),
                                        ).onTap(() => finalUserRoleModel.partiesPermission
                                            ? AddCustomer(
                                                typeOfCustomerAdd: 'Supplier',
                                                listOfPhoneNumber: listOfPhoneNumber,
                                                sideBarNumber: 2,
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

                              ///______________invoice_counter-___________________________
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
                                    "#${data.purchaseInvoiceCounter.toString()}",
                                    style: const TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                              const SizedBox(width: 15.0),

                              ///___________product_search_________________________________
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
                                        onFieldSubmitted: (value) {
                                          if (value != '') {
                                            if (product.isEmpty) {
                                              EasyLoading.showError('No Product Found');
                                            }
                                            for (int i = 0; i < product.length; i++) {
                                              if (product[i].productCode == value) {
                                                ProductModel cartProduct = product[i];
                                                cartProduct.serialNumber = [];
                                                cartProduct.productStock = '1';
                                                setState(() {
                                                  if (!uniqueCheck(product[i].productCode)) {
                                                    cartList.add(cartProduct);
                                                    nameCodeCategoryController.clear();
                                                    nameFocus.requestFocus();
                                                    searchProductCode = '';
                                                  } else {
                                                    nameCodeCategoryController.clear();
                                                    nameFocus.requestFocus();
                                                    searchProductCode = '';
                                                  }
                                                });
                                                break;
                                              }
                                              if (i + 1 == product.length) {
                                                nameCodeCategoryController.clear();
                                                nameFocus.requestFocus();
                                                EasyLoading.showError('Not found');
                                                setState(() {
                                                  searchProductCode = '';
                                                });
                                              }
                                            }
                                          }
                                        },
                                        textFieldType: TextFieldType.NAME,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(FontAwesomeIcons.barcode, color: kTitleColor, size: 18.0),
                                          suffixIcon: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)), color: kBlueTextColor),
                                            child: const Center(
                                              child: Icon(FeatherIcons.plusSquare, color: Colors.white, size: 18.0),
                                            ),
                                          ).onTap(() async {
                                            if (await Subscription.subscriptionChecker(item: Product.route)) {
                                              AddProduct(
                                                allProductsCodeList: allProductsCodeList,
                                                allProductsNameList: allProductsNameList,
                                                sideBarNumber: 2,
                                              ).launch(context);
                                            } else {
                                              EasyLoading.showError('Update your plan first\nAdd Product limit is over.');
                                            }
                                          }),
                                          hintText: lang.S.of(context).nameorcodeorCategory,
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

                              ///________Customer_section_________________________________
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
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        lang.S.of(context).purchasePrice,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),

                          ///_________Purchase_bord_____________________________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///_____Cart_show_And_button_show____________________________
                              IntrinsicWidth(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kWhiteTextColor,
                                      border: Border.all(width: 1, color: kGreyTextColor.withOpacity(0.3)),
                                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: context.width() < 1260 ? 630 : context.width() * 0.5,
                                        height: context.height() < 720 ? 720 - 306 : context.height() - 306,
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
                                                    SizedBox(width: 230, child: Text(lang.S.of(context).productName)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).quantity)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).unit)),
                                                    SizedBox(width: 70, child: Center(child: Text(lang.S.of(context).purchase))),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).total)),
                                                    SizedBox(width: 50, child: Text(lang.S.of(context).action)),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: cartList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  TextEditingController quantityController = TextEditingController(text: cartList[index].productStock.toString());
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          ///______________name__________________________________________________
                                                          Container(
                                                            width: 230,
                                                            padding: const EdgeInsets.only(left: 15),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  cartList[index].productName,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                ),
                                                                const SizedBox(width: 5),

                                                                ///_________serial_edit_________________________________________________________
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      lang.S.of(context).editAddorSerial,
                                                                      maxLines: 1,
                                                                      style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    const SizedBox(width: 5),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        productEditPopUp(product: cartList[index], index: index);
                                                                      },
                                                                      child: const Icon(
                                                                        Icons.edit_note,
                                                                        size: 18,
                                                                        color: kBlueTextColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          ///____________quantity_________________________________________________
                                                          SizedBox(
                                                            width: 70,
                                                            child: TextFormField(
                                                              textAlign: TextAlign.center,
                                                              maxLines: 1,
                                                              showCursor: true,
                                                              cursorColor: kTitleColor,
                                                              controller: quantityController,
                                                              onChanged: (value) {
                                                                if (value == '' || value == '0') {
                                                                  cartList[index].productStock = '1';
                                                                } else {
                                                                  cartList[index].productStock = value;
                                                                }
                                                              },
                                                              onFieldSubmitted: (value) {
                                                                if (value == '' || value == '0') {
                                                                  setState(() {
                                                                    cartList[index].productStock = '1';
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    cartList[index].productStock = value;
                                                                  });
                                                                }
                                                              },
                                                              decoration: kInputDecoration.copyWith(
                                                                enabledBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                  borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                                                                ),
                                                                focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                                                  borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                                                                ),
                                                              ),
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter.digitsOnly,
                                                                LengthLimitingTextInputFormatter(6),
                                                              ],
                                                            ),
                                                          ),

                                                          ///______Unit___________________________________________________________
                                                          SizedBox(
                                                            width: 70,
                                                            child: Text(
                                                              cartList[index].productUnit,
                                                              style: kTextStyle.copyWith(color: kTitleColor),
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),

                                                          ///___________Purchase____________________________________________________
                                                          SizedBox(
                                                            width: 70,
                                                            child: Text(
                                                              cartList[index].productPurchasePrice,
                                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),

                                                          ///___________Total____________________________________________________

                                                          SizedBox(
                                                            width: 70,
                                                            child: Text(
                                                              (double.parse(cartList[index].productPurchasePrice) * cartList[index].productStock.toInt()).toString(),
                                                              style: kTextStyle.copyWith(color: kTitleColor),
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),

                                                          ///_______________actions_________________________________________________
                                                          SizedBox(
                                                            width: 50,
                                                            child: Center(
                                                              child: const Icon(
                                                                Icons.close_sharp,
                                                                color: redColor,
                                                              ).onTap(() {
                                                                setState(() {
                                                                  cartList.removeAt(index);
                                                                });
                                                              }),
                                                            ),
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

                                      ///__________Subtotal_discount_buttons____________________________________________________
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            ///__________subTotal_____________________________________________________
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
                                                    padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
                                                    decoration: const BoxDecoration(color: kGreenTextColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                                    child: Center(
                                                      child: Text(
                                                        "$currency ${getTotalAmount().toDouble() - discountAmount}",
                                                        style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
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
                                                                percentage = 0.0;
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
                                                                      ((discountAmount * 100) / getTotalAmount().toDouble()).toStringAsFixed(1);
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

                                            ///______________buttons__________________________________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ///_______cancel_button____________________________________________________
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
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(2.0),
                                                      color: Colors.black,
                                                    ),
                                                    child: Text(
                                                      lang.S.of(context).quotation,
                                                      textAlign: TextAlign.center,
                                                      style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ).visible(false),
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
                                                    ).onTap(() => showHoldPopUp())).visible(false),
                                                const SizedBox(width: 10.0),

                                                ///__________payment_button________________________________________________
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
                                                      if (await Subscription.subscriptionChecker(item: Purchase.route)) {
                                                        if (cartList.isEmpty) {
                                                          EasyLoading.showError('Please Add Some Product first');
                                                        } else {
                                                          PurchaseTransactionModel transitionModel = PurchaseTransactionModel(
                                                            customerName: selectedUserName.customerFullName,
                                                            customer: selectedUserName,
                                                            customerType: selectedUserName.type,
                                                            customerPhone: selectedUserName.phoneNumber,
                                                            invoiceNumber: data.purchaseInvoiceCounter.toString(),
                                                            purchaseDate: DateTime.now().toString(),
                                                            productList: cartList,
                                                            discountAmount: discountAmount,
                                                            totalAmount: getTotalAmount().toDouble() - discountAmount,
                                                          );
                                                          PurchaseShowPaymentPopUp(
                                                            transitionModel: transitionModel,
                                                          ).launch(context);
                                                        }
                                                      } else {
                                                        EasyLoading.showError('Update your plan first\nPurchase Limit is over.');
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

                              ///_________selected_category_____________________________________
                              Consumer(
                                builder: (_, ref, watch) {
                                  AsyncValue<List<CategoryModel>> categoryList = ref.watch(categoryProvider);
                                  return categoryList.when(data: (category) {
                                    return SizedBox(
                                      width: 150,
                                      child: Container(
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
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      color: isSelected == 'Categories' ? kBlueTextColor : kBlueTextColor.withOpacity(0.1)),
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

                              ///_____________products_show____________________________
                              productList.when(data: (products) {
                                List<ProductModel> showProductVsCategory = [];
                                if (selectedCategory == 'Categories') {
                                  for (var element in products) {
                                    if (element.productCode.contains(searchProductCode)) {
                                      showProductVsCategory.add(element);
                                    }
                                  }
                                } else {
                                  for (var element in products) {
                                    if (element.productCategory == selectedCategory) {
                                      showProductVsCategory.add(element);
                                    }
                                  }
                                }
                                return showProductVsCategory.isNotEmpty
                                    ? Expanded(
                                        flex: 4,
                                        child: Container(
                                          height: context.height() < 720 ? 720 - 136 : context.height() - 136,
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
                                                    ///_______image_and_stock_____________________________________
                                                    Stack(
                                                      alignment: Alignment.topLeft,
                                                      children: [
                                                        //________image___________________________________________
                                                        Container(
                                                          height: 120,
                                                          decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                                            image: DecorationImage(image: NetworkImage(showProductVsCategory[i].productPicture), fit: BoxFit.cover),
                                                          ),
                                                        ),

                                                        ///_______stock________________________________________________
                                                        Positioned(
                                                          left: 5,
                                                          top: 5,
                                                          child: Container(
                                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                            decoration: BoxDecoration(color: showProductVsCategory[i].productStock == '0' ? kRedTextColor : kGreenTextColor),
                                                            child: Text(
                                                              showProductVsCategory[i].productStock != '0' ? '${showProductVsCategory[i].productStock} pc' : 'Out of stock',
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
                                                          ///_______________product_name______________________________________________
                                                          Text(
                                                            showProductVsCategory[i].productName,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(height: 4.0),

                                                          ///________Purchase_price___________________________________________________
                                                          Container(
                                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                            decoration: BoxDecoration(color: kGreenTextColor, borderRadius: BorderRadius.circular(2.0)),
                                                            child: Text(
                                                              showProductVsCategory[i].productPurchasePrice,
                                                              style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold, fontSize: 14.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ).onTap(() {
                                                setState(() {
                                                  ProductModel product = ProductModel(
                                                    productName: showProductVsCategory[i].productName,
                                                    productCategory: showProductVsCategory[i].productCategory,
                                                    size: showProductVsCategory[i].size,
                                                    color: showProductVsCategory[i].color,
                                                    weight: showProductVsCategory[i].weight,
                                                    capacity: showProductVsCategory[i].capacity,
                                                    type: showProductVsCategory[i].type,
                                                    warranty: showProductVsCategory[i].warranty,
                                                    brandName: showProductVsCategory[i].brandName,
                                                    productCode: showProductVsCategory[i].productCode,
                                                    productStock: '1',
                                                    productUnit: showProductVsCategory[i].productUnit,
                                                    productSalePrice: showProductVsCategory[i].productSalePrice,
                                                    productPurchasePrice: showProductVsCategory[i].productPurchasePrice,
                                                    productDiscount: showProductVsCategory[i].productDiscount,
                                                    productWholeSalePrice: showProductVsCategory[i].productWholeSalePrice,
                                                    productDealerPrice: showProductVsCategory[i].productDealerPrice,
                                                    productManufacturer: showProductVsCategory[i].productManufacturer,
                                                    productPicture: showProductVsCategory[i].productPicture,
                                                    nsnSAC: showProductVsCategory[i].nsnSAC,
                                                    serialNumber: [],
                                                  );

                                                  if (!uniqueCheck(product.productCode)) {
                                                    cartList.add(product);
                                                  }
                                                });
                                              });
                                            },
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
                                                      sideBarNumber: 2,
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
                          ),
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
