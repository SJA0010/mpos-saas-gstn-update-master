// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/customer_provider.dart';
import 'package:salespro_admin/Provider/due_transaction_provider.dart';
import 'package:salespro_admin/Provider/product_provider.dart';
import 'package:salespro_admin/model/product_model.dart';
import 'package:salespro_admin/model/transition_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../../Provider/profile_provider.dart';
import '../../../../Provider/transactions_provider.dart';
import '../../../../constant.dart';
import '../../../../currency.dart';
import '../../Constant Data/constant.dart';

// ignore: must_be_immutable
class ShowEditPurchasePaymentPopUp extends StatefulWidget {
  ShowEditPurchasePaymentPopUp({
    Key? key,
    required this.purchaseTransitionModel,
    required this.previousPaid,
    required this.increaseStockList,
    required this.saleListPopUpContext,
  }) : super(key: key);
  final PurchaseTransactionModel purchaseTransitionModel;
  final double previousPaid;
  List<ProductModel> increaseStockList;
  final BuildContext saleListPopUpContext;

  @override
  State<ShowEditPurchasePaymentPopUp> createState() => _ShowEditPurchasePaymentPopUpState();
}

class _ShowEditPurchasePaymentPopUpState extends State<ShowEditPurchasePaymentPopUp> {
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
    for (var item in widget.purchaseTransitionModel.productList!) {
      total = total + (double.parse(item.productPurchasePrice) * item.productStock.toInt());
    }
    return total.toString();
  }

  double discountAmount = 0;
  double returnAmount = 0;
  double subTotal = 0;
  String? dropdownValue = 'Cash';

  TextEditingController payingAmountController = TextEditingController();
  TextEditingController changeAmountController = TextEditingController();
  TextEditingController dueAmountController = TextEditingController();

  bool isGuestCustomer = false;
  List<ProductModel> presentProducts = [];
  List<ProductModel> decreaseStockList2 = [];
  late PurchaseTransactionModel myTransitionModel;

  @override
  void initState() {
    super.initState();

    payingAmountController.text = widget.previousPaid.toString();
    double paidAmount = widget.previousPaid;
    if (paidAmount > widget.purchaseTransitionModel.totalAmount!.toDouble()) {
      changeAmountController.text = (paidAmount - widget.purchaseTransitionModel.totalAmount!.toDouble()).toString();
      dueAmountController.text = '0';
    } else {
      dueAmountController.text = (widget.purchaseTransitionModel.totalAmount!.toDouble() - paidAmount).abs().toString();

      changeAmountController.text = '0';
    }
    presentProducts = widget.purchaseTransitionModel.productList!;
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
              child: personalData.when(
                data: (data) {
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
                                            child: AppTextField(
                                              controller: payingAmountController,
                                              onChanged: (value) {
                                                setState(() {
                                                  double paidAmount = double.parse(value);
                                                  if (paidAmount > widget.purchaseTransitionModel.totalAmount!.toDouble()) {
                                                    changeAmountController.text = (paidAmount - widget.purchaseTransitionModel.totalAmount!.toDouble()).toString();
                                                    dueAmountController.text = '0';
                                                  } else {
                                                    dueAmountController.text = (widget.purchaseTransitionModel.totalAmount!.toDouble() - paidAmount).abs().toString();
                                                    changeAmountController.text = '0';
                                                  }
                                                });
                                              },
                                              showCursor: true,
                                              cursorColor: kTitleColor,
                                              textFieldType: TextFieldType.NAME,
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
                                              controller: changeAmountController,
                                              showCursor: true,
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
                                              controller: dueAmountController,
                                              showCursor: true,
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
                                              )).onTap(() => {finish(context)}),
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
                                              if (widget.purchaseTransitionModel.productList!.isNotEmpty) {
                                                if (isGuestCustomer && dueAmountController.text.toDouble() > 0) {
                                                  EasyLoading.showError('Due is not for Guest Customer');
                                                } else {
                                                  try {
                                                    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                    List<ProductModel> originalProducts = [];
                                                    int originalDue = 0;

                                                    myTransitionModel = PurchaseTransactionModel(
                                                      customer: widget.purchaseTransitionModel.customer,
                                                      customerName: widget.purchaseTransitionModel.customerName,
                                                      customerPhone: widget.purchaseTransitionModel.customerPhone,
                                                      customerType: widget.purchaseTransitionModel.customerType,
                                                      invoiceNumber: widget.purchaseTransitionModel.invoiceNumber,
                                                      purchaseDate: widget.purchaseTransitionModel.purchaseDate,
                                                      discountAmount: widget.purchaseTransitionModel.discountAmount,
                                                    );

                                                    dueAmountController.text.toDouble() <= 0 ? myTransitionModel.isPaid = true : myTransitionModel.isPaid = false;
                                                    dueAmountController.text.toDouble() <= 0
                                                        ? myTransitionModel.dueAmount = 0
                                                        : myTransitionModel.dueAmount = dueAmountController.text.toDouble();
                                                    returnAmount < 0 ? myTransitionModel.returnAmount = returnAmount.abs() : myTransitionModel.returnAmount = 0;
                                                    myTransitionModel.productList = widget.purchaseTransitionModel.productList;

                                                    myTransitionModel.totalAmount = widget.purchaseTransitionModel.totalAmount!.toDouble();
                                                    myTransitionModel.paymentType = selectedPaymentOption;
                                                    myTransitionModel.sellerName = isSubUser ? constSubUserTitle : 'Admin';

                                                    ///________________updateInvoice___________________________________________________________ok
                                                    String? key;
                                                    await FirebaseDatabase.instance.ref(constUserId).child('Purchase Transition').orderByKey().get().then((value) {
                                                      for (var element in value.children) {
                                                        final t = PurchaseTransactionModel.fromJson(jsonDecode(jsonEncode(element.value)));
                                                        if (widget.purchaseTransitionModel.invoiceNumber == t.invoiceNumber) {
                                                          key = element.key;
                                                          originalProducts = t.productList ?? [];
                                                          originalDue = t.dueAmount!.toInt();
                                                        }
                                                      }
                                                    });
                                                    await FirebaseDatabase.instance.ref(constUserId).child('Purchase Transition').child(key!).update(myTransitionModel.toJson());

                                                    ///__________StockMange_________________________________________________ok

                                                    for (var pastElement in originalProducts) {
                                                      int i = 0;
                                                      for (var futureElement in presentProducts) {
                                                        if (pastElement.productCode == futureElement.productCode) {
                                                          if (pastElement.productStock.toInt() < futureElement.productStock.toInt() &&
                                                              pastElement.productStock != futureElement.productStock) {
                                                            ProductModel m = pastElement;
                                                            m.productStock = (futureElement.productStock.toInt() - pastElement.productStock.toInt()).toString();
                                                            // ignore: iterable_contains_unrelated_type
                                                            widget.increaseStockList.contains(pastElement.productCode) ? null : widget.increaseStockList.add(m);
                                                          } else if (pastElement.productStock.toInt() > futureElement.productStock.toInt() &&
                                                              pastElement.productStock.toInt() != futureElement.productStock.toInt()) {
                                                            ProductModel n = pastElement;
                                                            n.productStock = (pastElement.productStock.toInt() - futureElement.productStock.toInt()).toString();
                                                            // ignore: iterable_contains_unrelated_type
                                                            decreaseStockList2.contains(pastElement.productCode) ? null : decreaseStockList2.add(n);
                                                          }
                                                          break;
                                                        } else {
                                                          i++;
                                                          if (i == presentProducts.length) {
                                                            ProductModel n = pastElement;
                                                            decreaseStockList2.add(n);
                                                          }
                                                        }
                                                      }
                                                    }

                                                    ///_____________StockUpdate_______________________________________________________ok

                                                    for (var element in decreaseStockList2) {
                                                      final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

                                                      var data = await ref.orderByChild('productCode').equalTo(element.productCode).once();
                                                      String productPath = data.snapshot.value.toString().substring(1, 21);

                                                      var data1 = await ref.child('$productPath/productStock').once();
                                                      int stock = int.parse(data1.snapshot.value.toString());
                                                      int remainStock = stock - element.productStock.toInt();

                                                      ref.child(productPath).update({'productStock': '$remainStock'});
                                                    }

                                                    for (var element in widget.increaseStockList) {
                                                      final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

                                                      var data = await ref.orderByChild('productCode').equalTo(element.productCode).once();
                                                      String productPath = data.snapshot.value.toString().substring(1, 21);

                                                      var data1 = await ref.child('$productPath/productStock').once();
                                                      int stock = int.parse(data1.snapshot.value.toString());
                                                      int remainStock = stock + element.productStock.toInt();

                                                      ref.child(productPath).update({'productStock': '$remainStock'});
                                                    }

                                                    ///_________DueUpdate______________________________________________________OK
                                                    if (myTransitionModel.dueAmount!.toDouble() < widget.purchaseTransitionModel.dueAmount!) {
                                                      double due = originalDue - myTransitionModel.dueAmount!;

                                                      final ref = FirebaseDatabase.instance.ref('$constUserId/Customers/');
                                                      String? key;

                                                      await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
                                                        for (var element in value.children) {
                                                          var data = jsonDecode(jsonEncode(element.value));
                                                          if (data['phoneNumber'] == widget.purchaseTransitionModel.customerPhone) {
                                                            key = element.key;
                                                          }
                                                        }
                                                      });
                                                      var data1 = await ref.child('$key/due').once();
                                                      int previousDue = data1.snapshot.value.toString().toInt();

                                                      int totalDue;

                                                      totalDue = previousDue - due.toInt();
                                                      ref.child(key!).update({'due': '$totalDue'});
                                                    } else if (myTransitionModel.dueAmount!.toDouble() > widget.purchaseTransitionModel.dueAmount!) {
                                                      double due = myTransitionModel.dueAmount! - originalDue;
                                                      final ref = FirebaseDatabase.instance.ref('$constUserId/Customers/');
                                                      String? key;

                                                      await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
                                                        for (var element in value.children) {
                                                          var data = jsonDecode(jsonEncode(element.value));
                                                          if (data['phoneNumber'] == widget.purchaseTransitionModel.customerPhone) {
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

                              ///____________priceShow_____________________________________________________________
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
                                      ///____________total Products_____________________________________________________
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
                                              '${widget.purchaseTransitionModel.productList?.length}',
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///_________total Price______________________________________________________________
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: kWhiteTextColor,
                                          border: Border.all(color: kLitGreyColor),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              lang.S.of(context).totalPrice,
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

                                      ///___________discount________________________________________________________________
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
                                              '$currency ${widget.purchaseTransitionModel.discountAmount}',
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///___________________grand_total___________________________________________________
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
                                              '$currency ${widget.purchaseTransitionModel.totalAmount}',
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
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                error: (e, stack) {
                  return Center(
                    child: Text(e.toString()),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
