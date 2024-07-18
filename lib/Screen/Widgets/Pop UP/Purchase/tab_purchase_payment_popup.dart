// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../../Provider/customer_provider.dart';
import '../../../../Provider/due_transaction_provider.dart';
import '../../../../Provider/product_provider.dart';
import '../../../../Provider/profile_provider.dart';
import '../../../../Provider/transactions_provider.dart';
import '../../../../constant.dart';
import '../../../../currency.dart';
import '../../../../model/product_model.dart';
import '../../../../model/transition_model.dart';
import '../../Constant Data/constant.dart';

class TabPurchaseShowPaymentPopUp extends StatefulWidget {
  const TabPurchaseShowPaymentPopUp({Key? key, required this.transitionModel}) : super(key: key);
  final PurchaseTransactionModel transitionModel;

  @override
  State<TabPurchaseShowPaymentPopUp> createState() => _TabPurchaseShowPaymentPopUpState();
}

class _TabPurchaseShowPaymentPopUpState extends State<TabPurchaseShowPaymentPopUp> {
  List<ProductModel> cartList = [];

  String getTotalAmount() {
    double total = 0.0;
    for (var item in widget.transitionModel.productList!) {
      total = total + (double.parse(item.productPurchasePrice) * item.productStock.toInt());
    }
    return total.toString();
  }

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

  double dueAmount = 0.0;
  double returnAmount = 0.0;

  TextEditingController payingAmountController = TextEditingController();
  TextEditingController changeAmountController = TextEditingController();
  TextEditingController dueAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, consumerRef, __) {
        final personalData = consumerRef.watch(profileDetailsProvider);
        return personalData.when(data: (data) {
          return Column(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                                width: 400,
                                child: AppTextField(
                                  controller: payingAmountController,
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      double paidAmount = double.parse(value);
                                      if (paidAmount > getTotalAmount().toDouble()) {
                                        changeAmountController.text = (paidAmount - getTotalAmount().toDouble()).toString();
                                        dueAmountController.text = '0';
                                      } else {
                                        dueAmountController.text = (getTotalAmount().toDouble() - paidAmount).abs().toString();
                                        changeAmountController.text = '0';
                                      }
                                    });
                                  },
                                  showCursor: true,
                                  cursorColor: kTitleColor,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: kInputDecoration.copyWith(
                                    hintText: lang.S.of(context).enterAmount,
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
                                width: 400,
                                child: AppTextField(
                                  controller: changeAmountController,
                                  showCursor: true,
                                  cursorColor: kTitleColor,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: kInputDecoration.copyWith(
                                    hintText: 'Changeable Amount',
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
                                width: 400,
                                child: AppTextField(
                                  controller: dueAmountController,
                                  showCursor: true,
                                  cursorColor: kTitleColor,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: kInputDecoration.copyWith(
                                    hintText: lang.S.of(context).dueamountWillshowHere,
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
                                width: 400,
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
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: 700,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              cursorColor: kTitleColor,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                ),
                                contentPadding: EdgeInsets.all(7.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: kWhiteTextColor,
                        border: Border.all(color: kLitGreyColor),
                      ),
                      child: Column(
                        children: [
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
                                  '0.00',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
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
                                  '0.00',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
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
                                  '$currency ${getTotalAmount()}',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                        ],
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
                            if (widget.transitionModel.customerType == "Guest" && dueAmountController.text.toDouble() > 0) {
                              EasyLoading.showError('Due is not available Foe Guest');
                            } else {
                              try {
                                EasyLoading.show(status: 'Loading...', dismissOnTap: false);

                                DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Purchase Transition");

                                dueAmount <= 0 ? widget.transitionModel.isPaid = true : widget.transitionModel.isPaid = false;
                                dueAmount <= 0 ? widget.transitionModel.dueAmount = 0 : widget.transitionModel.dueAmount = dueAmount;
                                returnAmount < 0 ? widget.transitionModel.returnAmount = returnAmount.abs() : widget.transitionModel.returnAmount = 0;
                                widget.transitionModel.discountAmount = 0.0;
                                widget.transitionModel.totalAmount = getTotalAmount().toDouble();
                                widget.transitionModel.paymentType = selectedPaymentOption;

                                await ref.push().set(widget.transitionModel.toJson());

                                ///__________StockMange_________________________________________________-

                                for (var element in widget.transitionModel.productList!) {
                                  increaseStock(productCode: element.productCode, productModel: element);
                                }

                                ///_________Invoice Increase______________________________________________________
                                updateInvoice(typeOfInvoice: 'purchaseInvoiceCounter', invoice: widget.transitionModel.invoiceNumber.toInt());

                                ///_________DueUpdate______________________________________________________
                                getSpecificCustomers(phoneNumber: widget.transitionModel.customerPhone, due: dueAmount.toInt());

                                ///________Print_______________________________________________________
                                consumerRef.refresh(buyerCustomerProvider);
                                consumerRef.refresh(transitionProvider);
                                consumerRef.refresh(productProvider);
                                consumerRef.refresh(purchaseTransitionProvider);
                                consumerRef.refresh(dueTransactionProvider);
                                consumerRef.refresh(profileDetailsProvider);
                                // ignore: use_build_context_synchronously
                                finish(context);
                                EasyLoading.showSuccess('Added Successfully');
                                // TabletPurchaseInvoice(transitionModel: widget.transitionModel, personalInformationModel: data, isTabPurchase: true,).launch(context);
                              } catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
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

  void increaseStock({required String productCode, required ProductModel productModel}) async {
    final ref = FirebaseDatabase.instance.ref('$constUserId/Products/');

    var data = await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock + productModel.productStock.toInt();

    ref.child(productPath).update({
      'productSalePrice': productModel.productSalePrice,
      'productPurchasePrice': productModel.productPurchasePrice,
      'productWholeSalePrice': productModel.productWholeSalePrice,
      'productDealerPrice': productModel.productDealerPrice,
      'productStock': '$remainStock',
    });
  }
}
