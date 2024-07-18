// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:salespro_admin/Screen/Purchase/tablet_purchase.dart';
//
// import '../../Provider/profile_provider.dart';
// import '../../model/personal_information_model.dart';
// import '../../model/transition_model.dart';
// import '../Widgets/Constant Data/constant.dart';
//
//
// class TabletPurchaseInvoice extends StatefulWidget {
//   const TabletPurchaseInvoice({Key? key, required this.transitionModel, required this.personalInformationModel, required this.isTabPurchase}) : super(key: key);
//   final PurchaseTransitionModel transitionModel;
//   final PersonalInformationModel personalInformationModel;
//   final bool isTabPurchase;
//
//   @override
//   State<TabletPurchaseInvoice> createState() => _TabletPurchaseInvoiceState();
// }
//
// class _TabletPurchaseInvoiceState extends State<TabletPurchaseInvoice> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10.0),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30.0),
//                 color: kRedTextColor
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(FeatherIcons.x, color: kWhiteTextColor, size: 25,),
//                 const SizedBox(width: 4.0),
//                 Text('Cancel',style: kTextStyle.copyWith(color: kWhiteTextColor,fontSize: 20.0),),
//               ],
//             ),
//           ).onTap(() => widget.isTabPurchase
//               ? Navigator.pushAndRemoveUntil<dynamic>(
//             context,
//             MaterialPageRoute<dynamic>(
//               builder: (BuildContext context) => const TabletPurchase(),
//             ),
//                 (route) => false, //if you want to disable back feature set to false
//           )
//               : Navigator.pop(context)),
//           const SizedBox(width: 20.0),
//           Container(
//             padding: const EdgeInsets.all(10.0),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30.0),
//                 color: kRedTextColor
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(MdiIcons.printer, color: kWhiteTextColor, size: 25,),
//                 const SizedBox(width: 4.0),
//                 Text('Print Invoice',style: kTextStyle.copyWith(color: kWhiteTextColor,fontSize: 20.0),),
//               ],
//             ),
//           ).onTap(() => window.print()
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       body: SingleChildScrollView(
//         child: Consumer(
//           builder: (_, ref, watch) {
//             final personalInfo = ref.watch(profileDetailsProvider);
//             return personalInfo.when(data: (personalInfo) {
//               return Card(
//                 child: SizedBox(
//                   height: context.height(),
//                   width: context.width()/1.3,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Row(
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.personalInformationModel.companyName.toString(),
//                                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
//                                 ),
//                                 Text(
//                                   widget.personalInformationModel.countryName.toString(),
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                                 Text(
//                                   widget.personalInformationModel.phoneNumber.toString(),
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                                 Text(
//                                   widget.personalInformationModel.countryName.toString(),
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                               ],
//                             ),
//                             const Spacer(),
//                             Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15.0),
//                                 image: DecorationImage(image: NetworkImage(widget.personalInformationModel.pictureUrl.toString()), fit: BoxFit.fill),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       Center(
//                         child: Text(
//                           'INVOICE',
//                           style: kTextStyle.copyWith(color: kRedTextColor, fontWeight: FontWeight.bold, fontSize: 30.0),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Bill to:',
//                               style: kTextStyle.copyWith(color: kTitleColor),
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   widget.transitionModel.customerName,
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   'Invoice# ${widget.transitionModel.invoiceNumber}',
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   widget.transitionModel.customerType.toString(),
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   'Date:${widget.transitionModel.purchaseDate.substring(0, 10)}',
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   'Phone:${widget.transitionModel.customerPhone}',
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   'Due Date:${widget.transitionModel.purchaseDate.substring(0, 10)}',
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       SizedBox(
//                         width: context.width(),
//                         child: DataTable(
//                           headingRowColor: MaterialStateProperty.all(kRedTextColor),
//                           showBottomBorder: false,
//                           headingTextStyle: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold),
//                           horizontalMargin: null,
//                           dividerThickness: 0,
//                           headingRowHeight: 40.0,
//                           columns: const [
//                             DataColumn(
//                               label: Text(
//                                 'Product',
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text('Unit Price'),
//                             ),
//                             DataColumn(
//                               label: Text('Quantity'),
//                             ),
//                             DataColumn(
//                               label: Text('Total Price'),
//                             ),
//                           ],
//                           rows: List.generate(
//                               widget.transitionModel.productList?.length ?? 0,
//                                   (index) => DataRow(
//                                 cells: [
//                                   DataCell(
//                                     Text(widget.transitionModel.productList?[index].productName ?? ''),
//                                   ),
//                                   DataCell(
//                                     Text('${currency} ${widget.transitionModel.productList?[index].productPurchasePrice ?? ''}'),
//                                   ),
//                                   DataCell(
//                                     Text(widget.transitionModel.productList?[index].productStock.toString() ?? ''),
//                                   ),
//                                   DataCell(
//                                     Text('${currency} ${double.parse(widget.transitionModel.productList![index].productPurchasePrice) * widget.transitionModel.productList![index].productStock.toDouble()}'),
//                                   ),
//                                 ],
//                               )),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 20.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Sub Total',
//                                   maxLines: 1,
//                                   style: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                                 const SizedBox(width: 20.0),
//                                 SizedBox(
//                                   width: 120,
//                                   child: Text(
//                                     '${currency} ${widget.transitionModel.totalAmount}',
//                                     maxLines: 2,
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 5.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Total Vat',
//                                   maxLines: 1,
//                                   style: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                                 const SizedBox(width: 20.0),
//                                 SizedBox(
//                                   width: 120,
//                                   child: Text(
//                                     '${currency} 0.00',
//                                     maxLines: 2,
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 5.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Total Discount',
//                                   maxLines: 1,
//                                   style: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                                 const SizedBox(width: 20.0),
//                                 SizedBox(
//                                   width: 120,
//                                   child: Text(
//                                     '${currency} ${widget.transitionModel.discountAmount}',
//                                     maxLines: 2,
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 5.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Delivery Charge',
//                                   maxLines: 1,
//                                   style: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                                 const SizedBox(width: 20.0),
//                                 SizedBox(
//                                   width: 120,
//                                   child: Text(
//                                     '${currency} 0.00',
//                                     maxLines: 2,
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 5.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 SizedBox(
//                                   child: Container(
//                                     padding: const EdgeInsets.all(4.0),
//                                     decoration: const BoxDecoration(color: kRedTextColor),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         Text(
//                                           'Total Payable',
//                                           maxLines: 1,
//                                           style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold),
//                                         ),
//                                         const SizedBox(width: 20.0),
//                                         SizedBox(
//                                           width: 120,
//                                           child: Text(
//                                             '${currency} ${widget.transitionModel.totalAmount}',
//                                             maxLines: 2,
//                                             style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign.end,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 5.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Paid',
//                                   maxLines: 1,
//                                   style: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                                 const SizedBox(width: 20.0),
//                                 SizedBox(
//                                   width: 120,
//                                   child: Text(
//                                     '${currency} ${widget.transitionModel.totalAmount! - widget.transitionModel.dueAmount!.toDouble()}',
//                                     maxLines: 2,
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 5.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Due',
//                                   maxLines: 1,
//                                   style: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                                 const SizedBox(width: 20.0),
//                                 SizedBox(
//                                   width: 120,
//                                   child: Text(
//                                     '${currency} ${widget.transitionModel.dueAmount}',
//                                     maxLines: 2,
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }, error: (e, stack) {
//               return Center(
//                 child: Text(e.toString()),
//               );
//             }, loading: () {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
