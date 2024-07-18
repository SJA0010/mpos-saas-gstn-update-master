import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';
import '../../model/transition_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

class LossProfitScreen extends StatefulWidget {
  const LossProfitScreen({
    Key? key,
  }) : super(key: key);

  static const String route = '/Loss_Profit';

  @override
  State<LossProfitScreen> createState() => _LossProfitScreenState();
}

class _LossProfitScreenState extends State<LossProfitScreen> {
  void getSearchProduct() {
    setState(() {
      searchItems;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // voidLink(context: context);
    searchItems = '';
  }

  void showLossProfitDetails({required SaleTransactionModel transitionModel}) {
    double profit({required AddToCartModel productModel}) {
      return (double.parse(productModel.subTotal.toString()) - double.parse(productModel.productPurchasePrice.toString())) * productModel.quantity.toDouble();
    }

    double allProductTotalProfit({required SaleTransactionModel transitionModel}) {
      double profit = 0;

      for (var element in transitionModel.productList!) {
        ((double.parse(element.subTotal.toString()) - double.parse(element.productPurchasePrice.toString())) * element.quantity.toDouble()).isNegative
            ? null
            : profit += (double.parse(element.subTotal.toString()) - double.parse(element.productPurchasePrice.toString())) * element.quantity.toDouble();
      }
      return profit;
    }

    double allProductTotalLoss({required SaleTransactionModel transitionModel}) {
      double loss = 0;

      for (var element in transitionModel.productList!) {
        ((double.parse(element.subTotal.toString()) - double.parse(element.productPurchasePrice.toString())) * element.quantity.toDouble()).isNegative
            ? loss += ((double.parse(element.subTotal.toString()) - double.parse(element.productPurchasePrice.toString())) * element.quantity.toDouble()).abs()
            : null;
      }
      return loss;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 820,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Invoice: ${transitionModel.invoiceNumber} - ${transitionModel.customerName}',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              const Spacer(),
                              const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
                            ],
                          ),
                        ),
                        const Divider(thickness: 1.0, color: kLitGreyColor),
                        const SizedBox(height: 10.0),
                        DataTable(
                          headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                          showBottomBorder: false,
                          columnSpacing: 0.0,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black26),
                            // borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                          ),
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: 250,
                                child: Text(
                                  lang.S.of(context).itemName,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(lang.S.of(context).quantity, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  lang.S.of(context).purchasePrice,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  lang.S.of(context).salePrice,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  lang.S.of(context).profit,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(width: 100, child: Text('Loss', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold))),
                            ),
                          ],
                          rows: List.generate(
                            transitionModel.productList!.length + 1,
                            (index) => DataRow(cells: [
                              DataCell(
                                index == transitionModel.productList!.length
                                    ? const Text(
                                        'Total',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      )
                                    : Text(transitionModel.productList![index].productName.toString(),
                                        maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                              ),
                              DataCell(
                                index == transitionModel.productList!.length
                                    ? Text(transitionModel.totalQuantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold))
                                    : Text(transitionModel.productList![index].quantity.toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                              ),
                              DataCell(
                                index == transitionModel.productList!.length
                                    ? const Text('')
                                    : Text(transitionModel.productList![index].productPurchasePrice.toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                              ),
                              DataCell(
                                index == transitionModel.productList!.length
                                    ? const Text('')
                                    : Text(transitionModel.productList![index].subTotal.toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                              ),
                              DataCell(
                                index == transitionModel.productList!.length
                                    ? Text('${allProductTotalProfit(transitionModel: transitionModel)}', style: const TextStyle(fontWeight: FontWeight.bold))
                                    : Text(
                                        profit(productModel: transitionModel.productList![index]).isNegative
                                            ? ''
                                            : profit(productModel: transitionModel.productList![index]).toString(),
                                        style: kTextStyle.copyWith(color: kGreyTextColor)),
                              ),
                              DataCell(
                                index == transitionModel.productList!.length
                                    ? Text('${allProductTotalLoss(transitionModel: transitionModel)}', style: const TextStyle(fontWeight: FontWeight.bold))
                                    : Text(
                                        profit(productModel: transitionModel.productList![index]).isNegative
                                            ? profit(productModel: transitionModel.productList![index]).abs().toString()
                                            : '',
                                        style: kTextStyle.copyWith(color: kGreyTextColor)),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang.S.of(context).toalProfit),
                            Text(allProductTotalProfit(transitionModel: transitionModel).toString()),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang.S.of(context).totalLoss),
                            Text('- ${allProductTotalLoss(transitionModel: transitionModel)}'),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang.S.of(context).totalDiscount),
                            Text('- ${transitionModel.discountAmount}'),
                          ],
                        ),
                        const Divider(thickness: 1.0, color: kLitGreyColor),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // border: Border.all(width: 1, color: Colors.green),
                            color: transitionModel.lossProfit!.isNegative ? Colors.redAccent.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  transitionModel.lossProfit!.isNegative ? 'Total Loss' : 'Total Profit',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  transitionModel.lossProfit!.abs().toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )
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

  double calculateTotalProfit(List<SaleTransactionModel> transitionModel) {
    double total = 0.0;
    for (var element in transitionModel) {
      element.lossProfit!.isNegative ? null : total += element.lossProfit!;
    }
    return total;
  }

  double getTotalDue(List<SaleTransactionModel> transitionModel) {
    double total = 0.0;
    for (var element in transitionModel) {
      total += element.dueAmount!;
    }
    return total;
  }

  double calculateTotalSale(List<SaleTransactionModel> transitionModel) {
    double total = 0.0;
    for (var element in transitionModel) {
      total += element.totalAmount!;
    }
    return total;
  }

  double calculateTotalLoss(List<SaleTransactionModel> transitionModel) {
    double total = 0.0;
    for (var element in transitionModel) {
      element.lossProfit!.isNegative ? total += element.lossProfit! : null;
    }
    return total.abs();
  }

  ScrollController mainScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkWhite,
        body: Scrollbar(
          controller: mainScroll,
          child: SingleChildScrollView(
            controller: mainScroll,
            scrollDirection: Axis.horizontal,
            child: Consumer(builder: (_, ref, watch) {
              AsyncValue<List<SaleTransactionModel>> transactionReport = ref.watch(transitionProvider);
              return transactionReport.when(data: (transaction) {
                final reTransaction = transaction.reversed.toList();
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 240,
                      child: SideBarWidget(
                        index: 8,
                        isTab: false,
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
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kWhiteTextColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFFCFF4E3),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                transaction.length.toString(),
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(
                                                lang.S.of(context).totalSales,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFFFEE7CB),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$currency${getTotalDue(transaction).toString()}',
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(
                                                lang.S.of(context).unpaid,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFF2DB0F6).withOpacity(0.5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$currency${calculateTotalSale(transaction).toString()}',
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(
                                                lang.S.of(context).totalAmount,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFF15CD75).withOpacity(0.5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$currency${calculateTotalProfit(transaction).toString()}',
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(
                                                lang.S.of(context).toalProfit,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFFFF2525).withOpacity(.5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$currency${calculateTotalLoss(transaction).toString()}',
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(
                                                lang.S.of(context).totalLoss,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kWhiteTextColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.S.of(context).lossProfit,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20.0),
                                    reTransaction.isNotEmpty
                                        ? Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(15),
                                                decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const SizedBox(width: 50, child: Text('S.L')),
                                                    SizedBox(width: 75, child: Text(lang.S.of(context).date)),
                                                    SizedBox(width: 50, child: Text(lang.S.of(context).invoice)),
                                                    SizedBox(width: 150, child: Text(lang.S.of(context).partyName)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).saleAmont)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).payAmont)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).dueAmonunt)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).profitplus)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).lossminus)),
                                                    SizedBox(width: 70, child: Text(lang.S.of(context).action)),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: reTransaction.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Visibility(
                                                    visible: reTransaction[index].customerName.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase()) ||
                                                        reTransaction[index].invoiceNumber.removeAllWhiteSpace().toLowerCase().contains(searchItems.toLowerCase()),
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
                                                                width: 150,
                                                                child: Text(
                                                                  reTransaction[index].customerName,
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Sale Amount____________________________________________________
                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  reTransaction[index].totalAmount.toString(),
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________PayAmount____________________________________________________

                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  (reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble()).toString(),
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________DueAmount____________________________________________________

                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  reTransaction[index].dueAmount.toString(),
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Profit____________________________________________________

                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  reTransaction[index].lossProfit!.isNegative ? '' : reTransaction[index].lossProfit.toString(),
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///___________Loss____________________________________________________

                                                              SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  reTransaction[index].lossProfit!.isNegative ? reTransaction[index].lossProfit.toString() : '',
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),

                                                              ///_______________Action_________________________________________________
                                                              SizedBox(
                                                                width: 70,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    showLossProfitDetails(transitionModel: reTransaction[index]);
                                                                  },
                                                                  child: const Text(
                                                                    'Show >',
                                                                    style: TextStyle(color: Colors.blue),
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
                                                  lang.S.of(context).noTransactionFound,
                                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                ),
                                                const SizedBox(height: 20),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
        ));
  }
}
