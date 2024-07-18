// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/daily_transaction_provider.dart';
import 'package:salespro_admin/model/daily_transaction_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/customer_provider.dart';
import '../../Provider/due_transaction_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/transition_model.dart';
import '../../subscription.dart';
import '../PDF/pdfs.dart';
import '../Widgets/Constant Data/constant.dart';

class ShowPaymentPopUp extends StatefulWidget {
  const ShowPaymentPopUp({Key? key, required this.transitionModel, required this.isFromQuotation}) : super(key: key);
  final SaleTransactionModel transitionModel;
  final bool isFromQuotation;

  @override
  State<ShowPaymentPopUp> createState() => _ShowPaymentPopUpState();
}

class _ShowPaymentPopUpState extends State<ShowPaymentPopUp> {
  bool isClicked = true;
  SaleTransactionModel checkLossProfit({required SaleTransactionModel transitionModel}) {
    int totalQuantity = 0;
    double lossProfit = 0;
    double totalPurchasePrice = 0;
    double totalSalePrice = 0;
    for (var element in transitionModel.productList!) {
      totalPurchasePrice = totalPurchasePrice + (element.productPurchasePrice * element.quantity);
      totalSalePrice = totalSalePrice + (double.parse(element.subTotal) * element.quantity);

      totalQuantity = totalQuantity + element.quantity;
    }
    lossProfit = ((totalSalePrice - totalPurchasePrice.toDouble()) - double.parse(transitionModel.discountAmount.toString()));

    transitionModel.totalQuantity = totalQuantity;
    transitionModel.lossProfit = lossProfit;

    return transitionModel;
  }

  List<String> paymentItem = [
    'Cash',
    'Bank',
    'Due',
    'Bkash',
    'Nagad',
    'Rocket',
    'DBBL',
  ];
  String selectedPaymentOption = 'Cash';
  String neftNo = '';

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
        if (value == 'Bank') {
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
                    child: Container(
                      width: 500,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                neftNo = value;
                              },
                              showCursor: true,
                              cursorColor: kTitleColor,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: lang.S.of(context).nEFTNumber,
                                hintText: lang.S.of(context).enterNEFTNumber,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    widget.transitionModel.bankNEFT = '';
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: kRedTextColor,
                                      ),
                                      child: Text(
                                        lang.S.of(context).cancel,
                                        style: kTextStyle.copyWith(color: kWhiteTextColor),
                                      )),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    widget.transitionModel.bankNEFT = neftNo;
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        setState(() {
          selectedPaymentOption = value!;
        });
      },
    );
  }

  double dueAmount = 0.0;

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

  void deleteQuotation({required String date, required WidgetRef updateRef}) async {
    String key = '';
    await FirebaseDatabase.instance.ref(await getUserID()).child('Sales Quotation').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['purchaseDate'].toString() == date) {
          key = element.key.toString();
        }
      }
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("${await getUserID()}/Sales Quotation/$key");
    await ref.remove();
    updateRef.refresh(quotationProvider);
  }

  String getTotalAmount() {
    double total = 0.0;
    for (var item in widget.transitionModel.productList!) {
      total = total + (double.parse(item.subTotal) * item.quantity);
    }
    return total.toString();
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
                                          child: TextFormField(
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
                                            controller: dueAmountController,
                                            readOnly: true,
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
                                                      DatabaseReference ref = FirebaseDatabase.instance.ref("${await getUserID()}/Sales Transition");
                                                      DatabaseReference ref1 = FirebaseDatabase.instance.ref("${await getUserID()}/Quotation Convert History");

                                                      dueAmountController.text.toDouble() <= 0 ? widget.transitionModel.isPaid = true : widget.transitionModel.isPaid = false;
                                                      dueAmountController.text.toDouble() <= 0
                                                          ? widget.transitionModel.dueAmount = 0
                                                          : widget.transitionModel.dueAmount = double.parse(dueAmountController.text);
                                                      changeAmountController.text.toDouble() > 0
                                                          ? widget.transitionModel.returnAmount = changeAmountController.text.toDouble().abs()
                                                          : widget.transitionModel.returnAmount = 0;
                                                      widget.transitionModel.totalAmount = widget.transitionModel.totalAmount!.toDouble().toDouble();
                                                      widget.transitionModel.paymentType = selectedPaymentOption;
                                                      widget.transitionModel.sellerName = isSubUser ? constSubUserTitle : 'Admin';

                                                      ///__________total LossProfit & quantity________________________________________________________________
                                                      SaleTransactionModel post = checkLossProfit(transitionModel: widget.transitionModel);

                                                      ///_________Push_on_dataBase____________________________________________________________________________
                                                      await ref.push().set(post.toJson());

                                                      ///_________Push_on_Quotation to Sale history____________________________________________________________________________
                                                      widget.isFromQuotation ? await ref1.push().set(post.toJson()) : null;

                                                      ///__________StockMange_________________________________________________________________________________
                                                      final stockRef = FirebaseDatabase.instance.ref('${await getUserID()}/Products/');

                                                      for (var element in widget.transitionModel.productList!) {
                                                        var data = await stockRef.orderByChild('productCode').equalTo(element.productId).once();
                                                        final data2 = jsonDecode(jsonEncode(data.snapshot.value));
                                                        String productPath = data.snapshot.value.toString().substring(1, 21);

                                                        var data1 = await stockRef.child('$productPath/productStock').once();
                                                        int stock = int.parse(data1.snapshot.value.toString());
                                                        int remainStock = stock - element.quantity;

                                                        stockRef.child(productPath).update({'productStock': '$remainStock'});

                                                        ///________Update_Serial_Number____________________________________________________

                                                        if (element.serialNumber!.isNotEmpty) {
                                                          var productOldSerialList = data2[productPath]['serialNumber'];

                                                          List<dynamic> result = productOldSerialList.where((item) => !element.serialNumber!.contains(item)).toList();
                                                          stockRef.child(productPath).update({
                                                            'serialNumber': result.map((e) => e).toList(),
                                                          });
                                                        }
                                                      }

                                                      ///_________Invoice Increase____________________________________________________________________________
                                                      widget.isFromQuotation
                                                          ? null
                                                          : updateInvoice(typeOfInvoice: 'saleInvoiceCounter', invoice: widget.transitionModel.invoiceNumber.toInt());

                                                      ///_________delete_quotation___________________________________________________________________________________

                                                      widget.isFromQuotation ? deleteQuotation(date: widget.transitionModel.purchaseDate, updateRef: consumerRef) : null;

                                                      ///________Subscription______________________________________________________________________________

                                                      Subscription.decreaseSubscriptionLimits(itemType: 'saleNumber', context: context);

                                                      ///________daily_transactionModel_________________________________________________________________________

                                                      DailyTransactionModel dailyTransaction = DailyTransactionModel(
                                                        name: post.customerName,
                                                        date: post.purchaseDate,
                                                        type: 'Sale',
                                                        total: post.totalAmount!.toDouble(),
                                                        paymentIn: post.totalAmount!.toDouble() - post.dueAmount!.toDouble(),
                                                        paymentOut: 0,
                                                        remainingBalance: post.totalAmount!.toDouble() - post.dueAmount!.toDouble(),
                                                        id: post.invoiceNumber,
                                                        saleTransactionModel: post,
                                                      );
                                                      postDailyTransaction(dailyTransactionModel: dailyTransaction);

                                                      ///_________DueUpdate___________________________________________________________________________________
                                                      if (widget.transitionModel.customerName != 'Guest') {
                                                        final dueUpdateRef = FirebaseDatabase.instance.ref('${await getUserID()}/Customers/');
                                                        String? key;

                                                        await FirebaseDatabase.instance.ref(await getUserID()).child('Customers').orderByKey().get().then((value) {
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
                                                      await GeneratePdfAndPrint().printSaleInvoice(
                                                          personalInformationModel: data,
                                                          saleTransactionModel: widget.transitionModel,
                                                          context: widget.isFromQuotation ? null : context);

                                                      widget.isFromQuotation ? Navigator.pop(context) : null;
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
                                            '${widget.transitionModel.productList?.length}',
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

                                    ///__________CGST__________________________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).csgst,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency${widget.transitionModel.cgst}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///__________SGST__________________________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).sgst,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency${widget.transitionModel.sgst}',
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///__________IGST__________________________________________________________
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhiteTextColor,
                                        border: Border.all(color: kLitGreyColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).igst,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency${widget.transitionModel.igst}',
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
                                            lang.S.of(context).serviceorshiping,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$currency${widget.transitionModel.serviceCharge}',
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
                                            '$currency${widget.transitionModel.discountAmount}',
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
}
