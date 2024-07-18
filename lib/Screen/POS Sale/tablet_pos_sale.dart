// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:salespro_admin/Screen/Home/tablate_home.dart';
//
// import '../../Provider/add_to_cart.dart';
// import '../../Provider/customer_provider.dart';
// import '../../Provider/product_provider.dart';
// import '../../Provider/profile_provider.dart';
// import '../../model/add_to_cart_model.dart';
// import '../../model/customer_model.dart';
// import '../../model/product_model.dart';
// import '../../model/transition_model.dart';
// import '../Widgets/Calculator/calculator.dart';
// import '../Widgets/Constant Data/constant.dart';
// import '../Widgets/Pop UP/Pos Sale/due_sale_popup.dart';
// import '../Widgets/Pop UP/Pos Sale/sale_list_popup.dart';
// import '../Widgets/Pop UP/Pos Sale/tab_create_customer_popup.dart';
// import '../Widgets/Pop UP/Pos Sale/tab_show_payment_popup.dart';
//
// class TabletPosSale extends StatefulWidget {
//   const TabletPosSale({Key? key}) : super(key: key);
//
//   static const String route = '/mposSale';
//
//   @override
//   State<TabletPosSale> createState() => _TabletPosSaleState();
// }
//
// class _TabletPosSaleState extends State<TabletPosSale> {
//   bool isChecked = true;
//   List<AddToCartModel> cartList = [];
//
//   String getTotalAmount() {
//     double total = 0.0;
//     for (var item in cartList) {
//       total = total + (double.parse(item.unitPrice) * item.quantity);
//     }
//     return total.toString();
//   }
//
//   bool uniqueCheck(String code) {
//     bool isUnique = false;
//     for (var item in cartList) {
//       if (item.productId == code) {
//         item.quantity += 1;
//         isUnique = true;
//         break;
//       }
//     }
//     return isUnique;
//   }
//
//   String? selectedUserId;
//   CustomerModel selectedUserName = CustomerModel(
//     customerName: "Guest",
//     phoneNumber: "00",
//     type: "Guest",
//     customerAddress: '',
//     emailAddress: '',
//     profilePicture: '',
//     openingBalance: '0',
//     remainedBalance: '0',
//     dueAmount: '0',
//   );
//   String? invoiceNumber;
//
//   TransitionModel? dueTransactionModel;
//   List<CustomerModel> customerLists = [];
//   String previousDue = "0";
//   FocusNode nameFocus = FocusNode();
//
//   DropdownButton<String> getResult(List<CustomerModel> model) {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (var des in model) {
//       var item = DropdownMenuItem(
//         value: des.phoneNumber,
//         child: Text('${des.customerName} ${des.phoneNumber}'),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedUserId,
//       onChanged: (value) {
//         setState(() {
//           selectedUserId = value!;
//           model.forEach((element) {
//             if (element.phoneNumber == selectedUserId) {
//               selectedUserName = element;
//               previousDue = element.dueAmount;
//             }
//             ;
//           });
//           invoiceNumber = '';
//         });
//       },
//     );
//   }
//
//   List<String> user = [
//     'Name  Phone  Due',
//     'Sahidul 0171XXXXXXX ${currency}500',
//     'Sahidul 0172XXXXXXX ${currency}500',
//     'Sahidul 0173XXXXXXX ${currency}500',
//     'Sahidul 0174XXXXXXX ${currency}500',
//     'Sahidul 0175XXXXXXX ${currency}500',
//     'Sahidul 0176XXXXXXX ${currency}500',
//   ];
//   String selectedUser = 'Name  Phone  Due';
//
//   DropdownButton<String> getUser() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in user) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedUser,
//       onChanged: (value) {
//         setState(() {
//           selectedUser = value!;
//         });
//       },
//     );
//   }
//
//   List<String> categories = [
//     'Retail Price',
//     'Wholesale Price',
//     'Diller Price',
//   ];
//
//   String selectedCategories = 'Retail Price';
//
//   DropdownButton<String> getCategories() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in categories) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedCategories,
//       onChanged: (value) {
//         setState(() {
//           selectedCategories = value!;
//         });
//       },
//     );
//   }
//
// //Create Customer
//
//   List<String> customerCategories = [
//     'Retail',
//     'Wholesale',
//     'Dealer',
//   ];
//
//   String selectedCustomerCategories = 'Retail';
//
//   DropdownButton<String> getCustomerCategories() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in customerCategories) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedCustomerCategories,
//       onChanged: (value) {
//         setState(() {
//           selectedCustomerCategories = value!;
//         });
//       },
//     );
//   }
//
//   DateTime selectedDate = DateTime.now();
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   List<String> indexTitle = ['', 'Price', 'quantity', 'Subtotal', 'Action'];
//   int quantity = 1;
//
//   List<String> category = [
//     'Charger',
//     'Chicks',
//     'Sugar',
//     'Coke',
//     'Eggs',
//   ];
//
//   DateTime selectedDueDate = DateTime.now();
//
//   Future<void> _selectedDueDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDueDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDueDate) {
//       setState(() {
//         selectedDueDate = picked;
//       });
//     }
//   }
//
//   DateTime selectedSaleDate = DateTime.now();
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
//   List<String> categoryList = [
//     'Accessories',
//     'Computer',
//     'Jacket',
//     'T-shirt',
//     'Shoes',
//     'Fruit',
//   ];
//
//   String selectedCategoryList = 'Accessories';
//
//   DropdownButton<String> getCategoryList() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in categoryList) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedCategoryList,
//       onChanged: (value) {
//         setState(() {
//           selectedCategoryList = value!;
//         });
//       },
//     );
//   }
//
//   List<String> brandName = [
//     'Nike',
//     'Puma',
//     'Adidas',
//   ];
//
//   String selectedBrand = 'Nike';
//
//   DropdownButton<String> getBrand() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in brandName) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedBrand,
//       onChanged: (value) {
//         setState(() {
//           selectedBrand = value!;
//         });
//       },
//     );
//   }
//
//   List<String> unit = [
//     'Kilogram',
//     'Meter',
//     'Piece',
//   ];
//
//   String selectedUnit = 'Kilogram';
//
//   DropdownButton<String> getUnit() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in unit) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedUnit,
//       onChanged: (value) {
//         setState(() {
//           selectedUnit = value!;
//         });
//       },
//     );
//   }
//
//   List<String> paymentItem = [
//     'Bank',
//     'Due',
//     'B-kash',
//     'Nagad',
//     'Rocket',
//     'DBBL',
//   ];
//   String selectedPaymentOption = 'Bank';
//
//   DropdownButton<String> getOption() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in paymentItem) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       items: dropDownItems,
//       value: selectedPaymentOption,
//       onChanged: (value) {
//         setState(() {
//           selectedPaymentOption = value!;
//         });
//       },
//     );
//   }
//
// // Import Image
//   File? image;
//
//   Future pickImage(ImageSource gallery) async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (image == null) return;
//
//       final imageTemporary = File(image.path);
//       setState(() {
//         this.image = imageTemporary;
//       });
//     } on PlatformException catch (e) {
//       print('Faield to pick image: $e');
//     }
//   }
//
//   void showDueListPopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: const DueSalePopUp(),
//         );
//       },
//     );
//   }
//
//   void showSaleListPopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//                 child: const SaleListPopUP());
//           },
//         );
//       },
//     );
//   }
//
//   void showCreateCustomerPopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: const TabCreateCustomerPopUp(),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showAddItemPopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: SizedBox(
//                 width: 1000,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Add Item',
//                             style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
//                           ),
//                           const Spacer(),
//                           const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
//                         ],
//                       ),
//                     ),
//                     const Divider(thickness: 1.0, color: kLitGreyColor),
//                     const SizedBox(height: 10.0),
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Product Name*',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Product Name',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20.0),
//                               Expanded(
//                                 child: FormField(
//                                   builder: (FormFieldState<dynamic> field) {
//                                     return InputDecorator(
//                                       decoration: InputDecoration(
//                                           enabledBorder: const OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                             borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                                           ),
//                                           suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showCategoryAddPopUp()),
//                                           contentPadding: const EdgeInsets.all(8.0),
//                                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                                           labelText: 'Category'),
//                                       child: DropdownButtonHideUnderline(child: getCategoryList()),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: FormField(
//                                   builder: (FormFieldState<dynamic> field) {
//                                     return InputDecorator(
//                                       decoration: InputDecoration(
//                                           enabledBorder: const OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                             borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                                           ),
//                                           suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showBrandPopUp()),
//                                           contentPadding: const EdgeInsets.all(8.0),
//                                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                                           labelText: 'Brand'),
//                                       child: DropdownButtonHideUnderline(child: getBrand()),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(width: 20.0),
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Product Code',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Product Code',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Stock',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Stock amount',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20.0),
//                               Expanded(
//                                 child: FormField(
//                                   builder: (FormFieldState<dynamic> field) {
//                                     return InputDecorator(
//                                       decoration: InputDecoration(
//                                           suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showUnitPopUp()),
//                                           enabledBorder: const OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                             borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                                           ),
//                                           contentPadding: const EdgeInsets.all(8.0),
//                                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                                           labelText: 'Product Unit'),
//                                       child: DropdownButtonHideUnderline(child: getUnit()),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Sale Price',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Sale Price',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20.0),
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Purchase Price',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Purchase Price',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Discount Price',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Discount Price',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20.0),
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'WholeSale Price',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Price',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Dealer Price',
//                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                     hintText: 'Enter Dealer Price',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20.0),
//                               Expanded(
//                                 child: SizedBox(
//                                   width: (context.width() / 4),
//                                   child: AppTextField(
//                                     showCursor: true,
//                                     cursorColor: kTitleColor,
//                                     textFieldType: TextFieldType.NAME,
//                                     decoration: kInputDecoration.copyWith(
//                                       labelText: 'Manufacturer',
//                                       labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                       hintText: 'Enter Manufacturer Name',
//                                       hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           SizedBox(
//                             width: 300,
//                             child: DottedBorderWidget(
//                               padding: const EdgeInsets.all(6),
//                               color: kLitGreyColor,
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.all(Radius.circular(12)),
//                                 child: Container(
//                                   width: context.width(),
//                                   padding: const EdgeInsets.all(10.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           const Icon(MdiIcons.cloudUpload, size: 50.0, color: kLitGreyColor).onTap(() => pickImage(ImageSource.gallery)),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 5.0),
//                                       RichText(
//                                           text: TextSpan(
//                                               text: 'Upload an image',
//                                               style: kTextStyle.copyWith(color: kGreenTextColor, fontWeight: FontWeight.bold),
//                                               children: [
//                                             TextSpan(
//                                                 text: ' or drag & drop PNG, JPG',
//                                                 style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold))
//                                           ]))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           image != null
//                               ? Image.network(
//                                   image!.path,
//                                   width: 150,
//                                   height: 150,
//                                 )
//                               : Container(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Container(
//                                   padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     color: kRedTextColor,
//                                   ),
//                                   child: Text(
//                                     'Cancel',
//                                     style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                   )).onTap(() => {finish(context)}),
//                               const SizedBox(width: 10.0),
//                               Container(
//                                   padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     color: kBlueTextColor,
//                                   ),
//                                   child: Text(
//                                     'Submit',
//                                     style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                   )).onTap(() => {finish(context)})
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showHoldPopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: SizedBox(
//                 width: 500,
//                 height: 200,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Hold',
//                             style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
//                           ),
//                           const Spacer(),
//                           const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
//                         ],
//                       ),
//                     ),
//                     const Divider(thickness: 1.0, color: kLitGreyColor),
//                     const SizedBox(height: 10.0),
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         children: [
//                           AppTextField(
//                             showCursor: true,
//                             cursorColor: kTitleColor,
//                             textFieldType: TextFieldType.NAME,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Hold Number',
//                               hintText: '2090.00',
//                               hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                               labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                             ),
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Container(
//                                   padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     color: kRedTextColor,
//                                   ),
//                                   child: Text(
//                                     'Cancel',
//                                     style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                   )).onTap(() => {finish(context)}),
//                               const SizedBox(width: 10.0),
//                               Container(
//                                   padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     color: kBlueTextColor,
//                                   ),
//                                   child: Text(
//                                     'Submit',
//                                     style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                   )).onTap(() => {finish(context)})
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showCalcPopUp() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: SizedBox(
//                 width: 300,
//                 height: 550,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [CalcButton()],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showBrandPopUp() {
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: SizedBox(
//                 width: 600,
//                 height: context.height() / 2.5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(4.0),
//                             decoration: const BoxDecoration(shape: BoxShape.rectangle),
//                             child: const Icon(
//                               FeatherIcons.plus,
//                               color: kTitleColor,
//                             ),
//                           ),
//                           const SizedBox(width: 4.0),
//                           Text(
//                             'Add Brand',
//                             style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                           ),
//                           const Spacer(),
//                           const Icon(
//                             FeatherIcons.x,
//                             color: kTitleColor,
//                             size: 21.0,
//                           ).onTap(() {
//                             finish(context);
//                           })
//                         ],
//                       ),
//                       const SizedBox(height: 20.0),
//                       Divider(
//                         thickness: 1.0,
//                         color: kGreyTextColor.withOpacity(0.2),
//                       ),
//                       const SizedBox(height: 10.0),
//                       Row(
//                         children: [
//                           Text(
//                             'Name*',
//                             style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
//                           ),
//                           const SizedBox(width: 50),
//                           SizedBox(
//                             width: 400,
//                             child: Expanded(
//                               child: AppTextField(
//                                 showCursor: true,
//                                 cursorColor: kTitleColor,
//                                 textFieldType: TextFieldType.NAME,
//                                 decoration: kInputDecoration.copyWith(
//                                   hintText: 'Name',
//                                   hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10.0),
//                       Divider(
//                         thickness: 1.0,
//                         color: kGreyTextColor.withOpacity(0.2),
//                       ),
//                       const SizedBox(height: 5.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10.0),
//                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
//                             child: Text(
//                               'Cancel',
//                               style: kTextStyle.copyWith(color: kWhiteTextColor),
//                             ),
//                           ).onTap(() {
//                             finish(context);
//                           }),
//                           const SizedBox(
//                             width: 5.0,
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(10.0),
//                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
//                             child: Text(
//                               'Submit',
//                               style: kTextStyle.copyWith(color: kWhiteTextColor),
//                             ),
//                           ).onTap(() {
//                             finish(context);
//                           })
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//         });
//   }
//
//   void showCategoryAddPopUp() {
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: SizedBox(
//                 width: 600,
//                 height: context.height() / 1.6,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(4.0),
//                             decoration: const BoxDecoration(shape: BoxShape.rectangle),
//                             child: const Icon(
//                               FeatherIcons.plus,
//                               color: kTitleColor,
//                             ),
//                           ),
//                           const SizedBox(width: 4.0),
//                           Text(
//                             'Add Item Category',
//                             style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                           ),
//                           const Spacer(),
//                           const Icon(
//                             FeatherIcons.x,
//                             color: kTitleColor,
//                             size: 21.0,
//                           ).onTap(() {
//                             finish(context);
//                           })
//                         ],
//                       ),
//                       const SizedBox(height: 20.0),
//                       Divider(
//                         thickness: 1.0,
//                         color: kGreyTextColor.withOpacity(0.2),
//                       ),
//                       const SizedBox(height: 10.0),
//                       Row(
//                         children: [
//                           Text(
//                             'Name*',
//                             style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
//                           ),
//                           const SizedBox(width: 50),
//                           SizedBox(
//                             width: 400,
//                             child: Expanded(
//                               child: AppTextField(
//                                 showCursor: true,
//                                 cursorColor: kTitleColor,
//                                 textFieldType: TextFieldType.NAME,
//                                 decoration: kInputDecoration.copyWith(
//                                   hintText: 'Name',
//                                   hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10.0),
//                       Text(
//                         'Select Variations:',
//                         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ListTile(
//                               leading: Checkbox(
//                                 activeColor: kMainColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 value: isChecked,
//                                 onChanged: (val) {
//                                   setState(
//                                     () {
//                                       isChecked = val!;
//                                     },
//                                   );
//                                 },
//                               ),
//                               title: const Text('Size'),
//                             ),
//                           ),
//                           Expanded(
//                             child: ListTile(
//                               leading: Checkbox(
//                                 activeColor: kMainColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 value: isChecked,
//                                 onChanged: (val) {
//                                   setState(
//                                     () {
//                                       isChecked = val!;
//                                     },
//                                   );
//                                 },
//                               ),
//                               title: const Text('Color'),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ListTile(
//                               leading: Checkbox(
//                                 activeColor: kMainColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 value: isChecked,
//                                 onChanged: (val) {
//                                   setState(
//                                     () {
//                                       isChecked = val!;
//                                     },
//                                   );
//                                 },
//                               ),
//                               title: const Text(''
//                                   'Weight'),
//                             ),
//                           ),
//                           Expanded(
//                             child: ListTile(
//                               leading: Checkbox(
//                                 activeColor: kMainColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 value: isChecked,
//                                 onChanged: (val) {
//                                   setState(
//                                     () {
//                                       isChecked = val!;
//                                     },
//                                   );
//                                 },
//                               ),
//                               title: const Text('Capacity'),
//                             ),
//                           ),
//                         ],
//                       ),
//                       ListTile(
//                         leading: Checkbox(
//                           activeColor: kMainColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                           ),
//                           value: isChecked,
//                           onChanged: (val) {
//                             setState(
//                               () {
//                                 isChecked = val!;
//                               },
//                             );
//                           },
//                         ),
//                         title: const Text(''
//                             'Type'),
//                       ),
//                       const SizedBox(height: 5.0),
//                       Divider(
//                         thickness: 1.0,
//                         color: kGreyTextColor.withOpacity(0.2),
//                       ),
//                       const SizedBox(height: 5.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10.0),
//                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
//                             child: Text(
//                               'Cancel',
//                               style: kTextStyle.copyWith(color: kWhiteTextColor),
//                             ),
//                           ).onTap(() {
//                             finish(context);
//                           }),
//                           const SizedBox(
//                             width: 5.0,
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(10.0),
//                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
//                             child: Text(
//                               'Submit',
//                               style: kTextStyle.copyWith(color: kWhiteTextColor),
//                             ),
//                           ).onTap(() {
//                             finish(context);
//                           })
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//         });
//   }
//
//   void showUnitPopUp() {
//     showDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: SizedBox(
//               height: 320,
//               width: 600,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(4.0),
//                           decoration: const BoxDecoration(shape: BoxShape.rectangle),
//                           child: const Icon(
//                             FeatherIcons.plus,
//                             color: kTitleColor,
//                           ),
//                         ),
//                         const SizedBox(width: 4.0),
//                         Text(
//                           'Add Unit',
//                           style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         const Icon(
//                           FeatherIcons.x,
//                           color: kTitleColor,
//                           size: 21.0,
//                         ).onTap(() {
//                           finish(context);
//                         })
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Divider(
//                       thickness: 1.0,
//                       color: kGreyTextColor.withOpacity(0.2),
//                     ),
//                     const SizedBox(height: 10.0),
//                     Row(
//                       children: [
//                         Text(
//                           'Name*',
//                           style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
//                         ),
//                         const SizedBox(width: 50),
//                         SizedBox(
//                           width: 400,
//                           child: Expanded(
//                             child: AppTextField(
//                               showCursor: true,
//                               cursorColor: kTitleColor,
//                               textFieldType: TextFieldType.NAME,
//                               decoration: kInputDecoration.copyWith(
//                                 hintText: 'Name',
//                                 hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10.0),
//                     Row(
//                       children: [
//                         Text(
//                           'Description',
//                           style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
//                         ),
//                         const SizedBox(width: 10.0),
//                         SizedBox(
//                           width: 400,
//                           child: Expanded(
//                             child: AppTextField(
//                               showCursor: true,
//                               cursorColor: kTitleColor,
//                               textFieldType: TextFieldType.NAME,
//                               decoration: kInputDecoration.copyWith(
//                                 hintText: 'Description',
//                                 hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5.0),
//                     Divider(
//                       thickness: 1.0,
//                       color: kGreyTextColor.withOpacity(0.2),
//                     ),
//                     const SizedBox(height: 5.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(10.0),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
//                           child: Text(
//                             'Cancel',
//                             style: kTextStyle.copyWith(color: kWhiteTextColor),
//                           ),
//                         ).onTap(() {
//                           finish(context);
//                         }),
//                         const SizedBox(
//                           width: 5.0,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(10.0),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
//                           child: Text(
//                             'Submit',
//                             style: kTextStyle.copyWith(color: kWhiteTextColor),
//                           ),
//                         ).onTap(() {
//                           finish(context);
//                         })
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   TextEditingController nameCodeCategoryController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, consumerRef, __) {
//         final customerList = consumerRef.watch(buyerCustomerProvider);
//         final providerData = consumerRef.watch(cartNotifier);
//         final personalData = consumerRef.watch(profileDetailsProvider);
//         AsyncValue<List<ProductModel>> productList = consumerRef.watch(productProvider);
//         return personalData.when(data: (data) {
//           return Scaffold(
//             backgroundColor: kDarkWhite,
//             body: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                             child: Card(
//                                 color: Colors.white,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                   side: const BorderSide(color: kLitGreyColor),
//                                 ),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: const BoxDecoration(),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(
//                                         MdiIcons.replay,
//                                         color: kTitleColor,
//                                         size: 18.0,
//                                       ),
//                                       const SizedBox(width: 4.0),
//                                       Text(
//                                         'Sale List',
//                                         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 )).onTap(() => showSaleListPopUp())).visible(false),
//                         Expanded(
//                           child: Card(
//                               color: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: const BorderSide(color: kLitGreyColor),
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: const BoxDecoration(),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Icon(
//                                       Icons.speed,
//                                       color: kTitleColor,
//                                       size: 18.0,
//                                     ),
//                                     const SizedBox(width: 4.0),
//                                     Text(
//                                       'Dashboard',
//                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               )).onTap(() => Navigator.of(context).pushNamed(TablateHome.route)),
//                         ),
//                         Expanded(
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: const BoxDecoration(),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     FeatherIcons.user,
//                                     color: kTitleColor,
//                                     size: 18.0,
//                                   ),
//                                   const SizedBox(width: 4.0),
//                                   Text(
//                                     'Welcome: Rahim',
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             height: 50.0,
//                             child: Card(
//                               color: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: const BorderSide(color: kLitGreyColor),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0),
//                                 child: AppTextField(
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: InputDecoration(
//                                     prefixIcon: const Icon(FeatherIcons.search, color: kTitleColor, size: 18.0),
//                                     hintText: 'Name or Code or Product Name',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ).visible(false),
//                         productList.when(data: (product) {
//                           return Expanded(
//                             child: SizedBox(
//                               height: 50.0,
//                               child: Card(
//                                 color: Colors.white,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                   side: const BorderSide(color: kLitGreyColor),
//                                 ),
//                                 child: AppTextField(
//                                   controller: nameCodeCategoryController,
//                                   showCursor: true,
//                                   focus: nameFocus,
//                                   autoFocus: true,
//                                   cursorColor: kTitleColor,
//                                   onFieldSubmitted: (value) {
//                                     if (product.isEmpty) {
//                                       EasyLoading.showError('No Product Found');
//                                     }
//                                     for (int i = 0; i < product.length; i++) {
//                                       if (product[i].productCode == value) {
//                                         AddToCartModel addToCartModel = AddToCartModel(
//                                           productName: product[i].productName,
//                                           productId: product[i].productCode,
//                                           unitPrice: selectedCategories == 'Retail Price'
//                                               ? product[i].productSalePrice
//                                               : selectedCategories == 'Wholesale Price'
//                                                   ? product[i].productWholeSalePrice
//                                                   : product[i].productDealerPrice,
//                                           subTotal: selectedCategories == 'Retail Price'
//                                               ? product[i].productSalePrice
//                                               : selectedCategories == 'Wholesale Price'
//                                                   ? product[i].productWholeSalePrice
//                                                   : product[i].productDealerPrice,
//                                         );
//                                         setState(() {
//                                           if (!uniqueCheck(product[i].productCode)) {
//                                             cartList.add(addToCartModel);
//                                             nameCodeCategoryController.clear();
//                                             nameFocus.requestFocus();
//                                           } else {
//                                             nameCodeCategoryController.clear();
//                                             nameFocus.requestFocus();
//                                             print('Already Added');
//                                           }
//                                         });
//                                         break;
//                                       }
//                                       if (i + 1 == product.length) {
//                                         nameCodeCategoryController.clear();
//                                         nameFocus.requestFocus();
//                                         EasyLoading.showError('Not found');
//                                       }
//                                       print(i);
//                                       print(product.length);
//                                     }
//                                   },
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: InputDecoration(
//                                     prefixIcon: const Icon(MdiIcons.barcode, color: kTitleColor, size: 18.0),
//                                     suffixIcon: const Icon(FeatherIcons.plusSquare, color: kTitleColor, size: 18.0).onTap(() => showAddItemPopUp()),
//                                     hintText: 'Name or Code or Category',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }, error: (e, stack) {
//                           return Center(
//                             child: Text(e.toString()),
//                           );
//                         }, loading: () {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }),
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Consumer(
//                       builder: (_, ref, watch) {
//                         AsyncValue<List<ProductModel>> productList = ref.watch(productProvider);
//                         return productList.when(data: (products) {
//                           return products.isNotEmpty
//                               ? Card(
//                                   elevation: 1,
//                                   child: SizedBox(
//                                     height: context.height() / 4.5,
//                                     child: Container(
//                                       decoration: const BoxDecoration(
//                                         color: kDarkWhite,
//                                       ),
//                                       child: HorizontalList(
//                                           padding: EdgeInsets.zero,
//                                           spacing: 10.0,
//                                           itemCount: products.length,
//                                           itemBuilder: (_, i) {
//                                             return Card(
//                                               elevation: 0,
//                                               color: kWhiteTextColor,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(5.0),
//                                                 side: const BorderSide(
//                                                   color: kLitGreyColor,
//                                                 ),
//                                               ),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Stack(
//                                                     alignment: Alignment.topLeft,
//                                                     children: [
//                                                       Container(
//                                                         height: 130,
//                                                         width: 130,
//                                                         decoration: BoxDecoration(
//                                                           image: DecorationImage(
//                                                             image: NetworkImage(products[i].productPicture),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Positioned(
//                                                         left: 5,
//                                                         top: 5,
//                                                         child: Container(
//                                                           padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//                                                           decoration: BoxDecoration(color: products[i].productStock == '0' ? kRedTextColor : kGreenTextColor),
//                                                           child: Text(
//                                                             products[i].productStock != '0' ? '${products[i].productStock} pc' : 'Out of stock',
//                                                             style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.all(10.0),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Text(
//                                                           products[i].productName,
//                                                           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                         ),
//                                                         const SizedBox(height: 4.0),
//                                                         Text(
//                                                           products[i].productCode,
//                                                           maxLines: 1,
//                                                           style: kTextStyle.copyWith(color: kGreyTextColor),
//                                                         ),
//                                                         const SizedBox(height: 4.0),
//                                                         Container(
//                                                           padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//                                                           decoration: BoxDecoration(color: kGreenTextColor, borderRadius: BorderRadius.circular(2.0)),
//                                                           child: Text(
//                                                             selectedCategories == 'Retail Price'
//                                                                 ? '${currency} ${products[i].productSalePrice}'
//                                                                 : selectedCategories == 'Wholesale Price'
//                                                                     ? '${currency} ${products[i].productWholeSalePrice}'
//                                                                     : '${currency} ${products[i].productDealerPrice}',
//                                                             style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold, fontSize: 14.0),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ).onTap(() {
//                                               setState(() {
//                                                 AddToCartModel addToCartModel = AddToCartModel(
//                                                   productName: products[i].productName,
//                                                   productId: products[i].productCode,
//                                                   unitPrice: selectedCategories == 'Retail Price'
//                                                       ? '${products[i].productSalePrice}'
//                                                       : selectedCategories == 'Wholesale Price'
//                                                           ? '${products[i].productWholeSalePrice}'
//                                                           : '${products[i].productDealerPrice}',
//                                                   subTotal: selectedCategories == 'Retail Price'
//                                                       ? products[i].productSalePrice
//                                                       : selectedCategories == 'Wholesale Price'
//                                                           ? products[i].productWholeSalePrice
//                                                           : products[i].productDealerPrice,
//                                                 );
//                                                 if (!uniqueCheck(products[i].productCode)) {
//                                                   cartList.add(addToCartModel);
//                                                 } else {
//                                                   print('Already Added');
//                                                 }
//                                               });
//                                             });
//                                           }),
//                                     ),
//                                   ))
//                               : const Center(
//                                   child: Text(
//                                     'Please Add A Product',
//                                     maxLines: 2,
//                                     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
//                                   ),
//                                 );
//                         }, error: (e, stack) {
//                           return Center(
//                             child: Text(e.toString()),
//                           );
//                         }, loading: () {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Expanded(
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: Container(
//                               padding: const EdgeInsets.all(10.0),
//                               decoration: const BoxDecoration(),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     MdiIcons.folderOutline,
//                                     color: kTitleColor,
//                                     size: 18.0,
//                                   ),
//                                   const SizedBox(width: 4.0),
//                                   Text(
//                                     'DEU LIST',
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ).onTap(
//                             () => showDueListPopUp(),
//                           ),
//                         ).visible(false),
//                         Expanded(
//                           child: Card(
//                               color: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: const BorderSide(color: kLitGreyColor),
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.all(10.0),
//                                 decoration: const BoxDecoration(),
//                                 child: Center(
//                                   child: Text(
//                                     '${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}',
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ).onTap(() => _selectedDueDate(context))),
//                         ),
//                         const Spacer(),
//                         Text(
//                           'Previous Due:',
//                           style: kTextStyle.copyWith(color: kTitleColor),
//                         ),
//                         Expanded(
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: const BoxDecoration(),
//                               child: Center(
//                                 child: Text(
//                                   '${currency}$previousDue',
//                                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Card(
//                               color: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: const BorderSide(color: kLitGreyColor),
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: const BoxDecoration(),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Icon(
//                                       MdiIcons.calculator,
//                                       color: kTitleColor,
//                                       size: 18.0,
//                                     ),
//                                     const SizedBox(width: 4.0),
//                                     Text(
//                                       'Calculator',
//                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               )).onTap(() => showCalcPopUp()),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         customerList.when(data: (customer) {
//                           return Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: SizedBox(
//                               width: 350,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   SizedBox(width: 300.0, child: DropdownButtonHideUnderline(child: getResult(customer))),
//                                   const Spacer(),
//                                   Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: const BoxDecoration(color: kBlueTextColor),
//                                     child: const Icon(
//                                       FeatherIcons.userPlus,
//                                       color: Colors.white,
//                                       size: 18.0,
//                                     ),
//                                   ).onTap(() => showCreateCustomerPopUp())
//                                 ],
//                               ),
//                             ),
//                           );
//                         }, error: (e, stack) {
//                           return Center(
//                             child: Text(e.toString()),
//                           );
//                         }, loading: () {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }),
//                         const SizedBox(width: 50.0),
//                         Expanded(
//                           child: Card(
//                               color: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: const BorderSide(color: kLitGreyColor),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0),
//                                 child: DropdownButtonHideUnderline(child: getCategories()),
//                               )),
//                         ),
//                         Expanded(
//                             child: SizedBox(
//                           height: 55.0,
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: Center(
//                                 child: Text(
//                               'Invoice Number: #${data.saleInvoiceCounter.toString()}',
//                               style: const TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
//                             )),
//                           ),
//                         )),
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 5,
//                           child: Card(
//                             elevation: 1,
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 color: kWhiteTextColor,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     width: context.width(),
//                                     height: context.height() / 3.5,
//                                     child: SingleChildScrollView(
//                                       child: DataTable(
//                                           headingRowColor: MaterialStateProperty.all(kWhiteTextColor),
//                                           showBottomBorder: true,
//                                           headingTextStyle: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                           columns: const [
//                                             DataColumn(
//                                               label: Text(
//                                                 'Product',
//                                               ),
//                                             ),
//                                             DataColumn(
//                                               label: Text('Price'),
//                                             ),
//                                             DataColumn(
//                                               label: Text('Quantity'),
//                                             ),
//                                             DataColumn(
//                                               label: Text('Subtotal'),
//                                             ),
//                                             DataColumn(
//                                               label: Text('Action'),
//                                             ),
//                                           ],
//                                           rows: List.generate(
//                                             cartList.length,
//                                             (index) => DataRow(cells: [
//                                               DataCell(
//                                                 Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       cartList[index].productName ?? '',
//                                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Text(
//                                                           'MIEI/Serial: ${cartList[index].productId}',
//                                                           style: kTextStyle.copyWith(color: kTitleColor),
//                                                         ),
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Text(
//                                                   '${currency} ${cartList[index].unitPrice}',
//                                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Row(
//                                                   children: [
//                                                     const Icon(FontAwesomeIcons.solidSquareMinus, color: kBlueTextColor).onTap(() {
//                                                       setState(() {
//                                                         cartList[index].quantity > 1 ? cartList[index].quantity-- : cartList[index].quantity = 1;
//                                                       });
//                                                     }),
//                                                     Container(
//                                                         padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
//                                                         decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.circular(2.0),
//                                                           color: Colors.white,
//                                                         ),
//                                                         child: Text(cartList[index].quantity.toString())),
//                                                     const Icon(FontAwesomeIcons.solidSquarePlus, color: kBlueTextColor).onTap(() {
//                                                       setState(() {
//                                                         cartList[index].quantity += 1;
//                                                         toast(cartList[index].quantity.toString());
//                                                       });
//                                                     }),
//                                                   ],
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Text(
//                                                   (double.parse(cartList[index].unitPrice) * cartList[index].quantity).toString(),
//                                                   style: kTextStyle.copyWith(color: kTitleColor),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 const Icon(
//                                                   Icons.close_sharp,
//                                                   color: redColor,
//                                                 ).onTap(() {
//                                                   setState(() {
//                                                     cartList.removeAt(index);
//                                                   });
//                                                 }),
//                                               ),
//                                             ]),
//                                           )),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               flex: 2,
//                                               child: Text(
//                                                 'Total Item: ${cartList.length}',
//                                                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                             Expanded(
//                                               flex: 1,
//                                               child: Column(
//                                                 children: [
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                     children: [
//                                                       Text(
//                                                         'Sub Total',
//                                                         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                       ),
//                                                       const Spacer(),
//                                                       Container(
//                                                         padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                         decoration: const BoxDecoration(color: kGreenTextColor),
//                                                         child: Center(
//                                                           child: Text(
//                                                             '${currency} ${getTotalAmount()}',
//                                                             textAlign: TextAlign.end,
//                                                             style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   const SizedBox(height: 10.0),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                     children: [
//                                                       Text(
//                                                         'VAT/GST',
//                                                         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                       ),
//                                                       const Spacer(),
//                                                       Container(
//                                                         padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                         decoration: const BoxDecoration(color: kLitGreyColor),
//                                                         child: Text(
//                                                           '0%',
//                                                           style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   const SizedBox(height: 10.0),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                     children: [
//                                                       Text(
//                                                         'Service/Shipping',
//                                                         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                       ),
//                                                       const Spacer(),
//                                                       Container(
//                                                         padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                         decoration: const BoxDecoration(color: kLitGreyColor),
//                                                         child: Text(
//                                                           '${currency}0.00',
//                                                           style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   const SizedBox(height: 10.0),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.end,
//                                                     children: [
//                                                       Text(
//                                                         'Discount',
//                                                         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                       ),
//                                                       const Spacer(),
//                                                       Container(
//                                                         padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                         decoration: const BoxDecoration(color: kLitGreyColor),
//                                                         child: Text(
//                                                           '${currency}0.00',
//                                                           style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 20.0),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Expanded(
//                                               flex: 1,
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(10.0),
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.rectangle,
//                                                   borderRadius: BorderRadius.circular(2.0),
//                                                   color: kRedTextColor,
//                                                 ),
//                                                 child: Text(
//                                                   'Cancel',
//                                                   textAlign: TextAlign.center,
//                                                   style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 10.0),
//                                             Expanded(
//                                               flex: 1,
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(10.0),
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.rectangle,
//                                                   borderRadius: BorderRadius.circular(2.0),
//                                                   color: Colors.black,
//                                                 ),
//                                                 child: Text(
//                                                   'Quotation',
//                                                   textAlign: TextAlign.center,
//                                                   style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                 ),
//                                               ),
//                                             ).visible(false),
//                                             const SizedBox(width: 10.0),
//                                             Expanded(
//                                                 flex: 1,
//                                                 child: Container(
//                                                   padding: const EdgeInsets.all(10.0),
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.rectangle,
//                                                     borderRadius: BorderRadius.circular(2.0),
//                                                     color: Colors.yellow,
//                                                   ),
//                                                   child: Text(
//                                                     'Hold',
//                                                     textAlign: TextAlign.center,
//                                                     style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ).onTap(() => showHoldPopUp())).visible(false),
//                                             const SizedBox(width: 10.0),
//                                             Expanded(
//                                                 flex: 1,
//                                                 child: Container(
//                                                   padding: const EdgeInsets.all(10.0),
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.rectangle,
//                                                     borderRadius: BorderRadius.circular(2.0),
//                                                     color: kGreenTextColor,
//                                                   ),
//                                                   child: Text(
//                                                     'Payment',
//                                                     textAlign: TextAlign.center,
//                                                     style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ).onTap(() {
//                                                   TransitionModel transitionModel = TransitionModel(
//                                                       customerName: selectedUserName.customerName,
//                                                       customerType: selectedUserName.type,
//                                                       customerPhone: selectedUserName.phoneNumber,
//                                                       invoiceNumber: data.saleInvoiceCounter.toString(),
//                                                       purchaseDate: DateTime.now().toString(),
//                                                       productList: cartList);
//
//                                                   showDialog(
//                                                     barrierDismissible: false,
//                                                     context: context,
//                                                     builder: (BuildContext context) {
//                                                       return StatefulBuilder(
//                                                         builder: (context, setState) {
//                                                           return Dialog(
//                                                               shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.circular(5.0),
//                                                               ),
//                                                               child: TabShowPaymentPopUp(
//                                                                 transitionModel: transitionModel,
//                                                               ));
//                                                         },
//                                                       );
//                                                     },
//                                                   );
//                                                 })),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }, error: (e, stack) {
//           return Center(
//             child: Text(e.toString()),
//           );
//         }, loading: () {
//           return const Center(child: CircularProgressIndicator());
//         });
//       },
//     );
//   }
// }
