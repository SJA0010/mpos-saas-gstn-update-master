// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:typed_data';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:salespro_admin/model/personal_information_model.dart';
import '../../model/due_transaction_model.dart';
import '../../model/transition_model.dart';
import '../POS Sale/pos_sale.dart';
import '../Purchase/purchase.dart';

class GeneratePdfAndPrint {
  Future<pw.Widget> getImageFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final image = pw.MemoryImage(
      Uint8List.fromList(bytes),
    );

    return pw.Container(child: pw.Image(image));
  }

  Future<void> printSaleInvoice({required PersonalInformationModel personalInformationModel, required SaleTransactionModel saleTransactionModel, BuildContext? context}) async {
    await Printing.layoutPdf(
      dynamicLayout: true,
      onLayout: (PdfPageFormat format) async =>
          await GeneratePdfAndPrint().generateSaleDocumentClint(personalInformation: personalInformationModel, transactions: saleTransactionModel),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      context != null ? const PosSale().launch(context, isNewTask: true) : null;
    });
  }

  Future<void> printQuotationInvoice(
      {required PersonalInformationModel personalInformationModel, required SaleTransactionModel saleTransactionModel, BuildContext? context}) async {
    await Printing.layoutPdf(
      dynamicLayout: true,
      onLayout: (PdfPageFormat format) async =>
          await GeneratePdfAndPrint().generateSaleQuotationDocumentClint(personalInformation: personalInformationModel, transactions: saleTransactionModel),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      context != null ? const PosSale().launch(context, isNewTask: true) : null;
    });
  }

  Future<void> printPurchaseInvoice(
      {required PersonalInformationModel personalInformationModel, required PurchaseTransactionModel purchaseTransactionModel, BuildContext? context}) async {
    await Printing.layoutPdf(
      dynamicLayout: true,
      onLayout: (PdfPageFormat format) async =>
          await GeneratePdfAndPrint().generatePurchaseDocumentClint(personalInformation: personalInformationModel, transactions: purchaseTransactionModel),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      context != null ? const Purchase().launch(context, isNewTask: true) : null;
    });
  }

  Future<void> printDueInvoice({required PersonalInformationModel personalInformationModel, required DueTransactionModel dueTransactionModel, BuildContext? context}) async {
    await Printing.layoutPdf(
      dynamicLayout: true,
      onLayout: (PdfPageFormat format) async => await GeneratePdfAndPrint().generateDueDocument(personalInformation: personalInformationModel, transactions: dueTransactionModel),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      context != null ? const PosSale().launch(context, isNewTask: true) : null;
    });
  }

  FutureOr<Uint8List> generatePurchaseDocument({required PurchaseTransactionModel transactions, required PersonalInformationModel personalInformation}) async {
    final pw.Document doc = pw.Document();
    final netImage = await networkImage(
      'https://www.nfet.net/nfet.jpg',
    );
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                pw.Row(children: [
                  pw.Container(
                    height: 50.0,
                    width: 50.0,
                    alignment: pw.Alignment.centerRight,
                    margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    decoration: pw.BoxDecoration(image: pw.DecorationImage(image: netImage), shape: pw.BoxShape.circle),
                  ),
                  pw.SizedBox(width: 10.0),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      personalInformation.companyName,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Tel: ${personalInformation.phoneNumber!}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
                    ),
                  ]),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 40.0,
                    color: PdfColor.fromHex('#007AD0'),
                    width: 100,
                  ),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.customerPhone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Sells By',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Admin',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Invoice Number',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Date',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: 'D, M j'),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              color: PdfColors.black,
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Center(child: pw.Text('Powered By Acnoo', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
            ),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: pw.Column(children: [
                  pw.Table.fromTextArray(
                      context: context,
                      border: const pw.TableBorder(
                          left: pw.BorderSide(
                            color: PdfColors.black,
                          ),
                          right: pw.BorderSide(
                            color: PdfColors.black,
                          ),
                          bottom: pw.BorderSide(
                            color: PdfColors.black,
                          )),
                      headerDecoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#007AD0'),
                      ),
                      columnWidths: <int, pw.TableColumnWidth>{
                        0: const pw.FlexColumnWidth(1),
                        1: const pw.FlexColumnWidth(6),
                        2: const pw.FlexColumnWidth(2),
                        3: const pw.FlexColumnWidth(2),
                        4: const pw.FlexColumnWidth(2),
                      },
                      headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                      rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                      headerAlignments: <int, pw.Alignment>{
                        0: pw.Alignment.center,
                        1: pw.Alignment.centerLeft,
                        2: pw.Alignment.center,
                        3: pw.Alignment.centerRight,
                        4: pw.Alignment.centerRight,
                      },
                      cellAlignments: <int, pw.Alignment>{
                        0: pw.Alignment.center,
                        1: pw.Alignment.centerLeft,
                        2: pw.Alignment.center,
                        3: pw.Alignment.centerRight,
                        4: pw.Alignment.centerRight,
                      },
                      data: <List<String>>[
                        <String>['SL', 'Item', 'Quantity', 'Unit Price', 'Total Price'],
                        for (int i = 0; i < transactions.productList!.length; i++)
                          <String>[
                            ('${i + 1}'),
                            (transactions.productList!.elementAt(0).productName),
                            (transactions.productList!.elementAt(0).productStock),
                            (transactions.productList!.elementAt(0).productSalePrice),
                            ((transactions.productList!.elementAt(0).productSalePrice.toInt() * transactions.productList!.elementAt(i).productStock.toInt()).toString())
                          ],
                      ]),
                  pw.Paragraph(text: ""),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                        pw.Text(
                          "Payment Method: ${transactions.paymentType}",
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),
                        pw.SizedBox(height: 10.0),
                        pw.Text(
                          "Amount in Word",
                          style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                        ),
                        // pw.SizedBox(height: 10.0),
                        //
                        // pw.Text(
                        //   NumberToCharacterConverter('en').convertDouble(transactions.totalAmount).toUpperCase(),
                        //   style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                        // ),
                      ]),
                      pw.SizedBox(
                        width: 150.0,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  "Vat:",
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                              pw.Text(
                                '0.00',
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 10.0),
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  "Tax:",
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                              pw.Text(
                                '0.00',
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 10.0),
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  "Due:",
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                              pw.Text(
                                transactions.dueAmount.toString(),
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 10.0),
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  "Discount:",
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                              pw.Text(
                                transactions.discountAmount.toString(),
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 10.0),
                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                              pw.SizedBox(
                                width: 100.0,
                                child: pw.Text(
                                  "Subtotal:",
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                              pw.Text(
                                "${transactions.totalAmount! + transactions.discountAmount!}",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ]),
                            pw.SizedBox(height: 10.0),
                            pw.Container(
                              color: PdfColor.fromHex('#007AD0'),
                              width: 150.0,
                              padding: const pw.EdgeInsets.all(10.0),
                              child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.Padding(padding: const pw.EdgeInsets.all(10)),
                ]),
              ),
            ]));
    // doc.addPage(pw.MultiPage(
    //     pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
    //     margin: pw.EdgeInsets.zero,
    //     crossAxisAlignment: pw.CrossAxisAlignment.start,
    //     header: (pw.Context context) {
    //       return pw.Padding(
    //         padding: const pw.EdgeInsets.all(20.0),
    //         child: pw.Column(
    //           children: [
    //             pw.Row(children: [
    //               pw.Container(
    //                 height: 50.0,
    //                 width: 50.0,
    //                 alignment: pw.Alignment.centerRight,
    //                 margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
    //                 padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
    //                 decoration: pw.BoxDecoration(image: pw.DecorationImage(image: netImage), shape: pw.BoxShape.circle),
    //               ),
    //               pw.SizedBox(width: 10.0),
    //               pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
    //                 pw.Text(
    //                   personalInformation.companyName!,
    //                   style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
    //                 ),
    //                 pw.Text(
    //                   'House/Road/Building No, City, Area, State, Country - Zip',
    //                   style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                 ),
    //                 pw.Text(
    //                   'Tel: ${personalInformation.phoneNumber!}',
    //                   style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
    //                 ),
    //               ]),
    //             ]),
    //             pw.SizedBox(height: 30.0),
    //             pw.Text('Invoice/Bill', style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, fontSize: 25.0)),
    //             pw.SizedBox(height: 30.0),
    //             pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
    //               pw.Column(children: [
    //                 pw.Row(children: [
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       'Sells By',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 10.0,
    //                     child: pw.Text(
    //                       ':',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       'Admin',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                 ]),
    //                 pw.Row(children: [
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       'Bill To',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 10.0,
    //                     child: pw.Text(
    //                       ':',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       transactions.customerName,
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                 ]),
    //                 pw.Row(children: [
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       'Phone',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 10.0,
    //                     child: pw.Text(
    //                       ':',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       transactions.customerPhone,
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                 ]),
    //               ]),
    //               pw.Column(children: [
    //                 pw.Row(children: [
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       'Invoice Number',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 10.0,
    //                     child: pw.Text(
    //                       ':',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       '#${transactions.invoiceNumber}',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                 ]),
    //                 pw.Row(children: [
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       'Date',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 10.0,
    //                     child: pw.Text(
    //                       ':',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: 'D, M j'),
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                 ]),
    //                 pw.Row(children: [
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       'Time',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 10.0,
    //                     child: pw.Text(
    //                       ':',
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                   pw.SizedBox(
    //                     width: 100.0,
    //                     child: pw.Text(
    //                       DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: 'H:i'),
    //                       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                     ),
    //                   ),
    //                 ]),
    //               ]),
    //             ]),
    //           ],
    //         ),
    //       );
    //     },
    //     footer: (pw.Context context) {
    //       return pw.Column(children: [
    //         pw.Padding(
    //           padding: pw.EdgeInsets.all(10.0),
    //           child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
    //             pw.Container(
    //               alignment: pw.Alignment.centerRight,
    //               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
    //               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
    //               child: pw.Column(children: [
    //                 pw.Container(
    //                   width: 120.0,
    //                   height: 2.0,
    //                   color: PdfColors.black,
    //                 ),
    //                 pw.SizedBox(height: 4.0),
    //                 pw.Text(
    //                   'Customer Signature',
    //                   style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                 )
    //               ]),
    //             ),
    //             pw.Container(
    //               alignment: pw.Alignment.centerRight,
    //               margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
    //               padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
    //               child: pw.Column(children: [
    //                 pw.Container(
    //                   width: 120.0,
    //                   height: 2.0,
    //                   color: PdfColors.black,
    //                 ),
    //                 pw.SizedBox(height: 4.0),
    //                 pw.Text(
    //                   'Authorized Signature',
    //                   style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
    //                 )
    //               ]),
    //             ),
    //           ]),
    //         ),
    //         pw.Container(
    //           width: double.infinity,
    //           color: PdfColors.red,
    //           padding: const pw.EdgeInsets.all(10.0),
    //           child: pw.Center(child: pw.Text('Powered By Maan Technology', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
    //         ),
    //       ]);
    //     },
    //     build: (pw.Context context) => <pw.Widget>[
    //           pw.Padding(
    //             padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
    //             child: pw.Column(children: [
    //               pw.Table.fromTextArray(
    //                   context: context,
    //                   border: pw.TableBorder.all(color: PdfColors.black),
    //                   headerDecoration: pw.BoxDecoration(color: PdfColors.red, border: pw.Border.all(color: PdfColors.red)),
    //                   columnWidths: <int, pw.TableColumnWidth>{
    //                     0: const pw.FlexColumnWidth(1),
    //                     1: const pw.FlexColumnWidth(6),
    //                     2: const pw.FlexColumnWidth(2),
    //                     3: const pw.FlexColumnWidth(2),
    //                     4: const pw.FlexColumnWidth(2),
    //                   },
    //                   headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
    //                   rowDecoration: const pw.BoxDecoration(
    //                       border:
    //                           pw.Border(bottom: pw.BorderSide(color: PdfColors.black), left: pw.BorderSide(color: PdfColors.black), right: pw.BorderSide(color: PdfColors.black))),
    //                   headerAlignments: <int, pw.Alignment>{
    //                     0: pw.Alignment.center,
    //                     1: pw.Alignment.centerLeft,
    //                     2: pw.Alignment.center,
    //                     3: pw.Alignment.centerRight,
    //                     4: pw.Alignment.centerRight,
    //                   },
    //                   cellAlignments: <int, pw.Alignment>{
    //                     0: pw.Alignment.center,
    //                     1: pw.Alignment.centerLeft,
    //                     2: pw.Alignment.center,
    //                     3: pw.Alignment.centerRight,
    //                     4: pw.Alignment.centerRight,
    //                   },
    //                   data: <List<String>>[
    //                     <String>['SL', 'Item', 'Quantity', 'Unit Price', 'Total Price'],
    //                     for (int i = 0; i < transactions.productList!.length; i++)
    //                       <String>[
    //                         ('${i + 1}'),
    //                         (transactions.productList!.elementAt(i).productName),
    //                         (transactions.productList!.elementAt(i).productStock),
    //                         (transactions.productList!.elementAt(i).productSalePrice),
    //                         ((transactions.productList!.elementAt(i).productSalePrice.toInt() * transactions.productList!.elementAt(i).productStock.toInt()).toString())
    //                       ],
    //                   ]),
    //               pw.Paragraph(text: ""),
    //               pw.Paragraph(text: "Subtotal: ${transactions.totalAmount}"),
    //               pw.Padding(padding: const pw.EdgeInsets.all(10)),
    //             ]),
    //           ),
    //         ]));

    return doc.save();
  }

  FutureOr<Uint8List> generateSaleDocumentClint({required SaleTransactionModel transactions, required PersonalInformationModel personalInformation}) async {
    EasyLoading.show(status: 'Loading...');
    double basicFontSize = 10;
    final pw.Document doc = pw.Document();
    List<String> list = personalInformation.pictureUrl.split('?');
    final httpsReference = FirebaseStorage.instance.refFromURL(list.first);
    Uint8List? imageBytes = await httpsReference.getData();
    EasyLoading.dismiss();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        ///_______Header__________________________________________________________________
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                // imageWidget,
                ///________Shop_details_and_date__________________________________________________________________________-___________________
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  //________Shop_details__________________________________________________________________
                  pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                    // pw.ClipRRect(
                    //   horizontalRadius: 30,
                    //   child: image.,
                    // ),
                    pw.Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: pw.Alignment.centerRight,
                      margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                      padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                      decoration: pw.BoxDecoration(
                          image: pw.DecorationImage(
                              image: pw.MemoryImage(
                        imageBytes!,
                      ))),
                    ),

                    pw.SizedBox(width: 10.0),
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.Text(
                        personalInformation.companyName.toUpperCase(),
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'ADDRESS: ${personalInformation.address}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        personalInformation.city,
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'GSTIN/UIN: ${personalInformation.gstNo}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'TEL: ${personalInformation.phoneNumber}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'STATE NAME: ${personalInformation.state}, CODE:${personalInformation.zip}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ]),
                  ]),

                  ///__________Date_________________________________________________________________________
                  pw.Text(
                    'DATE: ${transactions.purchaseDate.substring(0, 10)}',
                    // 'Address: ${personalInformation.countryName}',
                    style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                  ),
                ]),
                pw.SizedBox(height: 10.0),

                //_________invoice__________________________________________________________________________________
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                    child: pw.Text(
                      'TAX INVOICE',
                      style: const pw.TextStyle(
                        color: PdfColors.black,
                        // fontWeight: pw.FontWeight.b old,
                        fontSize: 21.0,
                      ),
                    ),
                  ),
                  pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                      width: 120,
                      child: pw.Center(
                          child: pw.Text(
                        'BILL NO: ${transactions.invoiceNumber}',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 13.0,
                        ),
                      ))),
                ]),
                pw.SizedBox(height: 10.0),

                ///________customer details_________________________________________________________________________

                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  ///_______left sec_______________________________________________________
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      'Buyer (Bill to)',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                    ),

                    //__________-Bill_to_____________________________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.Container(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.customerFullName,
                          // transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Address',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.customerAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                    //_____phone__________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.phoneNumber,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    //____GSTIN________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'GSTIN/UIN',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.gstNumber,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///_____State______________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'State Name',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.billingState,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///______email_____________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Email',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          // transactions.customerPhone,
                          transactions.customer.emailAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                  ]),

                  ///_______right-section__________________________________
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      'Consignee (Ship to)',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                    ),

                    //__________Bill_to___________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 45.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.shippingName,
                          // transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 45.0,
                        child: pw.Text(
                          'Address',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.shippingAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                    //_____phone____________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 45.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.shippingPhoneNumber,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    //_____Location____________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 45.0,
                        child: pw.Text(
                          'Location',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.shippingLandmark,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },

        ///_____Footer__________________________________________________________________
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: 792.98,
              color: PdfColors.black,
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Stack(children: [
                pw.Center(
                  child: pw.Text(personalInformation.companyName, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Positioned(
                  right: 10,
                  child: pw.Text('This invoice Computer Generated', style: const pw.TextStyle(color: PdfColors.white, fontSize: 10)),
                )
              ]),
            ),
          ]);
        },

        ///______Product_section__________________________________________________________________
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table.fromTextArray(
                    context: context,
                    border: const pw.TableBorder(
                        left: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        right: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                        )),
                    headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#007AD0')),
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FlexColumnWidth(4),
                      3: const pw.FlexColumnWidth(4),
                      5: const pw.FlexColumnWidth(3),
                      6: const pw.FlexColumnWidth(3),
                      7: const pw.FlexColumnWidth(3),
                    },
                    headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                    rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                    oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    headerAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                      5: pw.Alignment.center,
                      6: pw.Alignment.center,
                      7: pw.Alignment.center,
                    },
                    cellAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                      5: pw.Alignment.center,
                      6: pw.Alignment.center,
                      7: pw.Alignment.center,
                    },
                    data: <List<String>>[
                      <String>['SL', 'Brand', 'Model number', 'Serial number', 'HSN/SAC', 'Quantity', 'Unit Price', 'Total Price'],
                      for (int i = 0; i < transactions.productList!.length; i++)
                        <String>[
                          ('${i + 1}'),
                          transactions.productList!.elementAt(i).productBrandName ?? '',
                          transactions.productList!.elementAt(i).productName ?? '',
                          transactions.productList!.elementAt(i).serialNumber.toString().substring(1, transactions.productList!.elementAt(i).serialNumber.toString().length - 1),
                          transactions.productList!.elementAt(i).nsnsac ?? '',
                          (transactions.productList!.elementAt(i).quantity.toString()),
                          (transactions.productList!.elementAt(i).subTotal.toString()),
                          (int.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toString(),
                        ],
                    ]),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    //_________Bank Details_SECTION______________________________________________
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "Payment Method: ${transactions.paymentType}",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: basicFontSize,
                        ),
                      ),
                      pw.SizedBox(height: 5.0),
                      if (transactions.paymentType == 'Bank')
                        pw.Text(
                          "NEFT NO:${transactions.bankNEFT ?? ''}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: basicFontSize,
                          ),
                        ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        "Amount in Word : ${amountToWords(transactions.totalAmount!.toInt())}",
                        style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 20.0),

                      ///__________Bank_details_________________________________________

                      pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 40),
                          child: pw.Text(
                            "Bank Details",
                            style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                          )),

                      pw.Container(
                          width: 150,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.grey)),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text(
                              "BANK: ${personalInformation.bankName}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                            pw.Text(
                              "BRANCH: ${personalInformation.bankBranchName}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                            pw.Text(
                              "A/C NO: ${personalInformation.bankBranchName}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                            pw.Text(
                              "IFSC: ${personalInformation.ifscNumber}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                          ])),
                      pw.SizedBox(height: 20.0),

                      ///__________T&C__________________________________________________________

                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 40),
                        child: pw.Text(
                          "T&C APPLY",
                          style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),

                      pw.Container(
                          width: 150,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.grey)),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text(personalInformation.tAndC,
                                maxLines: 12,
                                style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: basicFontSize,
                                )),
                          ]))
                    ]),

                    //______Right_Amount_SECTION______________________________________________
                    pw.SizedBox(
                      width: 150.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "CGST:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.cgst.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "SGST:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.sgst.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "IGST:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.igst ?? ''}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Service Charge:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.serviceCharge}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Discount:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.discountAmount}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Container(
                            color: PdfColor.fromHex('#007AD0'),
                            width: 150.0,
                            padding: const pw.EdgeInsets.all(10.0),
                            child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  FutureOr<Uint8List> generatePurchaseDocumentClint({required PurchaseTransactionModel transactions, required PersonalInformationModel personalInformation}) async {
    EasyLoading.show(status: 'Loading...');
    double basicFontSize = 10;
    final pw.Document doc = pw.Document();
    List<String> list = personalInformation.pictureUrl.split('?');
    final httpsReference = FirebaseStorage.instance.refFromURL(list.first);
    Uint8List? imageBytes = await httpsReference.getData();
    EasyLoading.dismiss();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        ///_______Header__________________________________________________________________
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                // imageWidget,
                ///________Shop_details_and_date__________________________________________________________________________-___________________
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  //________Shop_details__________________________________________________________________
                  pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                    // pw.ClipRRect(
                    //   horizontalRadius: 30,
                    //   child: image.,
                    // ),
                    pw.Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: pw.Alignment.centerRight,
                      margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                      padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                      decoration: pw.BoxDecoration(
                          image: pw.DecorationImage(
                              image: pw.MemoryImage(
                        imageBytes!,
                      ))),
                    ),

                    pw.SizedBox(width: 10.0),
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.Text(
                        personalInformation.companyName.toUpperCase(),
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'ADDRESS: ${personalInformation.address}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        personalInformation.city,
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'GSTIN/UIN: ${personalInformation.gstNo}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'TEL: ${personalInformation.phoneNumber}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'STATE NAME: ${personalInformation.state}, CODE:${personalInformation.zip}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ]),
                  ]),

                  ///__________Date_________________________________________________________________________
                  pw.Text(
                    'DATE: ${transactions.purchaseDate.substring(0, 10)}',
                    // 'Address: ${personalInformation.countryName}',
                    style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                  ),
                ]),
                pw.SizedBox(height: 10.0),

                //_________invoice__________________________________________________________________________________
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                    child: pw.Text(
                      'Purchase',
                      style: const pw.TextStyle(
                        color: PdfColors.black,
                        // fontWeight: pw.FontWeight.b old,
                        fontSize: 21.0,
                      ),
                    ),
                  ),
                  pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                      width: 120,
                      child: pw.Center(
                          child: pw.Text(
                        'BILL NO: ${transactions.invoiceNumber}',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 13.0,
                        ),
                      ))),
                ]),
                pw.SizedBox(height: 10.0),

                ///________customer details_________________________________________________________________________

                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  ///_______left sec_______________________________________________________
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      'Buyer (Bill to)',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                    ),

                    //__________-Bill_to_____________________________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.Container(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.customerFullName,
                          // transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Address',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.customerAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                    //_____phone__________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.phoneNumber,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    //____GSTIN________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'GSTIN/UIN',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.gstNumber,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///_____State______________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'State Name',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.billingState,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///______email_____________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Email',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          // transactions.customerPhone,
                          transactions.customer.emailAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },

        ///_____Footer__________________________________________________________________
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: 792.98,
              color: PdfColors.black,
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Stack(children: [
                pw.Center(
                  child: pw.Text(personalInformation.companyName, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Positioned(
                  right: 10,
                  child: pw.Text('This invoice Computer Generated', style: const pw.TextStyle(color: PdfColors.white, fontSize: 10)),
                )
              ]),
            ),
          ]);
        },

        ///______Product_section__________________________________________________________________
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table.fromTextArray(
                    context: context,
                    border: const pw.TableBorder(
                        left: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        right: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                        )),
                    headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#007AD0')),
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FlexColumnWidth(4),
                      3: const pw.FlexColumnWidth(4),
                      5: const pw.FlexColumnWidth(3),
                      6: const pw.FlexColumnWidth(3),
                      7: const pw.FlexColumnWidth(3),
                    },
                    headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                    rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                    oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    headerAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                      5: pw.Alignment.center,
                      6: pw.Alignment.center,
                      7: pw.Alignment.center,
                    },
                    cellAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                      5: pw.Alignment.center,
                      6: pw.Alignment.center,
                      7: pw.Alignment.center,
                    },
                    data: <List<String>>[
                      <String>['SL', 'Brand', 'Model number', 'Serial number', 'HSN/SAC', 'Quantity', 'Unit Price', 'Total Price'],
                      for (int i = 0; i < transactions.productList!.length; i++)
                        <String>[
                          ('${i + 1}'),
                          transactions.productList!.elementAt(i).brandName,
                          transactions.productList!.elementAt(i).productName,
                          transactions.productList!.elementAt(i).serialNumber.toString().substring(1, transactions.productList!.elementAt(i).serialNumber.toString().length - 1),
                          transactions.productList!.elementAt(i).nsnSAC,
                          (transactions.productList!.elementAt(i).productStock.toString()),
                          (transactions.productList!.elementAt(i).productPurchasePrice.toString()),
                          (int.parse(transactions.productList!.elementAt(i).productPurchasePrice) * transactions.productList!.elementAt(i).productStock.toInt()).toString(),
                        ],
                    ]),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    //_________Bank Details_SECTION______________________________________________
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "Payment Method: ${transactions.paymentType}",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: basicFontSize,
                        ),
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        "Amount in Word : ${amountToWords(transactions.totalAmount!.toInt())}",
                        style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize, fontWeight: pw.FontWeight.bold),
                      ),
                    ]),

                    //______Right_Amount_SECTION______________________________________________
                    pw.SizedBox(
                      width: 150.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          //   pw.SizedBox(
                          //     width: 100.0,
                          //     child: pw.Text(
                          //       "CGST:",
                          //       style: const pw.TextStyle(
                          //         color: PdfColors.black,
                          //       ),
                          //     ),
                          //   ),
                          //   pw.Text(
                          //     transactions.cgst.toString(),
                          //     style: const pw.TextStyle(
                          //       color: PdfColors.black,
                          //     ),
                          //   ),
                          // ]),
                          // pw.SizedBox(height: 5.0),
                          // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          //   pw.SizedBox(
                          //     width: 100.0,
                          //     child: pw.Text(
                          //       "SGST:",
                          //       style: const pw.TextStyle(
                          //         color: PdfColors.black,
                          //       ),
                          //     ),
                          //   ),
                          //   pw.Text(
                          //     transactions.sgst.toString(),
                          //     style: const pw.TextStyle(
                          //       color: PdfColors.black,
                          //     ),
                          //   ),
                          // ]),
                          // pw.SizedBox(height: 5.0),
                          // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          //   pw.SizedBox(
                          //     width: 100.0,
                          //     child: pw.Text(
                          //       "IGST:",
                          //       style: const pw.TextStyle(
                          //         color: PdfColors.black,
                          //       ),
                          //     ),
                          //   ),
                          //   pw.Text(
                          //     "${transactions.igst ?? ''}",
                          //     style: const pw.TextStyle(
                          //       color: PdfColors.black,
                          //     ),
                          //   ),
                          // ]),
                          // pw.SizedBox(height: 5.0),
                          // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          //   pw.SizedBox(
                          //     width: 100.0,
                          //     child: pw.Text(
                          //       "Service Charge:",
                          //       style: const pw.TextStyle(
                          //         color: PdfColors.black,
                          //       ),
                          //     ),
                          //   ),
                          //   pw.Text(
                          //     "${transactions.discountAmount}",
                          //     style: const pw.TextStyle(
                          //       color: PdfColors.black,
                          //     ),
                          //   ),
                          // ]),
                          // pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Discount:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.discountAmount}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Container(
                            color: PdfColor.fromHex('#007AD0'),
                            width: 150.0,
                            padding: const pw.EdgeInsets.all(10.0),
                            child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  FutureOr<Uint8List> generateSaleQuotationDocumentClint({required SaleTransactionModel transactions, required PersonalInformationModel personalInformation}) async {
    EasyLoading.show(status: 'Loading...');
    double basicFontSize = 10;
    final pw.Document doc = pw.Document();
    List<String> list = personalInformation.pictureUrl.split('?');
    final httpsReference = FirebaseStorage.instance.refFromURL(list.first);
    Uint8List? imageBytes = await httpsReference.getData();
    EasyLoading.dismiss();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        ///_______Header__________________________________________________________________
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                // imageWidget,
                ///________Shop_details_and_date__________________________________________________________________________-___________________
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  //________Shop_details__________________________________________________________________
                  pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                    pw.Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: pw.Alignment.centerRight,
                      margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                      padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                      decoration: pw.BoxDecoration(
                          image: pw.DecorationImage(
                              image: pw.MemoryImage(
                        imageBytes!,
                      ))),
                    ),
                    pw.SizedBox(width: 10.0),
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.Text(
                        personalInformation.companyName.toUpperCase(),
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'ADDRESS: ${personalInformation.address}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        personalInformation.city,
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'GSTIN/UIN: ${personalInformation.gstNo}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'TEL: ${personalInformation.phoneNumber}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        'STATE NAME: ${personalInformation.state}, CODE:${personalInformation.zip}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ]),
                  ]),

                  ///__________Date_________________________________________________________________________
                  pw.Text(
                    'DATE: ${transactions.purchaseDate.substring(0, 10)}',
                    // 'Address: ${personalInformation.countryName}',
                    style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                  ),
                ]),
                pw.SizedBox(height: 10.0),

                //_________invoice__________________________________________________________________________________
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                    child: pw.Text(
                      'Quotation',
                      style: const pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 21.0,
                      ),
                    ),
                  ),
                  pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                      width: 120,
                      child: pw.Center(
                          child: pw.Text(
                        'BILL NO: ${transactions.invoiceNumber}',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 13.0,
                        ),
                      ))),
                ]),
                pw.SizedBox(height: 10.0),

                ///________customer details_________________________________________________________________________

                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  ///_______left sec_______________________________________________________
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      'Buyer (Bill to)',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                    ),

                    //__________-Bill_to_____________________________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.Container(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.customerFullName,
                          // transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///_____Address_______________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Address',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.customerAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                    //_____phone__________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.phoneNumber,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    //____GSTIN________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'GSTIN/UIN',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.gstNumber,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///_____State______________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'State Name',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          transactions.customer.billingState,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),

                    ///______email_____________________________________
                    pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(
                        width: 55.0,
                        child: pw.Text(
                          'Email',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.SizedBox(
                        width: 200.0,
                        child: pw.Text(
                          // transactions.customerPhone,
                          transactions.customer.emailAddress,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },

        ///_____Footer__________________________________________________________________
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: 792.98,
              color: PdfColors.black,
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Stack(children: [
                pw.Center(
                  child: pw.Text(personalInformation.companyName, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Positioned(
                  right: 10,
                  child: pw.Text('This invoice Computer Generated', style: const pw.TextStyle(color: PdfColors.white, fontSize: 10)),
                )
              ]),
            ),
          ]);
        },

        ///______Product_section__________________________________________________________________
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table.fromTextArray(
                    context: context,
                    border: const pw.TableBorder(
                        left: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        right: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                        )),
                    headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#007AD0')),
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FlexColumnWidth(4),
                      3: const pw.FlexColumnWidth(4),
                      5: const pw.FlexColumnWidth(3),
                      6: const pw.FlexColumnWidth(3),
                      7: const pw.FlexColumnWidth(3),
                    },
                    headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                    rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                    oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    headerAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                      5: pw.Alignment.center,
                      6: pw.Alignment.center,
                      7: pw.Alignment.center,
                    },
                    cellAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                      5: pw.Alignment.center,
                      6: pw.Alignment.center,
                      7: pw.Alignment.center,
                    },
                    data: <List<String>>[
                      <String>['SL', 'Brand', 'Model number', 'Serial number', 'HSN/SAC', 'Quantity', 'Unit Price', 'Total Price'],
                      for (int i = 0; i < transactions.productList!.length; i++)
                        <String>[
                          ('${i + 1}'),
                          transactions.productList!.elementAt(i).productBrandName ?? '',
                          transactions.productList!.elementAt(i).productId ?? '',
                          '',
                          transactions.productList!.elementAt(i).nsnsac ?? '',
                          (transactions.productList!.elementAt(i).quantity.toString()),
                          (transactions.productList!.elementAt(i).subTotal.toString()),
                          (int.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toString(),
                        ],
                    ]),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    //_________Bank Details_SECTION______________________________________________
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "Amount in Word : ${amountToWords(transactions.totalAmount!.toInt())}",
                        style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 20.0),

                      ///__________Bank_details_________________________________________

                      pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 40),
                          child: pw.Text(
                            "Bank Details",
                            style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                          )),
                      pw.Container(
                          width: 150,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.grey)),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text(
                              "BANK: ${personalInformation.bankName}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                            pw.Text(
                              "BRANCH: ${personalInformation.bankBranchName}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                            pw.Text(
                              "A/C NO: ${personalInformation.bankBranchName}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                            pw.Text(
                              "IFSC: ${personalInformation.ifscNumber}",
                              style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                            ),
                          ])),
                      pw.SizedBox(height: 20.0),

                      ///__________T&C__________________________________________________________

                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 40),
                        child: pw.Text(
                          "T&C APPLY",
                          style: pw.TextStyle(color: PdfColors.black, fontSize: basicFontSize),
                        ),
                      ),
                      pw.Container(
                          width: 150,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1, color: PdfColors.grey)),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text(personalInformation.tAndC,
                                maxLines: 12,
                                style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: basicFontSize,
                                )),
                          ]))
                    ]),

                    //______Right_Amount_SECTION______________________________________________
                    pw.SizedBox(
                      width: 150.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "CGST:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.cgst.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "SGST:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.sgst.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "IGST:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.igst ?? ''}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Service Charge:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.serviceCharge}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 5.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Discount:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.discountAmount}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Container(
                            color: PdfColor.fromHex('#007AD0'),
                            width: 150.0,
                            padding: const pw.EdgeInsets.all(10.0),
                            child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  FutureOr<Uint8List> generateSaleDocument({required SaleTransactionModel transactions, required PersonalInformationModel personalInformation}) async {
    final pw.Document doc = pw.Document();
    final netImage = await networkImage(
      'https://www.nfet.net/nfet.jpg',
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                pw.Row(children: [
                  pw.Container(
                    height: 50.0,
                    width: 50.0,
                    alignment: pw.Alignment.centerRight,
                    margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    decoration: pw.BoxDecoration(image: pw.DecorationImage(image: netImage), shape: pw.BoxShape.circle),
                  ),
                  pw.SizedBox(width: 10.0),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      personalInformation.companyName,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Address: ${personalInformation.countryName}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
                    ),
                    pw.Text(
                      'Tel: ${personalInformation.phoneNumber!}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
                    ),
                  ]),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 40.0,
                    color: PdfColor.fromHex('#007AD0'),
                    width: 100,
                  ),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.customerPhone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Sells By',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Admin',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Invoice Number',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Date',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: 'D, M j'),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              color: PdfColors.black,
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Center(child: pw.Text('Powered By Acnoo', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
            ),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table.fromTextArray(
                    context: context,
                    border: const pw.TableBorder(
                        left: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        right: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                        )),
                    headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#007AD0')),
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: const pw.FlexColumnWidth(1),
                      1: const pw.FlexColumnWidth(6),
                      2: const pw.FlexColumnWidth(2),
                      3: const pw.FlexColumnWidth(2),
                      4: const pw.FlexColumnWidth(2),
                    },
                    headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                    rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                    oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    headerAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.center,
                      3: pw.Alignment.centerRight,
                      4: pw.Alignment.centerRight,
                    },
                    cellAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.center,
                      3: pw.Alignment.centerRight,
                      4: pw.Alignment.centerRight,
                    },
                    data: <List<String>>[
                      <String>['SL', 'Item', 'Quantity', 'Unit Price', 'Total Price'],
                      for (int i = 0; i < transactions.productList!.length; i++)
                        <String>[
                          ('${i + 1}'),
                          (transactions.productList!.elementAt(i).productName.toString()),
                          (transactions.productList!.elementAt(i).quantity.toString()),
                          (transactions.productList!.elementAt(i).subTotal),
                          ((int.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toString())
                        ],
                    ]),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "Payment Method: ${transactions.paymentType}",
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10.0),
                      pw.Text(
                        "Amount in Word",
                        style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                      ),
                      // pw.SizedBox(height: 10.0),
                      // pw.Text(
                      //   NumberToCharacterConverter('en').convertDouble(transactions.totalAmount).toUpperCase(),
                      //   style: pw.TextStyle(
                      //       color: PdfColors.black,
                      //       fontWeight: pw.FontWeight.bold
                      //   ),
                      // ),
                    ]),
                    pw.SizedBox(
                      width: 150.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Vat:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              '0.00',
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Tax:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              '0.00',
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Discount:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.discountAmount.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Subtotal:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.totalAmount}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Container(
                            color: PdfColor.fromHex('#007AD0'),
                            width: 150.0,
                            padding: const pw.EdgeInsets.all(10.0),
                            child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Paid:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.totalAmount! - transactions.dueAmount!}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Due:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.dueAmount.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  FutureOr<Uint8List> generateQuotationDocument({required SaleTransactionModel transactions, required PersonalInformationModel personalInformation}) async {
    final pw.Document doc = pw.Document();
    final netImage = await networkImage(
      'https://www.nfet.net/nfet.jpg',
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                pw.Row(children: [
                  pw.Container(
                    height: 50.0,
                    width: 50.0,
                    alignment: pw.Alignment.centerRight,
                    margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    decoration: pw.BoxDecoration(image: pw.DecorationImage(image: netImage), shape: pw.BoxShape.circle),
                  ),
                  pw.SizedBox(width: 10.0),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      personalInformation.companyName,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Address: ${personalInformation.countryName}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
                    ),
                    pw.Text(
                      'Tel: ${personalInformation.phoneNumber!}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
                    ),
                  ]),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Container(
                      height: 40.0,
                      color: PdfColor.fromHex('#007AD0'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 40.0,
                    color: PdfColor.fromHex('#007AD0'),
                    width: 100,
                  ),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.customerName,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.customerPhone,
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Quotation By',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Admin',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    // pw.Row(children: [
                    //   pw.SizedBox(
                    //     width: 100.0,
                    //     child: pw.Text(
                    //       'Invoice Number',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 10.0,
                    //     child: pw.Text(
                    //       ':',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    //   pw.SizedBox(
                    //     width: 100.0,
                    //     child: pw.Text(
                    //       '#${transactions.invoiceNumber}',
                    //       style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    //     ),
                    //   ),
                    // ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Date',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: 'D, M j'),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              color: PdfColors.black,
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Center(child: pw.Text('Powered By Maan Technology', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
            ),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table.fromTextArray(
                    context: context,
                    border: const pw.TableBorder(
                        left: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        right: pw.BorderSide(
                          color: PdfColors.black,
                        ),
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                        )),
                    headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#007AD0')),
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: const pw.FlexColumnWidth(1),
                      1: const pw.FlexColumnWidth(6),
                      2: const pw.FlexColumnWidth(2),
                      3: const pw.FlexColumnWidth(2),
                      4: const pw.FlexColumnWidth(2),
                    },
                    headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                    rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                    oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    headerAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.center,
                      3: pw.Alignment.centerRight,
                      4: pw.Alignment.centerRight,
                    },
                    cellAlignments: <int, pw.Alignment>{
                      0: pw.Alignment.center,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.center,
                      3: pw.Alignment.centerRight,
                      4: pw.Alignment.centerRight,
                    },
                    data: <List<String>>[
                      <String>['SL', 'Item', 'Quantity', 'Unit Price', 'Total Price'],
                      for (int i = 0; i < transactions.productList!.length; i++)
                        <String>[
                          ('${i + 1}'),
                          (transactions.productList!.elementAt(i).productName.toString()),
                          (transactions.productList!.elementAt(i).quantity.toString()),
                          (transactions.productList!.elementAt(i).subTotal),
                          ((int.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toString())
                        ],
                    ]),
                pw.Paragraph(text: ""),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        "Payment Method: ${transactions.paymentType}",
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10.0),
                      pw.Text(
                        "Amount in Word",
                        style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                      ),
                      // pw.SizedBox(height: 10.0),
                      // pw.Text(
                      //   NumberToCharacterConverter('en').convertDouble(transactions.totalAmount).toUpperCase(),
                      //   style: pw.TextStyle(
                      //       color: PdfColors.black,
                      //       fontWeight: pw.FontWeight.bold
                      //   ),
                      // ),
                    ]),
                    pw.SizedBox(
                      width: 150.0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Vat/GST:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.cgst.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Service Charge:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.serviceCharge.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Discount:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              transactions.discountAmount.toString(),
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.SizedBox(
                              width: 100.0,
                              child: pw.Text(
                                "Subtotal:",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${transactions.totalAmount}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.SizedBox(height: 10.0),
                          pw.Container(
                            color: PdfColor.fromHex('#007AD0'),
                            width: 150.0,
                            padding: const pw.EdgeInsets.all(10.0),
                            child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  FutureOr<Uint8List> generateDueDocument({required DueTransactionModel transactions, required PersonalInformationModel personalInformation}) async {
    final pw.Document doc = pw.Document();
    final netImage = await networkImage(
      'https://www.nfet.net/nfet.jpg',
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Container(
                    height: 50.0,
                    width: 50.0,
                    alignment: pw.Alignment.centerRight,
                    margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    decoration: pw.BoxDecoration(image: pw.DecorationImage(image: netImage), shape: pw.BoxShape.circle),
                  ),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      personalInformation.companyName,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Tel: ${personalInformation.phoneNumber!}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
                    ),
                  ]),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                    child: pw.Text(
                      'Payment Receipt',
                      style: pw.TextStyle(
                        color: PdfColors.purple300,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ]),
                pw.SizedBox(height: 30.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      'Received From:',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      transactions.customerName,
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Row(children: [
                      pw.Text(
                        'Contact No:',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        transactions.customerPhone,
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ]),
                  ]),
                  pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.Row(children: [
                      pw.Text(
                        'Receipt No.:',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold,
                            ),
                      ),
                      pw.Text(
                        '#${transactions.invoiceNumber}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold,
                            ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.Text(
                        'Date:',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                      pw.Text(
                        DateTimeFormat.format(
                          DateTime.parse(transactions.purchaseDate),
                        ).substring(0, 10),
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              color: PdfColors.black,
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Center(child: pw.Text('Powered By Maan Technology', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
            ),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Paragraph(text: ""),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10.0),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(10.0),
                  ),
                  child: pw.Row(children: [
                    pw.Expanded(
                      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                        pw.Text('Amount In Words',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold,
                            )),
                        // pw.SizedBox(height: 10.0),
                        // pw.Container(
                        //   padding: const pw.EdgeInsets.all(4.0),
                        //   width: double.infinity,
                        //   color: PdfColors.grey50,
                        //   child: pw.Text(NumberToCharacterConverter('en').convertDouble(transactions.payDueAmount).toUpperCase(), style: const pw.TextStyle(color: PdfColors.black)),
                        // ),
                      ]),
                    ),
                    pw.SizedBox(width: 20.0),
                    pw.Expanded(
                        child: pw.Column(children: [
                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                        pw.Text('Received', style: const pw.TextStyle(color: PdfColors.black)),
                        pw.Text(transactions.payDueAmount.toString(), style: const pw.TextStyle(color: PdfColors.black)),
                      ]),
                      pw.SizedBox(height: 4.0),
                      pw.Container(height: 3.0, width: double.infinity, color: PdfColors.grey50),
                    ])),
                  ]),
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }
}

String amountToWords(int amount) {
  final List<String> units = ['', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
  final List<String> tens = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];
  final List<String> teens = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];

  if (amount == 0) {
    return 'zero';
  }

  String words = '';
  if ((amount ~/ 1000) > 0) {
    words += '${amountToWords(amount ~/ 1000)} thousand ';
    amount %= 1000;
  }
  if ((amount ~/ 100) > 0) {
    words += '${units[amount ~/ 100]} hundred ';
    amount %= 100;
  }
  if (amount > 0) {
    if (words.isNotEmpty) {
      words += 'and ';
    }
    if (amount < 10) {
      words += units[amount];
    } else if (amount < 20) {
      words += teens[amount - 10];
    } else {
      words += '${tens[amount ~/ 10]} ${units[amount % 10]}';
    }
  }

  return words.trim();
}
