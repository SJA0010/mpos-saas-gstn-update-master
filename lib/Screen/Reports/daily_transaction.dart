import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/daily_transaction_provider.dart';
import 'package:salespro_admin/model/daily_transaction_model.dart';
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../Expenses/expense_details.dart';
import '../Income/income_details.dart';
import '../PDF/pdfs.dart';
import '../Widgets/Constant Data/constant.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/no_data_found.dart';

class DailyTransaction extends StatefulWidget {
  const DailyTransaction({Key? key}) : super(key: key);

  @override
  State<DailyTransaction> createState() => _DailyTransactionState();
}

class _DailyTransactionState extends State<DailyTransaction> {
  double calculateTotalPaymentIn(List<DailyTransactionModel> dailyTransaction) {
    double total = 0.0;
    for (var element in dailyTransaction) {
      total += double.parse(element.paymentIn.toString());
    }
    return total;
  }

  double calculateTotalPaymentOut(List<DailyTransactionModel> dailyTransaction) {
    double total = 0.0;
    for (var element in dailyTransaction) {
      total += double.parse(element.paymentOut.toString());
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      final dailyTransactionReport = ref.watch(dailyTransactionProvider);
      final profile = ref.watch(profileDetailsProvider);

      return dailyTransactionReport.when(data: (dailyReport) {
        final reTransaction = dailyReport.reversed.toList();
        return Expanded(
          flex: 4,
          child: reTransaction.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: kWhiteTextColor,
                      ),
                      child: Column(
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
                                      reTransaction.first.remainingBalance.toString(),
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    Text(
                                      lang.S.of(context).remainingBalance,
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
                                  color: const Color(0xFFFED3D3),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$currency${calculateTotalPaymentOut(reTransaction).toString()}',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    Text(
                                      lang.S.of(context).totalPaymentOut,
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
                                      '$currency${calculateTotalPaymentIn(reTransaction).toString()}',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    Text(
                                      lang.S.of(context).totalPaymentIn,
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
                    const SizedBox(height: 20.0),
                    Container(
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
                            lang.S.of(context).dailyTransantion,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const ExportButton().visible(false),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                              showBottomBorder: false,
                              columnSpacing: 0.0,
                              columns: [
                                DataColumn(
                                  label: Text(lang.S.of(context).name, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).date, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).type, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: Text(lang.S.of(context).total, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: Text(lang.S.of(context).paymentIn, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: Text(lang.S.of(context).paymentout, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: Text(lang.S.of(context).balance, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: Text(lang.S.of(context).action, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                              rows: List.generate(
                                reTransaction.length,
                                (index) => DataRow(cells: [
                                  DataCell(
                                    Text(reTransaction[index].name, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                  ),
                                  DataCell(
                                    Text(reTransaction[index].date.substring(0, 10), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                  ),
                                  DataCell(
                                    Text(reTransaction[index].type, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                  ),
                                  DataCell(
                                    Text(reTransaction[index].total.toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                  ),
                                  DataCell(
                                    Text(reTransaction[index].paymentIn.toString() == '0' ? '' : reTransaction[index].paymentIn.toString(),
                                        style: kTextStyle.copyWith(color: Colors.green)),
                                  ),
                                  DataCell(
                                    Text(reTransaction[index].paymentOut.toString() == '0' ? '' : reTransaction[index].paymentOut.toString(),
                                        style: kTextStyle.copyWith(color: Colors.red)),
                                  ),
                                  DataCell(
                                    Text(reTransaction[index].remainingBalance.toString()),
                                  ),
                                  DataCell(
                                    PopupMenuButton(
                                      icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (BuildContext bc) => [
                                        PopupMenuItem(
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (reTransaction[index].type == 'Sale') {
                                                await GeneratePdfAndPrint()
                                                    .printSaleInvoice(personalInformationModel: profile.value!, saleTransactionModel: reTransaction[index].saleTransactionModel!);
                                                // SaleInvoice(
                                                //   transitionModel: reTransaction[index].saleTransactionModel!,
                                                //   personalInformationModel: profile.value!,
                                                //   isPosScreen: false,
                                                // ).launch(context);
                                              } else if (reTransaction[index].type == 'Purchase') {
                                                GeneratePdfAndPrint().printPurchaseInvoice(
                                                    personalInformationModel: profile.value!, purchaseTransactionModel: reTransaction[index].purchaseTransactionModel!);
                                                // PurchaseInvoice(
                                                //   transitionModel: reTransaction[index].purchaseTransactionModel!,
                                                //   personalInformationModel: profile.value!,
                                                //   isPurchase: false,
                                                // ).launch(context);
                                              } else if (reTransaction[index].type == 'Due Collection' || reTransaction[index].type == 'Due Payment') {
                                                await GeneratePdfAndPrint()
                                                    .printDueInvoice(personalInformationModel: profile.value!, dueTransactionModel: reTransaction[index].dueTransactionModel!);
                                                // DueInvoice(
                                                //   dueTransactionModel: reTransaction[index].dueTransactionModel!,
                                                //   personalInformationModel: profile.value!,
                                                // ).launch(context);
                                              } else if (reTransaction[index].type == 'Expense') {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StatefulBuilder(
                                                      builder: (context, setStates) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                          child: ExpenseDetails(expense: reTransaction[index].expenseModel!, manuContext: bc),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              } else if (reTransaction[index].type == 'Income') {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StatefulBuilder(
                                                      builder: (context, setStates) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                          child: IncomeDetails(income: reTransaction[index].incomeModel!, manuContext: bc),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(FeatherIcons.printer, size: 18.0, color: kTitleColor),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  'Print',
                                                  style: kTextStyle.copyWith(color: kTitleColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        Navigator.pushNamed(context, '$value');
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.white),
                  child: noDataFoundImage(text: lang.S.of(context).noTransactionFound),
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
    });
  }
}
