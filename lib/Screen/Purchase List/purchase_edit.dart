import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';
import '../../Provider/product_provider.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../../model/category_model.dart';
import '../../model/customer_model.dart';
import '../../model/personal_information_model.dart';
import '../../model/product_model.dart';
import '../../model/transition_model.dart';
import '../Widgets/Calculator/calculator.dart';
import '../Widgets/Pop UP/Pos Sale/due_sale_popup.dart';
import '../Widgets/Pop UP/Pos Sale/sale_list_popup.dart';
import '../Widgets/Pop UP/Pos Sale/show_payment_popup.dart';

class PurchaseEdit extends StatefulWidget {
  const PurchaseEdit({
    Key? key,
    required this.personalInformationModel,
    required this.isPosScreen,
    required this.purchaseTransitionModel,
    required this.popupContext,
  }) : super(key: key);

  final PurchaseTransactionModel purchaseTransitionModel;
  final PersonalInformationModel personalInformationModel;
  final bool isPosScreen;
  final BuildContext popupContext;

  static const String route = '/purchaseEdit';

  @override
  State<PurchaseEdit> createState() => _PurchaseEditState();
}

class _PurchaseEditState extends State<PurchaseEdit> {
  List<ProductModel> cartList = [];
  List<ProductModel> pastProducts = [];
  List<ProductModel> increaseStockList = [];

  bool isChecked = true;

  String isSelected = 'Categories';
  String? selectedUserId;
  String? invoiceNumber;
  String previousDue = "0";
  FocusNode nameFocus = FocusNode();

  List<SaleTransactionModel> filteredData = [];
  SaleTransactionModel? dueTransactionModel;
  List<CustomerModel> customerLists = [];

  String searchProductCode = '';
  String selectedCategory = 'Categories';

  String selectedUser = 'Name  Phone  Due';

  String getTotalAmount() {
    double total = 0.0;
    for (var item in cartList) {
      total = total + (double.parse(item.productPurchasePrice) * item.productStock.toInt());
    }
    return total.toString();
  }

  bool uniqueCheck(String code) {
    bool isUnique = false;
    for (var item in cartList) {
      if (item.productCode == code) {
        item.productStock = (int.parse(item.productStock) + 1).toString();
        isUnique = true;
        break;
      }
    }
    return isUnique;
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

  List<ProductModel> allProduct = [];

  TextEditingController nameCodeCategoryController = TextEditingController();
  bool doNotCheckProducts = false;
  bool isGuestCustomer = false;

  void productEditPopUp({required ProductModel product, required int index}) {
    FocusNode serialFocus = FocusNode();
    String editedPurchasePrice = '';
    String editedSalePrice = '';
    String editDealerPrice = '';
    String editWholesalerPrice = '';
    List<String> serialNumberList = [];
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

    bool isWantToAddSerial = false;
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
                                  hintText: lang.S.of(context).enterProductSerialNumber,
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
                                              Text(
                                                '${serialNumberList[index]},',
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pastProducts = widget.purchaseTransitionModel.productList!;
    discountAmountEditingController.text = widget.purchaseTransitionModel.discountAmount.toString();
    discountAmount = widget.purchaseTransitionModel.discountAmount!;
    discountPercentageEditingController.text = ((discountAmount * 100) / widget.purchaseTransitionModel.totalAmount!.toDouble()).toStringAsFixed(1);
  }

  final ScrollController mainSideScroller = ScrollController();
  final ScrollController sideScroller = ScrollController();

  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountPercentageEditingController = TextEditingController();
  TextEditingController discountAmountEditingController = TextEditingController();
  double discountAmount = 0;
  double percentage = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, consumerRef, __) {
        final personalData = consumerRef.watch(profileDetailsProvider);
        final productLists = consumerRef.watch(productProvider);
        AsyncValue<List<ProductModel>> productList = consumerRef.watch(productProvider);
        if (!doNotCheckProducts) {
          List<ProductModel> list = [];
          productLists.value?.forEach((products) {
            widget.purchaseTransitionModel.productList?.forEach((element) {
              if (element.productCode == products.productCode) {
                list.add(element);
              }
            });

            if (widget.purchaseTransitionModel.productList?.length == list.length) {
              cartList = list;
              doNotCheckProducts = true;
            }
          });
        }

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
                          ///__________First_row_____________________________________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ///______________date_picker____________________________________
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
                                          widget.purchaseTransitionModel.purchaseDate.substring(0, 10),
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ).onTap(() => _selectedDueDate(context))),
                              ),
                              const SizedBox(width: 15.0),

                              ///___________due_______________________________________________
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
                                      widget.purchaseTransitionModel.dueAmount.toString(),
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),

                              ///_________________Calculator____________________________________________________________
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
                              const SizedBox(width: 15),

                              ///____________dashBord__________________________________________________________________
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
                                    )).onTap(() => Navigator.of(context).pushNamed(MtHomeScreen.route)),
                              ),

                              ///_________welcome______________________________________________________________________
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

                          ///__________second_row____________________________________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///_____________Customer_name__________________________________
                              Card(
                                color: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(color: kLitGreyColor),
                                ),
                                child: SizedBox(
                                  height: 40,
                                  width: context.width() < 1080 ? (1080 * .32) : (MediaQuery.of(context).size.width * .32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.purchaseTransitionModel.customerName),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),

                              ///____________invoice_______________________________________
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
                                    "#${widget.purchaseTransitionModel.invoiceNumber}",
                                    style: const TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                              const SizedBox(width: 15.0),

                              ///___________product_search_________________________________
                              productList.when(data: (product) {
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

                              ///__________Customer_type__________________________________________________________
                              Expanded(
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: kLitGreyColor),
                                  ),
                                  child: SizedBox(
                                    width: context.width() < 1080 ? 120 : MediaQuery.of(context).size.width * .20,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        widget.purchaseTransitionModel.customerType.toString(),
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
                                                  int i = 0;
                                                  for (var element in pastProducts) {
                                                    if (element.productCode != cartList[index].productCode) {
                                                      i++;
                                                    }
                                                    if (i == pastProducts.length) {
                                                      bool isInTheList = false;
                                                      for (var element in increaseStockList) {
                                                        if (element.productCode == cartList[index].productCode) {
                                                          element.productStock = cartList[index].productStock;
                                                          isInTheList = true;
                                                          break;
                                                        }
                                                      }

                                                      isInTheList ? null : increaseStockList.add(cartList[index]);
                                                    }
                                                  }
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
                                                            child: Text(
                                                              cartList[index].productName,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
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

                                      ///__________price_section & buttons
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            ///________subtotal________________________________________________
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
                                                        (getTotalAmount().toDouble() - discountAmount).toString(),
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
                                                    const SizedBox(width: 4.0),
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

                                            ///__________buttons_____________________________________________
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 1,
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
                                                  ).onTap(() {
                                                    Navigator.pop(context);
                                                  }),
                                                ),
                                                const SizedBox(width: 10.0),
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
                                                    () {
                                                      if (cartList.isEmpty) {
                                                        EasyLoading.showError('Please Add Some Product first');
                                                      } else {
                                                        PurchaseTransactionModel purchaseTransitionModel = PurchaseTransactionModel(
                                                          customer: widget.purchaseTransitionModel.customer,
                                                          customerName: widget.purchaseTransitionModel.customerName,
                                                          customerType: widget.purchaseTransitionModel.customerType,
                                                          customerPhone: widget.purchaseTransitionModel.customerPhone,
                                                          invoiceNumber: widget.purchaseTransitionModel.invoiceNumber,
                                                          discountAmount: discountAmount,
                                                          isPaid: true,
                                                          paymentType: 'cash',
                                                          returnAmount: 0,
                                                          dueAmount: widget.purchaseTransitionModel.dueAmount,
                                                          purchaseDate: widget.purchaseTransitionModel.purchaseDate,
                                                          totalAmount: getTotalAmount().toDouble() - discountAmount,
                                                          productList: cartList,
                                                        );
                                                        ShowEditPurchasePaymentPopUp(
                                                          purchaseTransitionModel: purchaseTransitionModel,
                                                          increaseStockList: increaseStockList,
                                                          saleListPopUpContext: widget.popupContext,
                                                          previousPaid: widget.purchaseTransitionModel.totalAmount! - widget.purchaseTransitionModel.dueAmount!.toDouble(),
                                                        ).launch(context);
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

                              Consumer(
                                builder: (_, ref, watch) {
                                  AsyncValue<List<ProductModel>> productList = ref.watch(productProvider);
                                  return productList.when(data: (products) {
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
                                            child: SizedBox(
                                              height: context.height() < 720 ? 720 - 136 : context.height() - 136,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: kDarkWhite,
                                                ),
                                                child: GridView.builder(
                                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 180,
                                                    mainAxisExtent: 205,
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
                                                                  image: DecorationImage(
                                                                    image: NetworkImage(showProductVsCategory[i].productPicture),
                                                                    fit: BoxFit.cover,
                                                                  ),
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
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  showProductVsCategory[i].productName,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                ),
                                                                const SizedBox(height: 4.0),
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
                                                          serialNumber: showProductVsCategory[i].serialNumber.isEmpty ? [] : showProductVsCategory[i].serialNumber,
                                                        );

                                                        if (!uniqueCheck(product.productCode)) {
                                                          cartList.add(product);
                                                        }
                                                      });
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
                                                    onTap: () {},
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
                                  });
                                },
                              )
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
