// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../../Provider/customer_provider.dart';
import '../../../../Provider/daily_transaction_provider.dart';
import '../../../../Provider/due_transaction_provider.dart';
import '../../../../Provider/product_provider.dart';
import '../../../../Provider/profile_provider.dart';
import '../../../../Provider/transactions_provider.dart';
import '../../../../constant.dart';
import '../../../../currency.dart';
import '../../../../model/daily_transaction_model.dart';
import '../../../../model/transition_model.dart';
import '../../../../subscription.dart';
import '../../../PDF/pdfs.dart';
import '../../Constant Data/constant.dart';

class PurchaseShowPaymentPopUp extends StatefulWidget {
  const PurchaseShowPaymentPopUp({Key? key, required this.transitionModel}) : super(key: key);
  final PurchaseTransactionModel transitionModel;

  @override
  State<PurchaseShowPaymentPopUp> createState() => _PurchaseShowPaymentPopUpState();
}

class _PurchaseShowPaymentPopUpState extends State<PurchaseShowPaymentPopUp> {
  bool isClicked = true;
  List<String> paymentItem = [
    'Cash',
    'Bank',
    'Due',
    'B-kash',
    'Nagad',
    'Rocket',
    'DBBL',
  ];
  String selectedPaymentOption = 'Cash';

  String getTotalAmount() {
    double total = 0.0;
    for (var item in widget.transitionModel.productList!) {
      total = total + (double.parse(item.productPurchasePrice) * item.productStock.toInt());
    }
    return total.toString();
  }

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

  double dueAmount = 0.0;
  double returnAmount = 0.0;

  TextEditingController payingAmountController = TextEditingController();
  TextEditingController changeAmountController = TextEditingController();
  TextEditingController dueAmountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      payingAmountController.text = '0';
      double paidAmount = double.parse(payingAmountController.text);
      if (paidAmount > widget.transitionModel.totalAmount!.toDouble()) {
        changeAmountController.text = (paidAmount - widget.transitionModel.totalAmount!.toDouble()).toString();
        dueAmountController.text = '0';
      } else {
        dueAmountController.text = (widget.transitionModel.totalAmount!.toDouble() - paidAmount).abs().toString();
        changeAmountController.text = '0';
      }
    });
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
                            const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {
                                  finish(context),
                                })
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
                                                if (paidAmount > widget.transitionModel.totalAmount!.toDouble()) {
                                                  changeAmountController.text = (paidAmount - widget.transitionModel.totalAmount!.toDouble()).toString();
                                                  dueAmountController.text = '0';
                                                } else {
                                                  dueAmountController.text = (widget.transitionModel.totalAmount!.toDouble() - paidAmount).abs().toString();
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
                                          isClicked
                                              ? () async {
                                                  if (widget.transitionModel.customerType == "Guest" && dueAmountController.text.toDouble() > 0) {
                                                    EasyLoading.showError('Due is not available Foe Guest');
                                                  } else {
                                                    setState(() {
                                                      isClicked = false;
                                                    });
                                                    try {
                                                      EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                      DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Purchase Transition");

                                                      dueAmountController.text.toDouble() <= 0 ? widget.transitionModel.isPaid = true : widget.transitionModel.isPaid = false;
                                                      dueAmountController.text.toDouble() <= 0
                                                          ? widget.transitionModel.dueAmount = 0
                                                          : widget.transitionModel.dueAmount = dueAmountController.text.toDouble();
                                                      changeAmountController.text.toDouble() > 0
                                                          ? widget.transitionModel.returnAmount = changeAmountController.text.toDouble().abs()
                                                          : widget.transitionModel.returnAmount = 0;
                                                      widget.transitionModel.totalAmount = widget.transitionModel.totalAmount!.toDouble();
                                                      widget.transitionModel.paymentType = selectedPaymentOption;
                                                      widget.transitionModel.sellerName = isSubUser ? constSubUserTitle : 'Admin';

                                                      await ref.push().set(widget.transitionModel.toJson());

                                                      ///__________StockMange_________________________________________________
                                                      final stockRef = FirebaseDatabase.instance.ref('$constUserId/Products/');
                                                      for (var element in widget.transitionModel.productList!) {
                                                        var data = await stockRef.orderByChild('productCode').equalTo(element.productCode).once();
                                                        final data2 = jsonDecode(jsonEncode(data.snapshot.value));
                                                        String productPath = data.snapshot.value.toString().substring(1, 21);

                                                        var data1 = await stockRef.child('$productPath/productStock').once();
                                                        int stock = int.parse(data1.snapshot.value.toString());
                                                        int remainStock = stock + element.productStock.toInt();

                                                        stockRef.child(productPath).update({
                                                          'productStock': '$remainStock',
                                                          'productSalePrice': element.productSalePrice,
                                                          'productPurchasePrice': element.productPurchasePrice,
                                                          'productDealerPrice': element.productDealerPrice,
                                                          'productWholeSalePrice': element.productWholeSalePrice,
                                                        });

                                                        ///________daily_transactionModel_________________________________________________________________________

                                                        DailyTransactionModel dailyTransaction = DailyTransactionModel(
                                                          name: widget.transitionModel.customerName,
                                                          date: widget.transitionModel.purchaseDate,
                                                          type: 'Purchase',
                                                          total: widget.transitionModel.totalAmount!.toDouble(),
                                                          paymentIn: 0,
                                                          paymentOut: widget.transitionModel.totalAmount!.toDouble() - widget.transitionModel.dueAmount!.toDouble(),
                                                          remainingBalance: widget.transitionModel.totalAmount!.toDouble() - widget.transitionModel.dueAmount!.toDouble(),
                                                          id: widget.transitionModel.invoiceNumber,
                                                          purchaseTransactionModel: widget.transitionModel,
                                                        );
                                                        postDailyTransaction(dailyTransactionModel: dailyTransaction);

                                                        ///________Update_Serial_Number____________________________________________________

                                                        if (element.serialNumber.isNotEmpty) {
                                                          var productOldSerialList = data2[productPath]['serialNumber'] ?? [];

                                                          List<dynamic> result = productOldSerialList + element.serialNumber;
                                                          stockRef.child(productPath).update({
                                                            'serialNumber': result.map((e) => e).toList(),
                                                          });
                                                        }
                                                      }

                                                      ///_________Invoice Increase______________________________________________________
                                                      updateInvoice(typeOfInvoice: 'purchaseInvoiceCounter', invoice: widget.transitionModel.invoiceNumber.toInt());

                                                      ///________Subscription____________________________________________________________
                                                      Subscription.decreaseSubscriptionLimits(itemType: 'purchaseNumber', context: context);

                                                      ///_________DueUpdate___________________________________________________________________________________
                                                      if (widget.transitionModel.customerName != 'Guest') {
                                                        final dueUpdateRef = FirebaseDatabase.instance.ref('$constUserId/Customers/');
                                                        String? key;

                                                        await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
                                                          for (var element in value.children) {
                                                            var data = jsonDecode(jsonEncode(element.value));
                                                            if (data['phoneNumber'] == widget.transitionModel.customerPhone) {
                                                              key = element.key;
                                                            }
                                                          }
                                                        });
                                                        var data1 = await dueUpdateRef.child('$key/due').once();
                                                        int previousDue = data1.snapshot.value.toString().toInt();

                                                        int totalDue = previousDue + widget.transitionModel.dueAmount!.toInt();
                                                        dueUpdateRef.child(key!).update({'due': '$totalDue'});
                                                      }

                                                      ///________update_all_provider___________________________________________________
                                                      consumerRef.refresh(allCustomerProvider);
                                                      consumerRef.refresh(transitionProvider);
                                                      consumerRef.refresh(productProvider);
                                                      consumerRef.refresh(purchaseTransitionProvider);
                                                      consumerRef.refresh(dueTransactionProvider);
                                                      consumerRef.refresh(profileDetailsProvider);
                                                      consumerRef.refresh(dailyTransactionProvider);

                                                      EasyLoading.showSuccess('Added Successfully');
                                                      GeneratePdfAndPrint()
                                                          .printPurchaseInvoice(personalInformationModel: data, purchaseTransactionModel: widget.transitionModel, context: context);
                                                      // PurchaseInvoice(
                                                      //   transitionModel: widget.transitionModel,
                                                      //   personalInformationModel: data,
                                                      //   isPurchase: true,
                                                      // ).launch(context);
                                                    } catch (e) {
                                                      EasyLoading.dismiss();
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                    }
                                                  }
                                                }
                                              : () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),

                            ///____________priceShow_____________________________________________________________-
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
                                            'Total Product',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${widget.transitionModel.productList?.length}',
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
                                            '$currency ${widget.transitionModel.discountAmount}',
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
                                            '$currency ${widget.transitionModel.totalAmount}',
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

  void getSpecificCustomers({required String phoneNumber, required int due}) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Customers/');
    String? key;

    await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'] == phoneNumber) {
          key = element.key;
        }
      }
    });
    var data1 = await ref.child('$key/due').once();
    int previousDue = data1.snapshot.value.toString().toInt();

    int totalDue = previousDue + due;
    ref.child(key!).update({'due': '$totalDue'});
  }

  void decreaseStock(String productCode, int quantity) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

    var data = await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock - quantity;

    ref.child(productPath).update({'productStock': '$remainStock'});
  }
}
