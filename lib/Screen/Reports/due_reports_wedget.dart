import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/due_transaction_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../../model/due_transaction_model.dart';
import '../PDF/pdfs.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/no_data_found.dart';

class DueReportWidget extends StatefulWidget {
  const DueReportWidget({Key? key, required this.search}) : super(key: key);

  final String search;

  @override
  State<DueReportWidget> createState() => _DueReportWidgetState();
}

class _DueReportWidgetState extends State<DueReportWidget> {
  double calculatePayableAmount(List<DueTransactionModel> dueTransactionModel) {
    double total = 0.0;
    for (var element in dueTransactionModel) {
      total += element.totalDue!;
    }
    return total;
  }

  double calculateDueAmount(List<DueTransactionModel> dueTransactionModel) {
    double total = 0.0;
    for (var element in dueTransactionModel) {
      total += element.dueAmountAfterPay!;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      final dueReport = ref.watch(dueTransactionProvider);
      return dueReport.when(data: (dueReport) {
        final reTransaction = dueReport.reversed.toList();
        final profile = ref.watch(profileDetailsProvider);
        return Expanded(
          flex: 4,
          child: Column(
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
                                dueReport.length.toString(),
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              Text(
                                lang.S.of(context).totalCollected,
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
                                '$currency${calculateDueAmount(dueReport).toString()}',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              Text(
                                lang.S.of(context).due,
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
                                '${currency}${calculatePayableAmount(dueReport).toString()}',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              Text(
                                lang.S.of(context).totalRecive,
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
                    Row(
                      children: [
                        Text(
                          lang.S.of(context).dueTransaction,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                          child: Text(
                            lang.S.of(context).addDue,
                            style: kTextStyle.copyWith(color: kWhiteTextColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const ExportButton().visible(false),
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
                                    const SizedBox(width: 35, child: Text('S.L')),
                                    SizedBox(width: 75, child: Text(lang.S.of(context).date)),
                                    SizedBox(width: 50, child: Text(lang.S.of(context).invoice)),
                                    SizedBox(width: 100, child: Text(lang.S.of(context).partyName)),
                                    SizedBox(width: 95, child: Text(lang.S.of(context).paymentType)),
                                    SizedBox(width: 70, child: Text(lang.S.of(context).amount)),
                                    SizedBox(width: 60, child: Text(lang.S.of(context).due)),
                                    SizedBox(width: 50, child: Text(lang.S.of(context).status)),
                                    const SizedBox(width: 30, child: Icon(FeatherIcons.settings)),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reTransaction.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Visibility(
                                    visible: reTransaction[index].customerName.toLowerCase().contains(widget.search.toLowerCase()) ||
                                        reTransaction[index].invoiceNumber.toLowerCase().contains(widget.search.toLowerCase()),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///______________S.L__________________________________________________
                                              SizedBox(
                                                width: 40,
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
                                                width: 100,
                                                child: Text(
                                                  reTransaction[index].customerName,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Party Type______________________________________________

                                              SizedBox(
                                                width: 95,
                                                child: Text(
                                                  reTransaction[index].paymentType.toString(),
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Amount____________________________________________________
                                              SizedBox(
                                                width: 70,
                                                child: Text(
                                                  reTransaction[index].totalDue.toString(),
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Due____________________________________________________

                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  reTransaction[index].dueAmountAfterPay.toString(),
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Due____________________________________________________

                                              SizedBox(
                                                width: 50,
                                                child: Text(
                                                  reTransaction[index].isPaid! ? 'Paid' : "Due",
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///_______________actions_________________________________________________
                                              SizedBox(
                                                width: 30,
                                                child: PopupMenuButton(
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (BuildContext bc) => [
                                                    PopupMenuItem(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await GeneratePdfAndPrint()
                                                              .printDueInvoice(personalInformationModel: profile.value!, dueTransactionModel: reTransaction[index]);
                                                          // DueInvoice(
                                                          //   dueTransactionModel: reTransaction[index],
                                                          //   personalInformationModel: profile.value!,
                                                          // ).launch(context);
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
                                                  child: Center(
                                                    child: Container(
                                                        height: 18,
                                                        width: 18,
                                                        alignment: Alignment.centerRight,
                                                        child: const Icon(
                                                          Icons.more_vert_sharp,
                                                          size: 18,
                                                        )),
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
                        : noDataFoundImage(text: 'No Report Found'),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: DataTable(
                    //     headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                    //     showBottomBorder: false,
                    //     columnSpacing: 0.0,
                    //     columns: [
                    //       DataColumn(
                    //         label: Text(
                    //           'S.L',
                    //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       DataColumn(
                    //         label: Text('Date', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    //       ),
                    //       DataColumn(
                    //         label: Text(
                    //           'Invoice',
                    //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       DataColumn(
                    //         label: Text('Name', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    //       ),
                    //       DataColumn(
                    //         label: Text('Payment Type', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    //       ),
                    //       DataColumn(
                    //         label: Text('Payable', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    //       ),
                    //       DataColumn(
                    //         label: Text('Paid', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    //       ),
                    //       DataColumn(
                    //         label: Text('Due', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    //       ),
                    //       DataColumn(
                    //         label: Text('Status', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    //       ),
                    //       const DataColumn(
                    //         label: Icon(FeatherIcons.settings, color: kGreyTextColor),
                    //       ),
                    //     ],
                    //     rows: List.generate(
                    //       reTransaction.length,
                    //       (index) => DataRow(cells: [
                    //         DataCell(
                    //           Text((index + 1).toString()),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].purchaseDate.substring(0, 10), style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].invoiceNumber, style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].customerName, style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].paymentType.toString(), style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].totalDue.toString(), style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].payDueAmount.toString(), style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].dueAmountAfterPay.toString(), style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           GestureDetector(
                    //               onTap: () {
                    //                 DueInvoice(
                    //                   dueTransactionModel: reTransaction[index],
                    //                   personalInformationModel: profile.value!,
                    //                 ).launch(context);
                    //               },
                    //               child: Text(reTransaction[index].isPaid! ? 'Fully Paid' : "Still Unpaid",
                    //                   style: kTextStyle.copyWith(color: kGreyTextColor))),
                    //         ),
                    //         DataCell(
                    //           PopupMenuButton(
                    //             icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                    //             padding: EdgeInsets.zero,
                    //             itemBuilder: (BuildContext bc) => [
                    //               PopupMenuItem(
                    //                 child: GestureDetector(
                    //                   onTap: () {
                    //                     DueInvoice(
                    //                       dueTransactionModel: reTransaction[index],
                    //                       personalInformationModel: profile.value!,
                    //                     ).launch(context);
                    //                   },
                    //                   child: Row(
                    //                     children: [
                    //                       const Icon(MdiIcons.printer, size: 18.0, color: kTitleColor),
                    //                       const SizedBox(width: 4.0),
                    //                       Text(
                    //                         'Print',
                    //                         style: kTextStyle.copyWith(color: kTitleColor),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //             onSelected: (value) {
                    //               Navigator.pushNamed(context, '$value');
                    //             },
                    //           ),
                    //         ),
                    //       ]),
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
      });
    });
  }
}
