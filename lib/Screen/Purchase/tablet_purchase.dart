// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:salespro_admin/Screen/Home/tablate_home.dart';
//
// import '../../Provider/customer_provider.dart';
// import '../../Provider/product_provider.dart';
// import '../../Provider/profile_provider.dart';
// import '../../model/customer_model.dart';
// import '../../model/product_model.dart';
// import '../../model/transition_model.dart';
// import '../Widgets/Calculator/calculator.dart';
// import '../Widgets/Constant Data/constant.dart';
// import '../Widgets/Pop UP/Purchase/purchase_show_add_item_popup.dart';
// import '../Widgets/Pop UP/Purchase/tab_purchase_create_customer_popup.dart';
// import '../Widgets/Pop UP/Purchase/tab_purchase_due_sale_popup.dart';
// import '../Widgets/Pop UP/Purchase/tab_purchase_payment_popup.dart';
// import '../Widgets/Pop UP/Purchase/tab_purchase_sale_list_popup.dart';
//
// class TabletPurchase extends StatefulWidget {
//   const TabletPurchase({Key? key}) : super(key: key);
//
//   static const String route = 'mpurchase';
//
//   @override
//   State<TabletPurchase> createState() => _TabletPurchaseState();
// }
//
// class _TabletPurchaseState extends State<TabletPurchase> {
//   bool isChecked = true;
//
//   bool uniqueCheck(String code) {
//     bool isUnique = false;
//     for (var item in cartList) {
//       if (item.productCode == code) {
//         item.productStock = (item.productStock.toInt() + 1).toString();
//         isUnique = true;
//         break;
//       }
//     }
//     return isUnique;
//   }
//
//   String getTotalAmount() {
//     double total = 0.0;
//     for (var item in cartList) {
//       total = total + (double.parse(item.productPurchasePrice) * item.productStock.toInt());
//     }
//     return total.toString();
//   }
//
//   List<ProductModel> cartList = [];
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
//     'Purchase Price',
//   ];
//
//   String selectedCategories = 'Purchase Price';
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
//   //Create Customer
//   List<CustomerModel> customerLists = [];
//   String? selectedUserId;
//   String previousDue = "0";
//   String? invoiceNumber;
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
//   CustomerModel defaultCustomer = CustomerModel(
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
//           child: const TabPurchaseDueSalePopUp(),
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
//                 child: const TabPurchaseSaleListPopUp());
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
//               child: const TabPurchaseCreateCustomerPopUp(),
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
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//                 child: const PurchaseShowAddItemPopUp());
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
//   TextEditingController nameCodeCategoryController = TextEditingController();
//   FocusNode nameFocus = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer(builder: (context, consumerRef, __) {
//         AsyncValue<List<ProductModel>> productList = consumerRef.watch(productProvider);
//         final customerList = consumerRef.watch(supplierProvider);
//         final personalData = consumerRef.watch(profileDetailsProvider);
//         return personalData.when(data: (data) {
//           return Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
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
//                                       MdiIcons.replay,
//                                       color: kTitleColor,
//                                       size: 18.0,
//                                     ),
//                                     const SizedBox(width: 4.0),
//                                     Text(
//                                       'Sale List',
//                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               )).onTap(() => showSaleListPopUp())).visible(false),
//                       Expanded(
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
//                               )).onTap(
//                         () => Navigator.pushNamed(context, TablateHome.route),
//                       )),
//                       Expanded(
//                         child: Card(
//                           color: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             side: const BorderSide(color: kLitGreyColor),
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: const BoxDecoration(),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   FeatherIcons.user,
//                                   color: kTitleColor,
//                                   size: 18.0,
//                                 ),
//                                 const SizedBox(width: 4.0),
//                                 Text(
//                                   'Welcome ${data.companyName.toString()}',
//                                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: SizedBox(
//                           height: 50,
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 5.0),
//                               child: AppTextField(
//                                 showCursor: true,
//                                 cursorColor: kTitleColor,
//                                 textFieldType: TextFieldType.NAME,
//                                 decoration: InputDecoration(
//                                   prefixIcon: const Icon(FeatherIcons.search, color: kTitleColor, size: 18.0),
//                                   hintText: 'Name or Code or Product Name',
//                                   hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ).visible(false),
//                       productList.when(data: (product) {
//                         return Expanded(
//                           child: SizedBox(
//                             height: 50,
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
//                                   focus: nameFocus,
//                                   autoFocus: true,
//                                   controller: nameCodeCategoryController,
//                                   onFieldSubmitted: (value) {
//                                     if (product.isEmpty) {
//                                       EasyLoading.showError('No Product Found');
//                                     }
//                                     for (int i = 0; i < product.length; i++) {
//                                       if (product[i].productCode == value) {
//                                         ProductModel productModel = ProductModel(
//                                           product[i].productName,
//                                           product[i].productCategory,
//                                           product[i].size,
//                                           product[i].color,
//                                           product[i].weight,
//                                           product[i].capacity,
//                                           product[i].type,
//                                           product[i].warranty,
//                                           product[i].brandName,
//                                           product[i].productCode,
//                                           '1',
//                                           product[i].productUnit,
//                                           product[i].productSalePrice,
//                                           product[i].productPurchasePrice,
//                                           product[i].productDiscount,
//                                           product[i].productWholeSalePrice,
//                                           product[i].productDealerPrice,
//                                           product[i].productManufacturer,
//                                           product[i].productPicture,
//                                           [],
//                                         );
//                                         setState(() {
//                                           if (!uniqueCheck(product[i].productCode)) {
//                                             cartList.add(productModel);
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
//                                   showCursor: true,
//                                   cursorColor: kTitleColor,
//                                   textFieldType: TextFieldType.NAME,
//                                   decoration: InputDecoration(
//                                     prefixIcon: const Icon(MdiIcons.barcode, color: kTitleColor, size: 18.0),
//                                     // suffixIcon: const Icon(FeatherIcons.plusSquare, color: kTitleColor, size: 18.0).onTap(() => showAddItemPopUp()),
//                                     hintText: 'Name or Code or Category',
//                                     hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }, error: (e, stack) {
//                         return Center(
//                           child: Text(e.toString()),
//                         );
//                       }, loading: () {
//                         return const Center(child: CircularProgressIndicator());
//                       })
//                     ],
//                   ),
//                   const SizedBox(height: 20.0),
//                   Consumer(
//                     builder: (_, ref, watch) {
//                       AsyncValue<List<ProductModel>> productList = ref.watch(productProvider);
//                       return productList.when(data: (products) {
//                         return products.isNotEmpty
//                             ? Card(
//                                 elevation: 1,
//                                 child: SizedBox(
//                                   height: context.height() / 4.5,
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       color: kDarkWhite,
//                                     ),
//                                     child: HorizontalList(
//                                         padding: EdgeInsets.zero,
//                                         spacing: 10.0,
//                                         itemCount: products.length,
//                                         itemBuilder: (_, i) {
//                                           return Card(
//                                             elevation: 0,
//                                             color: kWhiteTextColor,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(5.0),
//                                               side: const BorderSide(
//                                                 color: kLitGreyColor,
//                                               ),
//                                             ),
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Stack(
//                                                   alignment: Alignment.topLeft,
//                                                   children: [
//                                                     Container(
//                                                       height: 130,
//                                                       width: 130,
//                                                       decoration: BoxDecoration(
//                                                         image: DecorationImage(
//                                                           image: NetworkImage(products[i].productPicture),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Positioned(
//                                                       left: 5,
//                                                       top: 5,
//                                                       child: Container(
//                                                         padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//                                                         decoration: BoxDecoration(color: products[i].productStock == '0' ? kRedTextColor : kGreenTextColor),
//                                                         child: Text(
//                                                           products[i].productStock != '0' ? '${products[i].productStock} pc' : 'Out of stock',
//                                                           style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.all(10.0),
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text(
//                                                         products[i].productName,
//                                                         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                       ),
//                                                       const SizedBox(height: 4.0),
//                                                       Text(
//                                                         products[i].productCode,
//                                                         maxLines: 1,
//                                                         style: kTextStyle.copyWith(color: kGreyTextColor),
//                                                       ),
//                                                       const SizedBox(height: 4.0),
//                                                       Container(
//                                                         padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//                                                         decoration: BoxDecoration(color: kGreenTextColor, borderRadius: BorderRadius.circular(2.0)),
//                                                         child: Text(
//                                                           "${currency}${products[i].productPurchasePrice}",
//                                                           style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold, fontSize: 14.0),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ).onTap(() {
//                                             setState(() {
//                                               ProductModel productModel = ProductModel(
//                                                 products[i].productName,
//                                                 products[i].productCategory,
//                                                 products[i].size,
//                                                 products[i].color,
//                                                 products[i].weight,
//                                                 products[i].capacity,
//                                                 products[i].type,
//                                                 products[i].warranty,
//                                                 products[i].brandName,
//                                                 products[i].productCode,
//                                                 '1',
//                                                 products[i].productUnit,
//                                                 products[i].productSalePrice,
//                                                 products[i].productPurchasePrice,
//                                                 products[i].productDiscount,
//                                                 products[i].productWholeSalePrice,
//                                                 products[i].productDealerPrice,
//                                                 products[i].productManufacturer,
//                                                 products[i].productPicture,
//                                                 [],
//                                               );
//                                               if (!uniqueCheck(products[i].productCode)) {
//                                                 cartList.add(productModel);
//                                               } else {
//                                                 print('Already Added');
//                                               }
//                                             });
//                                           });
//                                         }),
//                                   ),
//                                 ))
//                             : const Center(
//                                 child: Text(
//                                   'Please Add A Product',
//                                   maxLines: 2,
//                                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
//                                 ),
//                               );
//                       }, error: (e, stack) {
//                         return Center(
//                           child: Text(e.toString()),
//                         );
//                       }, loading: () {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Expanded(
//                         child: Card(
//                           color: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             side: const BorderSide(color: kLitGreyColor),
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(10.0),
//                             decoration: const BoxDecoration(),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   MdiIcons.folderOutline,
//                                   color: kTitleColor,
//                                   size: 18.0,
//                                 ),
//                                 const SizedBox(width: 4.0),
//                                 Text(
//                                   'DEU LIST',
//                                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ).onTap(
//                           () => showDueListPopUp(),
//                         ),
//                       ).visible(false),
//                       Expanded(
//                         child: Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: Container(
//                               padding: const EdgeInsets.all(10.0),
//                               decoration: const BoxDecoration(),
//                               child: Center(
//                                 child: Text(
//                                   '${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}',
//                                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ).onTap(() => _selectedDueDate(context))),
//                       ),
//                       const Spacer(),
//                       Text(
//                         'Previous Due:',
//                         style: kTextStyle.copyWith(color: kTitleColor),
//                       ),
//                       Expanded(
//                         child: Card(
//                           color: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             side: const BorderSide(color: kLitGreyColor),
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: const BoxDecoration(),
//                             child: Center(
//                               child: Text(
//                                 '${currency}$previousDue',
//                                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Card(
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
//                                     MdiIcons.calculator,
//                                     color: kTitleColor,
//                                     size: 18.0,
//                                   ),
//                                   const SizedBox(width: 4.0),
//                                   Text(
//                                     'Calculator',
//                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             )).onTap(() => showCalcPopUp()),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       customerList.when(data: (customer) {
//                         return Card(
//                           color: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             side: const BorderSide(color: kLitGreyColor),
//                           ),
//                           child: SizedBox(
//                             width: 350,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 5.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   SizedBox(width: 300, child: DropdownButtonHideUnderline(child: getResult(customer))),
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
//                           ),
//                         );
//                       }, error: (e, stack) {
//                         return Center(
//                           child: Text(e.toString()),
//                         );
//                       }, loading: () {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }),
//                       const SizedBox(width: 10.0),
//                       Expanded(
//                         child: Card(
//                             color: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               side: const BorderSide(color: kLitGreyColor),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 5.0),
//                               child: DropdownButtonHideUnderline(child: getCategories()),
//                             )),
//                       ),
//                       Expanded(
//                           child: SizedBox(
//                         height: 55.0,
//                         child: Card(
//                           color: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             side: const BorderSide(color: kLitGreyColor),
//                           ),
//                           child: Center(
//                               child: Text(
//                             'Invoice Number: #${data.purchaseInvoiceCounter.toString()}',
//                             style: const TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
//                           )),
//                         ),
//                       )),
//                     ],
//                   ),
//                   const SizedBox(height: 20.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 5,
//                         child: Card(
//                           elevation: 1,
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: kWhiteTextColor,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: context.width(),
//                                   height: context.height() / 3.5,
//                                   child: SingleChildScrollView(
//                                     child: DataTable(
//                                         headingRowColor: MaterialStateProperty.all(kWhiteTextColor),
//                                         showBottomBorder: true,
//                                         horizontalMargin: 10.0,
//                                         sortAscending: false,
//                                         headingTextStyle: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                         columns: [
//                                           DataColumn(
//                                             label: Text(
//                                               'Product',
//                                               textAlign: TextAlign.center,
//                                               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           const DataColumn(
//                                             label: Text('QTY'),
//                                           ),
//                                           const DataColumn(
//                                             label: Text('Unit'),
//                                           ),
//                                           const DataColumn(
//                                             label: Text('Price'),
//                                           ),
//                                           const DataColumn(
//                                             label: Text('Total'),
//                                           ),
//                                           const DataColumn(
//                                             label: Text('Action'),
//                                           ),
//                                         ],
//                                         rows: List.generate(
//                                           cartList.length,
//                                           (index) => DataRow(cells: [
//                                             DataCell(
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     cartList[index].productName,
//                                                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                   ),
//                                                   Row(
//                                                     children: [
//                                                       Flexible(
//                                                         child: Text(
//                                                           'MIEI/Serial: ${cartList[index].productCode}',
//                                                           maxLines: 1,
//                                                           style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12.0),
//                                                           overflow: TextOverflow.ellipsis,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             DataCell(
//                                               SizedBox(
//                                                 width: context.width() / 20,
//                                                 child: AppTextField(
//                                                   maxLines: 1,
//                                                   expands: false,
//                                                   showCursor: true,
//                                                   cursorColor: kTitleColor,
//                                                   controller: TextEditingController(text: cartList[index].productStock.toString()),
//                                                   textFieldType: TextFieldType.NAME,
//                                                   onFieldSubmitted: (value) {
//                                                     setState(() {
//                                                       cartList[index].productStock = value;
//                                                     });
//                                                   },
//                                                   decoration: kInputDecoration.copyWith(
//                                                     enabledBorder: const OutlineInputBorder(
//                                                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                                       borderSide: BorderSide(color: kBorderColorTextField, width: 1),
//                                                     ),
//                                                     focusedBorder: const OutlineInputBorder(
//                                                       borderRadius: BorderRadius.all(Radius.circular(6.0)),
//                                                       borderSide: BorderSide(color: kBorderColorTextField, width: 1),
//                                                     ),
//                                                   ),
//                                                   inputFormatters: [
//                                                     FilteringTextInputFormatter.digitsOnly,
//                                                     LengthLimitingTextInputFormatter(6),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               Text(
//                                                 cartList[index].productUnit,
//                                                 style: kTextStyle.copyWith(color: kTitleColor),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               SizedBox(
//                                                 width: context.width() / 20,
//                                                 child: AppTextField(
//                                                   maxLines: 1,
//                                                   showCursor: true,
//                                                   cursorColor: kTitleColor,
//                                                   controller: TextEditingController(text: cartList[index].productPurchasePrice),
//                                                   textFieldType: TextFieldType.NAME,
//                                                   onFieldSubmitted: (value) {
//                                                     setState(() {
//                                                       cartList[index].productPurchasePrice = value;
//                                                     });
//                                                   },
//                                                   decoration: kInputDecoration.copyWith(
//                                                     enabledBorder: const OutlineInputBorder(
//                                                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                                       borderSide: BorderSide(color: kBorderColorTextField, width: 1),
//                                                     ),
//                                                     focusedBorder: const OutlineInputBorder(
//                                                       borderRadius: BorderRadius.all(Radius.circular(6.0)),
//                                                       borderSide: BorderSide(color: kBorderColorTextField, width: 1),
//                                                     ),
//                                                   ),
//                                                   inputFormatters: [
//                                                     FilteringTextInputFormatter.digitsOnly,
//                                                     LengthLimitingTextInputFormatter(6),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               Text(
//                                                 (double.parse(cartList[index].productPurchasePrice) * cartList[index].productStock.toInt()).toString(),
//                                                 style: kTextStyle.copyWith(color: kTitleColor),
//                                               ),
//                                             ),
//                                             DataCell(
//                                               const Icon(
//                                                 Icons.close_sharp,
//                                                 color: redColor,
//                                               ).onTap(() {
//                                                 setState(() {
//                                                   cartList.removeAt(index);
//                                                 });
//                                               }),
//                                             ),
//                                           ]),
//                                         )),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                             flex: 2,
//                                             child: Text(
//                                               'Total Item: ${cartList.length}',
//                                               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 1,
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                   children: [
//                                                     Text(
//                                                       'Sub Total',
//                                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                     ),
//                                                     const Spacer(),
//                                                     Container(
//                                                       padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                       decoration: const BoxDecoration(color: kGreenTextColor),
//                                                       child: Center(
//                                                         child: Text(
//                                                           getTotalAmount(),
//                                                           style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                                 const SizedBox(height: 10.0),
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                   children: [
//                                                     Text(
//                                                       'VAT/GST',
//                                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                     ),
//                                                     const Spacer(),
//                                                     Container(
//                                                       padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                       decoration: const BoxDecoration(color: kLitGreyColor),
//                                                       child: Text(
//                                                         '0%',
//                                                         style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const SizedBox(height: 10.0),
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                   children: [
//                                                     Text(
//                                                       'Service/Shipping',
//                                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                     ),
//                                                     const Spacer(),
//                                                     Container(
//                                                       padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                       decoration: const BoxDecoration(color: kLitGreyColor),
//                                                       child: Text(
//                                                         '${currency}0.00',
//                                                         style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const SizedBox(height: 10.0),
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                   children: [
//                                                     Text(
//                                                       'Discount',
//                                                       style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
//                                                     ),
//                                                     const Spacer(),
//                                                     Container(
//                                                       padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 4.0, bottom: 4.0),
//                                                       decoration: const BoxDecoration(color: kLitGreyColor),
//                                                       child: Text(
//                                                         '${currency}0.00',
//                                                         style: kTextStyle.copyWith(color: kWhiteTextColor),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 20.0),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           Expanded(
//                                             flex: 1,
//                                             child: Container(
//                                               padding: const EdgeInsets.all(10.0),
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.rectangle,
//                                                 borderRadius: BorderRadius.circular(2.0),
//                                                 color: kRedTextColor,
//                                               ),
//                                               child: Text(
//                                                 'Cancel',
//                                                 textAlign: TextAlign.center,
//                                                 style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 10.0),
//                                           Expanded(
//                                             flex: 1,
//                                             child: Container(
//                                               padding: const EdgeInsets.all(10.0),
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.rectangle,
//                                                 borderRadius: BorderRadius.circular(2.0),
//                                                 color: Colors.black,
//                                               ),
//                                               child: Text(
//                                                 'Quotation',
//                                                 textAlign: TextAlign.center,
//                                                 style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 10.0),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(10.0),
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.rectangle,
//                                                   borderRadius: BorderRadius.circular(2.0),
//                                                   color: Colors.yellow,
//                                                 ),
//                                                 child: Text(
//                                                   'Hold',
//                                                   textAlign: TextAlign.center,
//                                                   style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                 ),
//                                               ).onTap(() => showHoldPopUp())),
//                                           const SizedBox(width: 10.0),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Container(
//                                                 padding: const EdgeInsets.all(10.0),
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.rectangle,
//                                                   borderRadius: BorderRadius.circular(2.0),
//                                                   color: kGreenTextColor,
//                                                 ),
//                                                 child: Text(
//                                                   'Payment',
//                                                   textAlign: TextAlign.center,
//                                                   style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 18.0, fontWeight: FontWeight.bold),
//                                                 ),
//                                               ).onTap(
//                                                 () {
//                                                   if (cartList.isEmpty) {
//                                                     EasyLoading.showError('Please Add Some Product first');
//                                                   } else {
//                                                     PurchaseTransitionModel transitionModel = PurchaseTransitionModel(
//                                                         customerName: selectedUserName.customerName,
//                                                         customerType: selectedUserName.type,
//                                                         customerPhone: selectedUserName.phoneNumber,
//                                                         invoiceNumber: data.purchaseInvoiceCounter.toString(),
//                                                         purchaseDate: DateTime.now().toString(),
//                                                         productList: cartList);
//                                                     showDialog(
//                                                       barrierDismissible: false,
//                                                       context: context,
//                                                       builder: (BuildContext context) {
//                                                         return StatefulBuilder(
//                                                           builder: (context, setState) {
//                                                             return Dialog(
//                                                               shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.circular(5.0),
//                                                               ),
//                                                               child: TabPurchaseShowPaymentPopUp(
//                                                                 transitionModel: transitionModel,
//                                                               ),
//                                                             );
//                                                           },
//                                                         );
//                                                       },
//                                                     );
//                                                   }
//                                                 },
//                                               ))
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
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
//       }),
//     );
//   }
// }
