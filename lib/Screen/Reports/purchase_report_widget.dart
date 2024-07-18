import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../currency.dart';
import '../PDF/pdfs.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/no_data_found.dart';

class PurchaseReportWidget extends StatefulWidget {
  const PurchaseReportWidget({Key? key, required this.search}) : super(key: key);

  final String search;

  @override
  State<PurchaseReportWidget> createState() => _PurchaseReportWidgetState();
}

class _PurchaseReportWidgetState extends State<PurchaseReportWidget> {
  double calculateTotalPurchase(List<dynamic> purchaseTransitionModel) {
    double total = 0.0;
    for (var element in purchaseTransitionModel) {
      total += element.totalAmount!;
    }
    return total;
  }

  double calculateTotalDue(List<dynamic> purchaseTransitionModel) {
    double total = 0.0;
    for (var element in purchaseTransitionModel) {
      total += element.dueAmount!;
    }
    return total;
  }

  ScrollController listScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      //AsyncValue<List<PurchaseTransitionModel>> purchaseReport = ref.watch(purchaseTransitionProvider);
      final purchaseReports = ref.watch(purchaseTransitionProvider);
      return purchaseReports.when(data: (purchaseReport) {
        final reTransaction = purchaseReport.reversed.toList();
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
                                purchaseReport.length.toString(),
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
                                '$currency${calculateTotalDue(purchaseReport).toString()}',
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
                            color: const Color(0xFFFED3D3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$currency${calculateTotalPurchase(purchaseReport).toString()}',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              Text(
                                lang.S.of(context).totalAmount,
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
                          lang.S.of(context).TRANSACTION,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                          child: Text(
                            lang.S.of(context).addPurchase,
                            style: kTextStyle.copyWith(color: kWhiteTextColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const ExportButton().visible(false),

                    ///________sate_list_________________________________________________________
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
                                                  reTransaction[index].totalAmount.toString(),
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Due____________________________________________________

                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  reTransaction[index].dueAmount.toString(),
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
                                                        onTap: () {
                                                          GeneratePdfAndPrint()
                                                              .printPurchaseInvoice(personalInformationModel: profile.value!, purchaseTransactionModel: reTransaction[index]);
                                                          // PurchaseInvoice(
                                                          //   isPurchase: false,
                                                          //   personalInformationModel: profile.value!,
                                                          //   transitionModel: reTransaction[index],
                                                          // ).launch(context);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            const Icon(FeatherIcons.printer, size: 18.0, color: kTitleColor),
                                                            const SizedBox(width: 4.0),
                                                            Text(
                                                              lang.S.of(context).print,
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
