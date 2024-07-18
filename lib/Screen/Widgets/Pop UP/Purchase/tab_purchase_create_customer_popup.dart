// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../../../../Provider/customer_provider.dart';
// import '../../../../model/customer_model.dart';
// import '../../Constant Data/button_global.dart';
// import '../../Constant Data/constant.dart';
//
// class TabPurchaseCreateCustomerPopUp extends StatefulWidget {
//   const TabPurchaseCreateCustomerPopUp({Key? key}) : super(key: key);
//
//   @override
//   State<TabPurchaseCreateCustomerPopUp> createState() => _TabCreateCustomerPopUpState();
// }
//
// class _TabCreateCustomerPopUpState extends State<TabPurchaseCreateCustomerPopUp> {
//   List<String> customerType = [
//     'Supplier',
//   ];
//   String selectedCustomerType = 'Supplier';
//
//   DateTime selectedBirthDate = DateTime.now();
//
//   Future<void> _selectedBirthDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(context: context, initialDate: selectedBirthDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
//     if (picked != null && picked != selectedBirthDate) {
//       setState(() {
//         selectedBirthDate = picked;
//       });
//     }
//   }
//
//   TextEditingController customerNameController = TextEditingController();
//   TextEditingController previousDueController = TextEditingController();
//   TextEditingController customerPhoneController = TextEditingController();
//   TextEditingController customerEmailController = TextEditingController();
//   TextEditingController customerAddressController = TextEditingController();
//   TextEditingController noteController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, _) {
//         return SizedBox(
//           width: 900,
//           height: context.height() /2.5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       'Create Customer',
//                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
//                     ),
//                     const Spacer(),
//                     const Icon(FeatherIcons.x, color: kTitleColor).onTap(() => {finish(context)})
//                   ],
//                 ),
//               ),
//               const Divider(
//                 thickness: 1.0,
//                 color: kLitGreyColor,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: AppTextField(
//                             controller: customerNameController,
//                             showCursor: true,
//                             cursorColor: kTitleColor,
//                             textFieldType: TextFieldType.NAME,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Customer Name',
//                               labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                               hintText: 'Enter Customer Name',
//                               hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20.0),
//                         Expanded(
//                           child: AppTextField(
//                             controller: previousDueController,
//                             showCursor: true,
//                             cursorColor: kTitleColor,
//                             textFieldType: TextFieldType.NAME,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Previous Due',
//                               labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                               hintText: '${currency}0.00',
//                               hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: AppTextField(
//                             controller: customerPhoneController,
//                             showCursor: true,
//                             cursorColor: kTitleColor,
//                             textFieldType: TextFieldType.NAME,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Phone',
//                               labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                               hintText: 'Enter Phone Number',
//                               hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20.0),
//                         Expanded(
//                           child: FormField(
//                             builder: (FormFieldState<dynamic> field) {
//                               return InputDecorator(
//                                 decoration: InputDecoration(
//                                   suffixIcon: const Icon(FeatherIcons.calendar, color: kGreyTextColor),
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                     borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                                   ),
//                                   contentPadding: const EdgeInsets.all(8.0),
//                                   labelText: 'Date of Birth',
//                                   labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                   hintText: 'Enter Date of Birth',
//                                   hintStyle: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                                 child: Text(
//                                   selectedBirthDate.day.toString() + '/' + selectedBirthDate.month.toString() + '/' + selectedBirthDate.year.toString(),
//                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                 ),
//                               );
//                             },
//                           ).onTap(() => _selectedBirthDate(context)),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: AppTextField(
//                             controller: customerEmailController,
//                             showCursor: true,
//                             cursorColor: kTitleColor,
//                             textFieldType: TextFieldType.EMAIL,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Email',
//                               labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                               hintText: 'Enter email address',
//                               hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20.0),
//                         Expanded(
//                           child: FormField(
//                             builder: (FormFieldState<dynamic> field) {
//                               return InputDecorator(
//                                 decoration: const InputDecoration(
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                       borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                                     ),
//                                     contentPadding: EdgeInsets.all(6.0),
//                                     floatingLabelBehavior: FloatingLabelBehavior.always,
//                                     labelText: 'Type'),
//                                 child: DropdownButtonHideUnderline(
//                                     child: DropdownButton<String>(
//                                       onChanged: (String? value) {
//                                         setState(() {
//                                           selectedCustomerType = value!;
//                                           toast(selectedCustomerType);
//                                         });
//                                       },
//                                       value: selectedCustomerType,
//                                       items: customerType.map((String items) {
//                                         return DropdownMenuItem(
//                                           value: items,
//                                           child: Text(items),
//                                         );
//                                       }).toList(),
//                                     )),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: AppTextField(
//                             controller: customerAddressController,
//                             showCursor: true,
//                             cursorColor: kTitleColor,
//                             textFieldType: TextFieldType.NAME,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Address',
//                               labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                               hintText: 'Enter Address',
//                               hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20.0),
//                         Expanded(
//                           child: AppTextField(
//                             controller: noteController,
//                             showCursor: true,
//                             cursorColor: kTitleColor,
//                             textFieldType: TextFieldType.NAME,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Note',
//                               labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                               hintText: 'Enter Note',
//                               hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * .2,
//                           child: ButtonGlobal(
//                             buttontext: 'Cancel',
//                             buttonDecoration: kButtonDecoration.copyWith(
//                               color: kRedTextColor,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(5.0),
//                               ),
//                             ),
//                             onPressed: ()  {
//                               finish(context);
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 10.0),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * .2,
//                           child: ButtonGlobal(
//                             buttontext: 'Submit',
//                             buttonDecoration: kButtonDecoration.copyWith(
//                               color: kBlueTextColor,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(5.0),
//                               ),
//                             ),
//                             onPressed: () async {
//                               if (customerNameController.text.isEmpty) {
//                                 EasyLoading.showError('Customer Name Is Required');
//                               } else if (customerPhoneController.text.isEmpty) {
//                                 EasyLoading.showError('Customer Phone Is Required');
//                               } else {
//                                 try {
//                                   EasyLoading.show(status: 'Loading...', dismissOnTap: false);
//                                   // ignore: no_leading_underscores_for_local_identifiers
//                                   final DatabaseReference _customerInformationRef = FirebaseDatabase.instance
//                                   // ignore: deprecated_member_use
//                                       .reference()
//                                       .child(FirebaseAuth.instance.currentUser!.uid)
//                                       .child('Customers');
//                                   CustomerModel customerModel = CustomerModel(
//                                     customerNameController.text,
//                                     customerPhoneController.text,
//                                     'Supplier',
//                                     'https://i.imgur.com/jlyGd1j.jpg',
//                                     customerEmailController.text,
//                                     customerAddressController.text,
//                                     previousDueController.text.isEmpty ? '0' : previousDueController.text,
//                                   );
//                                   await _customerInformationRef.push().set(customerModel.toJson());
//                                   EasyLoading.showSuccess('Added Successfully!');
//                                   ref.refresh(supplierProvider);
//                                   Future.delayed(const Duration(milliseconds: 100), () {
//                                     Navigator.pop(context);
//                                   });
//                                 } catch (e) {
//                                   EasyLoading.dismiss();
//                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//                                 }
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
