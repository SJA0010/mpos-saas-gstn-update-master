// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/model/product_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../Provider/due_transaction_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';
import '../../model/transition_model.dart';
import '../Widgets/Constant Data/constant.dart';

// ignore: must_be_immutable
class ShowEditPaymentPopUp extends StatefulWidget {
  ShowEditPaymentPopUp(
      {Key? key,
      required this.newTransitionModel,
      required this.previousPaid,
      required this.oldTransitionModel,
      required this.pastProducts,
      required this.decreaseStockList,
      required this.saleListPopUpContext})
      : super(key: key);
  final SaleTransactionModel newTransitionModel;
  final SaleTransactionModel oldTransitionModel;
  final double previousPaid;
  List<AddToCartModel> pastProducts;
  List<AddToCartModel> decreaseStockList;
  BuildContext saleListPopUpContext;

  @override
  State<ShowEditPaymentPopUp> createState() => _ShowEditPaymentPopUpState();
}

class _ShowEditPaymentPopUpState extends State<ShowEditPaymentPopUp> {
  List<String> paymentItem = [
    'Bank',
    'Due',
    'B-kash',
    'Nagad',
    'Rocket',
    'DBBL',
  ];
  String selectedPaymentOption = 'Bank';

  DropdownButton<String> getOption() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in paymentItem) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedPaymentOption,
      onChanged: (value) {
        setState(() {
          selectedPaymentOption = value!;
        });
      },
    );
  }

  String getTotalAmount() {
    double total = 0.0;
    for (var item in widget.newTransitionModel.productList!) {
      total = total + (double.parse(item.subTotal) * item.quantity);
    }
    return total.toString();
  }

  double dueAmount = 0.0;
  double returnAmount = 0.0;

  TextEditingController payingAmountController = TextEditingController();
  TextEditingController changeAmountController = TextEditingController();
  TextEditingController dueAmountController = TextEditingController();

  bool isGuestCustomer = false;

  late SaleTransactionModel myTransitionModel;
  double pastDue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pastDue = widget.oldTransitionModel.dueAmount!.toDouble();

    payingAmountController.text = widget.previousPaid.toString();
    double paidAmount = widget.previousPaid;
    if (paidAmount > widget.newTransitionModel.totalAmount!.toDouble()) {
      changeAmountController.text = (paidAmount - widget.newTransitionModel.totalAmount!.toDouble()).toString();
      dueAmountController.text = '0';
      dueAmount = 0;
    } else {
      dueAmount = (widget.newTransitionModel.totalAmount!.toDouble() - paidAmount).abs();
      dueAmountController.text = dueAmount.toString();

      changeAmountController.text = '0';
    }
  }

  SaleTransactionModel checkLossProfit({required SaleTransactionModel transitionModel}) {
    int totalQuantity = 0;
    double lossProfit = 0;
    double totalPurchasePrice = 0;
    double totalSalePrice = 0;
    for (var element in transitionModel.productList!) {
      totalPurchasePrice = totalPurchasePrice + (double.parse(element.productPurchasePrice) * element.quantity);
      totalSalePrice = totalSalePrice + (double.parse(element.subTotal.toString()) * element.quantity);

      totalQuantity = totalQuantity + element.quantity;
    }
    lossProfit = ((totalSalePrice - totalPurchasePrice) - double.parse(transitionModel.discountAmount.toString()));

    transitionModel.totalQuantity = totalQuantity;
    transitionModel.lossProfit = lossProfit;

    return transitionModel;
  }

  final ScrollController mainSideScroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, consumerRef, __) {
        final personalData = consumerRef.watch(profileDetailsProvider);
        return Scrollbar(
          controller: mainSideScroller,
          child: SingleChildScrollView(
            controller: mainSideScroller,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: personalData.when(data: (data) {
                return SizedBox(
                  width: context.width() < 750 ? 750 : context.width(),
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
                              lang.S.of(context).createPayments,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kWhiteTextColor, border: Border.all(color: kLitGreyColor)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            lang.S.of(context).payingAmount,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: context.width() < 750 ? 170 : context.width() * 0.22,
                                          child: TextFormField(
                                            controller: payingAmountController,
                                            onChanged: (value) {
                                              setState(() {
                                                double paidAmount = double.parse(value);
                                                if (paidAmount > widget.newTransitionModel.totalAmount!.toDouble()) {
                                                  changeAmountController.text = (paidAmount - widget.newTransitionModel.totalAmount!.toDouble()).toString();
                                                  dueAmountController.text = '0';
                                                  dueAmount = 0;
                                                } else {
                                                  dueAmount = (widget.newTransitionModel.totalAmount!.toDouble() - paidAmount).abs();
                                                  dueAmountController.text = (widget.newTransitionModel.totalAmount!.toDouble() - paidAmount).abs().toString();
                                                  changeAmountController.text = '0';
                                                }
                                              });
                                            },
                                            showCursor: true,
                                            cursorColor: kTitleColor,
                                            decoration: kInputDecoration.copyWith(
                                              hintText: lang.S.of(context).enterPaidAmonts,
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            lang.S.of(context).changeAmount,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: context.width() < 750 ? 170 : context.width() * 0.22,
                                          child: AppTextField(
                                            readOnly: true,
                                            controller: changeAmountController,
                                            cursorColor: kTitleColor,
                                            textFieldType: TextFieldType.NAME,
                                            decoration: kInputDecoration.copyWith(
                                              hintText: lang.S.of(context).changeAmount,
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            lang.S.of(context).dueAmonunt,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: context.width() < 750 ? 170 : context.width() * 0.22,
                                          child: AppTextField(
                                            readOnly: true,
                                            controller: dueAmountController,
                                            cursorColor: kTitleColor,
                                            textFieldType: TextFieldType.NAME,
                                            decoration: kInputDecoration.copyWith(
                                              hintText: lang.S.of(context).dueAmonunt,
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            lang.S.of(context).paymentType,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: context.width() < 750 ? 170 : context.width() * 0.22,
                                          child: FormField(
                                            builder: (FormFieldState<dynamic> field) {
                                              return InputDecorator(
                                                decoration: const InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                    ),
                                                    contentPadding: EdgeInsets.only(left: 12.0, right: 10.0, top: 7.0, bottom: 7.0),
                                                    floatingLabelBehavior: FloatingLabelBehavior.never),
                                                child: DropdownButtonHideUnderline(child: getOption()),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
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
                                          ),
                                        ).onTap(() => {finish(context)}),
                                        const SizedBox(width: 40.0),
                                        Container(
                                          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: kBlueTextColor,
                                          ),
                                          child: Text(
                                            lang.S.of(context).submit,
                                            style: kTextStyle.copyWith(color: kWhiteTextColor),
                                          ),
                                        ).onTap(
                                          () async {
                                            if (widget.newTransitionModel.productList!.isNotEmpty) {
                                              if (isGuestCustomer && dueAmount > 0) {
                                                EasyLoading.showError('Due is not for Guest Customer');
                                              } else {
                                                try {
                                                  EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                  myTransitionModel = widget.newTransitionModel;

                                                  dueAmountController.text.toDouble() <= 0 ? myTransitionModel.isPaid = true : myTransitionModel.isPaid = false;
                                                  dueAmountController.text.toDouble() <= 0 ? myTransitionModel.dueAmount = 0 : myTransitionModel.dueAmount = dueAmount;
                                                  returnAmount < 0 ? myTransitionModel.returnAmount = returnAmount.abs() : myTransitionModel.returnAmount = 0;
                                                  myTransitionModel.productList = widget.newTransitionModel.productList;

                                                  myTransitionModel.totalAmount = widget.newTransitionModel.totalAmount!.toDouble();
                                                  myTransitionModel.paymentType = selectedPaymentOption;
                                                  myTransitionModel.productList = widget.newTransitionModel.productList;

                                                  ///__________total LossProfit & quantity________________________________________________________________
                                                  myTransitionModel = checkLossProfit(transitionModel: widget.newTransitionModel);

                                                  ///________________updateInvoice___________________________________________________________OK
                                                  String? key;
                                                  await FirebaseDatabase.instance.ref(constUserId).child('Sales Transition').orderByKey().get().then((value) {
                                                    for (var element in value.children) {
                                                      final t = SaleTransactionModel.fromJson(jsonDecode(jsonEncode(element.value)));
                                                      if (myTransitionModel.invoiceNumber == t.invoiceNumber) {
                                                        key = element.key;
                                                      }
                                                    }
                                                  });
                                                  await FirebaseDatabase.instance.ref(constUserId).child('Sales Transition').child(key!).update(myTransitionModel.toJson());

                                                  ///__________StockMange_________________________________________________OK
                                                  List<AddToCartModel> presentProducts = widget.newTransitionModel.productList!;

                                                  List<AddToCartModel> increaseStockList = [];
                                                  for (var pastElement in widget.pastProducts) {
                                                    int i = 0;
                                                    for (var futureElement in presentProducts) {
                                                      if (pastElement.productId == futureElement.productId) {
                                                        if (pastElement.quantity < futureElement.quantity && pastElement.quantity != futureElement.quantity) {
                                                          widget.decreaseStockList.contains(pastElement.productId)
                                                              ? null
                                                              : widget.decreaseStockList.add(
                                                                  AddToCartModel(
                                                                    productName: pastElement.productName,
                                                                    productId: pastElement.productId,
                                                                    quantity: futureElement.quantity.toInt() - pastElement.quantity.toInt(),
                                                                    serialNumber: pastElement.serialNumber,
                                                                    productPurchasePrice: pastElement.productPurchasePrice,
                                                                  ),
                                                                );
                                                        } else if (pastElement.quantity > futureElement.quantity && pastElement.quantity != futureElement.quantity) {
                                                          increaseStockList.contains(pastElement.productId)
                                                              ? null
                                                              : increaseStockList.add(
                                                                  AddToCartModel(
                                                                    productName: pastElement.productName,
                                                                    productId: pastElement.productId,
                                                                    quantity: pastElement.quantity - futureElement.quantity,
                                                                    serialNumber: pastElement.serialNumber != []
                                                                        ? futureElement.quantity < pastElement.serialNumber!.length
                                                                            ? pastElement.serialNumber!.sublist(0, futureElement.quantity + 1)
                                                                            : pastElement.serialNumber
                                                                        : [],
                                                                    productPurchasePrice: pastElement.productPurchasePrice,
                                                                  ),
                                                                );
                                                        }
                                                        break;
                                                      } else {
                                                        i++;
                                                        if (i == presentProducts.length) {
                                                          increaseStockList.add(
                                                            AddToCartModel(
                                                                productName: pastElement.productName,
                                                                productId: pastElement.productId,
                                                                quantity: pastElement.quantity,
                                                                serialNumber: pastElement.serialNumber,
                                                                productPurchasePrice: pastElement.productPurchasePrice),
                                                          );
                                                        }
                                                      }
                                                    }
                                                  }
                                                  for (var element in widget.decreaseStockList) {
                                                    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

                                                    var data = await ref.orderByChild('productCode').equalTo(element.productId).once();
                                                    String productPath = data.snapshot.value.toString().substring(1, 21);

                                                    var data1 = await ref.child('$productPath/productStock').once();
                                                    int stock = int.parse(data1.snapshot.value.toString());
                                                    int remainStock = stock - int.parse(element.quantity.toString());

                                                    ref.child(productPath).update({'productStock': '$remainStock'});
                                                  }

                                                  ///____________deleted_products_______________________________________________

                                                  for (var element in increaseStockList) {
                                                    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

                                                    var data = await ref.orderByChild('productCode').equalTo(element.productId).once();
                                                    String productPath = data.snapshot.value.toString().substring(1, 21);

                                                    var data1 = await ref.child('$productPath/productStock').once();

                                                    int stock = int.parse(data1.snapshot.value.toString());

                                                    ///______update_stock____________________________________________________
                                                    int remainStock = stock + int.parse(element.quantity.toString());

                                                    ref.child(productPath).update({'productStock': '$remainStock'});

                                                    ///_____serial_add________________________________
                                                    ProductModel? productData;

                                                    final serialRef = FirebaseDatabase.instance.ref('$constUserId/Products/$productPath');
                                                    await serialRef.orderByKey().get().then((value) {
                                                      productData = ProductModel.fromJson(jsonDecode(jsonEncode(value.value)));
                                                    });

                                                    for (var element in element.serialNumber!) {
                                                      productData!.serialNumber.add(element);
                                                    }
                                                    serialRef.child('serialNumber').set(productData!.serialNumber.map((e) => e).toList());
                                                  }

                                                  ///_________DueUpdate______________________________________________________OK
                                                  if (pastDue < widget.newTransitionModel.dueAmount!) {
                                                    double due = pastDue - widget.newTransitionModel.dueAmount!;
                                                    // getSpecificCustomersDueUpdate(
                                                    //     phoneNumber: widget.newTransitionModel.customerPhone, isDuePaid: false, due: due.toInt());
                                                    final ref = FirebaseDatabase.instance.ref('$constUserId/Customers/');
                                                    String? key;

                                                    await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
                                                      for (var element in value.children) {
                                                        var data = jsonDecode(jsonEncode(element.value));
                                                        if (data['phoneNumber'] == widget.newTransitionModel.customerPhone) {
                                                          key = element.key;
                                                        }
                                                      }
                                                    });
                                                    var data1 = await ref.child('$key/due').once();
                                                    int previousDue = data1.snapshot.value.toString().toInt();

                                                    int totalDue;

                                                    totalDue = previousDue - due.toInt();
                                                    ref.child(key!).update({'due': '$totalDue'});
                                                  } else if (pastDue > widget.newTransitionModel.dueAmount!) {
                                                    double due = widget.newTransitionModel.dueAmount! - pastDue;
                                                    final ref = FirebaseDatabase.instance.ref('$constUserId/Customers/');
                                                    String? key;

                                                    await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
                                                      for (var element in value.children) {
                                                        var data = jsonDecode(jsonEncode(element.value));
                                                        if (data['phoneNumber'] == widget.newTransitionModel.customerPhone) {
                                                          key = element.key;
                                                        }
                                                      }
                                                    });
                                                    var data1 = await ref.child('$key/due').once();
                                                    int previousDue = data1.snapshot.value.toString().toInt();

                                                    int totalDue;

                                                    totalDue = previousDue + due.toInt();
                                                    ref.child(key!).update({'due': '$totalDue'});
                                                  }

                                                  consumerRef.refresh(allCustomerProvider);
                                                  consumerRef.refresh(buyerCustomerProvider);
                                                  consumerRef.refresh(transitionProvider);
                                                  consumerRef.refresh(productProvider);
                                                  consumerRef.refresh(purchaseTransitionProvider);
                                                  consumerRef.refresh(dueTransactionProvider);
                                                  consumerRef.refresh(profileDetailsProvider);

                                                  EasyLoading.dismiss();

                                                  // ignore: use_build_context_synchronously
                                                  int count = 0;
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.popUntil(context, (route) {
                                                    return count++ == 2;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(widget.saleListPopUpContext);
                                                } catch (e) {
                                                  EasyLoading.dismiss();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                }
                                              }
                                            } else {
                                              EasyLoading.showError('Add product first');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: kWhiteTextColor,
                                  border: Border.all(color: kLitGreyColor),
                                ),
                                child: Column(
                                  children: [
                                    ///______________total_product_______________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: radiusCircular(5.0), topRight: radiusCircular(5.0)),
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).totalProduct,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${widget.newTransitionModel.productList?.length}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///______________total_Amount_______________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).totalAmount,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency ${getTotalAmount()}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///__________vat_gst__________________________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).vatGST,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency${widget.newTransitionModel.cgst}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///___________service_________________________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).shipingorServices,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency${widget.newTransitionModel.serviceCharge}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///___________service_________________________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).discount,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency${widget.newTransitionModel.discountAmount}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///______________grand_total___________________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomLeft: radiusCircular(5.0), bottomRight: radiusCircular(5.0)),
                                        color: kLitGreyColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).grandTotal,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency ${widget.newTransitionModel.totalAmount}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ),
                            // Expanded(
                            //   flex: 3,
                            //   child: Container(
                            //     padding: const EdgeInsets.all(10.0),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5.0),
                            //       color: kWhiteTextColor,
                            //       border: Border.all(color: kLitGreyColor),
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         Container(
                            //           padding: const EdgeInsets.all(10.0),
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.only(topLeft: radiusCircular(5.0), topRight: radiusCircular(5.0)),
                            //             color: kWhiteTextColor,
                            //             border: Border.all(color: kLitGreyColor),
                            //           ),
                            //           child: Row(
                            //             children: [
                            //               Text(
                            //                 'Total Product',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //               const Spacer(),
                            //               Text(
                            //                 '${widget.newTransitionModel.productList?.length}',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Container(
                            //           padding: const EdgeInsets.all(10.0),
                            //           decoration: BoxDecoration(
                            //             color: kWhiteTextColor,
                            //             border: Border.all(color: kLitGreyColor),
                            //           ),
                            //           child: Row(
                            //             children: [
                            //               Text(
                            //                 'Vat/GST',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //               const Spacer(),
                            //               Text(
                            //                 '0.00',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Container(
                            //           padding: const EdgeInsets.all(10.0),
                            //           decoration: BoxDecoration(
                            //             color: kWhiteTextColor,
                            //             border: Border.all(color: kLitGreyColor),
                            //           ),
                            //           child: Row(
                            //             children: [
                            //               Text(
                            //                 'Shipping/Service',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //               const Spacer(),
                            //               Text(
                            //                 '0.00',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Container(
                            //           padding: const EdgeInsets.all(10.0),
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.only(bottomLeft: radiusCircular(5.0), bottomRight: radiusCircular(5.0)),
                            //             color: kLitGreyColor,
                            //             border: Border.all(color: kLitGreyColor),
                            //           ),
                            //           child: Row(
                            //             children: [
                            //               Text(
                            //                 'Grand Total',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //               const Spacer(),
                            //               Text(
                            //                 '${currency} ${widget.newTransitionModel.totalAmount!.toDouble()}',
                            //                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         const SizedBox(height: 20.0),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
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
            ),
          ),
        );
      },
    );
  }
}
