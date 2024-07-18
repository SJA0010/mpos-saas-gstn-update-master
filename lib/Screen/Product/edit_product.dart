// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Product/product.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/product_provider.dart';
import '../../constant.dart';
import '../../model/product_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key, required this.productModel, required this.allProductsNameList}) : super(key: key);

  final ProductModel productModel;
  final List<String> allProductsNameList;

  @override
  State<EditProduct> createState() => _AddProductState();
}

class _AddProductState extends State<EditProduct> {
  GlobalKey<FormState> addProductFormKey = GlobalKey<FormState>();
  bool categoryValidateAndSave() {
    final form = addProductFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool isSerialNumberTaken = false;
  String selectedTime = 'Year';
  List<String> warrantyTime = ['Day', 'Month', 'Year'];
  String productPicture = '';

  Uint8List? image;

  Future<void> uploadFile() async {
    // File file = File(filePath);
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        // File? file = await ImagePickerWeb.getImageAsFile();
        if (bytesFromPicker!.isNotEmpty) {
          EasyLoading.show(
            status: 'Uploading... ',
            dismissOnTap: false,
          );
        }
        var snapshot = await FirebaseStorage.instance.ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker);
        var url = await snapshot.ref.getDownloadURL();
        EasyLoading.showSuccess('Upload Successful!');
        setState(() {
          image = bytesFromPicker;
          productPicture = url.toString();
        });
      } on firebase_core.FirebaseException catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    }
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController productSalePriceController = TextEditingController();
  TextEditingController productPurchasePriceController = TextEditingController();
  TextEditingController productDiscountPriceController = TextEditingController();
  TextEditingController productWholesalePriceController = TextEditingController();
  TextEditingController productDealerPriceController = TextEditingController();
  TextEditingController productManufacturerController = TextEditingController();

  TextEditingController sizeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController warrantyController = TextEditingController();
  TextEditingController productSerialNumberController = TextEditingController(text: '');

  late String productKey;

  void getProductKey(String code) async {
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == code) {
          productKey = element.key.toString();
        }
      }
    });
  }

  late ProductModel productModel;

  @override
  void initState() {
    productModel = widget.productModel;
    productNameController.text = widget.productModel.productName;
    productSalePriceController.text = widget.productModel.productSalePrice;
    productPurchasePriceController.text = widget.productModel.productPurchasePrice;
    productDiscountPriceController.text = widget.productModel.productDiscount;
    productWholesalePriceController.text = widget.productModel.productWholeSalePrice;
    productDealerPriceController.text = widget.productModel.productDealerPrice;
    productManufacturerController.text = widget.productModel.productManufacturer;

    sizeController.text = widget.productModel.size;
    colorController.text = widget.productModel.color;
    weightController.text = widget.productModel.weight;
    capacityController.text = widget.productModel.capacity;
    typeController.text = widget.productModel.type;
    warrantyController.text = widget.productModel.warranty.getNumericOnly();
    getProductKey(widget.productModel.productCode);

    if (!widget.productModel.warranty.isEmptyOrNull) {
      if (widget.productModel.warranty.contains('Month')) {
        selectedTime = 'Month';
      } else if (widget.productModel.warranty.contains('Year')) {
        selectedTime = 'Year';
      } else {
        selectedTime = 'Day';
      }
    }

    productPicture = widget.productModel.productPicture;

    widget.productModel.serialNumber.isNotEmpty ? isSerialNumberTaken = true : isSerialNumberTaken = false;
    super.initState();
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
          child: Consumer(
            builder: (context, ref, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 240,
                    child: SideBarWidget(
                      index: 3,
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
                            child: const TopBar(),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration: const BoxDecoration(color: kDarkWhite),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    lang.S.of(context).addProduct,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///___________edit_______________________________________________
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: kWhiteTextColor,
                                          ),
                                          child: Form(
                                            key: addProductFormKey,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10.0),

                                                ///________Name_And_Category_____________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            return 'Product name is required.';
                                                          } else if (widget.allProductsNameList.contains(value.removeAllWhiteSpace().toLowerCase()) &&
                                                              widget.productModel.productName != value) {
                                                            return 'Product Name already exist.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productNameController.text = value!;
                                                        },
                                                        showCursor: true,
                                                        controller: productNameController,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).productNam,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductName,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        readOnly: true,
                                                        initialValue: widget.productModel.productCategory,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).productCategory,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///________Size_&_Color____________________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: AppTextField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        showCursor: true,
                                                        controller: sizeController,
                                                        cursorColor: kTitleColor,
                                                        textFieldType: TextFieldType.NAME,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).productSize,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductSize,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.size.isNotEmpty),
                                                    const SizedBox(width: 20).visible(widget.productModel.color.isNotEmpty && widget.productModel.size.isNotEmpty),
                                                    Expanded(
                                                      child: AppTextField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        showCursor: true,
                                                        controller: colorController,
                                                        cursorColor: kTitleColor,
                                                        textFieldType: TextFieldType.NAME,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).productColor,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductColor,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.color.isNotEmpty),
                                                  ],
                                                ),

                                                ///_____________Weight_&_Capacity___________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0),
                                                        child: AppTextField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          showCursor: true,
                                                          controller: weightController,
                                                          cursorColor: kTitleColor,
                                                          textFieldType: TextFieldType.NAME,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productWeight,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductWeight,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.weight.isNotEmpty),
                                                    const SizedBox(width: 20).visible(widget.productModel.weight.isNotEmpty && widget.productModel.capacity.isNotEmpty),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0),
                                                        child: AppTextField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          showCursor: true,
                                                          controller: capacityController,
                                                          cursorColor: kTitleColor,
                                                          textFieldType: TextFieldType.NAME,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productCapacity,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductCapacity,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.capacity.isNotEmpty),
                                                  ],
                                                ),

                                                ///_____________Type_&_Warranty___________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                                                        child: AppTextField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          showCursor: true,
                                                          controller: typeController,
                                                          cursorColor: kTitleColor,
                                                          textFieldType: TextFieldType.NAME,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productType,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductType,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(widget.productModel.type.isNotEmpty),
                                                    const SizedBox(width: 20).visible(widget.productModel.type.isNotEmpty && widget.productModel.warranty.isNotEmpty),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                                                              child: TextFormField(
                                                                validator: (value) {
                                                                  if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                                                    return 'Enter Quantity in number.';
                                                                  } else {
                                                                    return null;
                                                                  }
                                                                },
                                                                onSaved: (value) {
                                                                  warrantyController.text = value!;
                                                                },
                                                                showCursor: true,
                                                                controller: warrantyController,
                                                                cursorColor: kTitleColor,
                                                                decoration: kInputDecoration.copyWith(
                                                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                  labelText: lang.S.of(context).productWarranty,
                                                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                  hintText: lang.S.of(context).enterWarranty,
                                                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          SizedBox(
                                                            width: 200,
                                                            child: FormField(
                                                              builder: (FormFieldState<dynamic> field) {
                                                                return InputDecorator(
                                                                  decoration: InputDecoration(
                                                                    enabledBorder: const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                    ),
                                                                    contentPadding: const EdgeInsets.all(8.0),
                                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                    labelText: lang.S.of(context).warranty,
                                                                  ),
                                                                  child: DropdownButtonHideUnderline(
                                                                      child: DropdownButton<String>(
                                                                    onChanged: (String? value) {
                                                                      setState(() {
                                                                        selectedTime = value!;
                                                                      });
                                                                    },
                                                                    hint: Text(lang.S.of(context).selectWarrantyTime),
                                                                    value: selectedTime,
                                                                    items: warrantyTime.map((String items) {
                                                                      return DropdownMenuItem(
                                                                        value: items,
                                                                        child: Text(items),
                                                                      );
                                                                    }).toList(),
                                                                  )),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ).visible(widget.productModel.warranty.isNotEmpty),
                                                  ],
                                                ),

                                                ///_______brand_&_ProductCode________________________________________
                                                const SizedBox(height: 10),

                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: widget.productModel.brandName,
                                                        readOnly: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).brandName,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterbrandName,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: widget.productModel.productCode,
                                                        readOnly: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).productCodes,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductCode,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          suffixIcon: const Icon(
                                                            Icons.scanner,
                                                            color: kTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///______quantity_&_Unit______________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: widget.productModel.productStock,
                                                        readOnly: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).quantitys,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductQuantity,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: widget.productModel.productUnit,
                                                        readOnly: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).unit,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductQuantity,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///__________Sale_Price_&_Purchase_Price_______________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            return 'Product Purchase Price is required.';
                                                          } else if (double.tryParse(value!) == null) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productPurchasePriceController.text = value!;
                                                        },
                                                        controller: productPurchasePriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).purchasePrices,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterPurchasePrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            return 'Product Sale Price is required.';
                                                          } else if (double.tryParse(value!) == null) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productSalePriceController.text = value!;
                                                        },
                                                        controller: productSalePriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).salePrices,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterSalePrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///__________Dealer &_Wholesele_Price______________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productDealerPriceController.text = value!;
                                                        },
                                                        controller: productDealerPriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).dealerPice,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterDealerPrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (double.tryParse(value!) == null && !value.isEmptyOrNull) {
                                                            return 'Enter price in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productWholesalePriceController.text = value!;
                                                        },
                                                        controller: productWholesalePriceController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).wholeSalePrice,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterPrice,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///________Manufacturer_______________________________________________
                                                SizedBox(
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      productManufacturerController.text = value!;
                                                    },
                                                    controller: productManufacturerController,
                                                    showCursor: true,
                                                    cursorColor: kTitleColor,
                                                    decoration: kInputDecoration.copyWith(
                                                      labelText: lang.S.of(context).menufetather,
                                                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                      hintText: lang.S.of(context).enterMenuFeatherName,
                                                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///_________product_serial____________________________________________
                                                Row(
                                                  children: [
                                                    Text(lang.S.of(context).enterProductSerialNumber),
                                                    const SizedBox(
                                                      width: 30,
                                                    ),
                                                    CupertinoSwitch(
                                                        value: isSerialNumberTaken,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isSerialNumberTaken = value;
                                                          });
                                                        })
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: AppTextField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        controller: productSerialNumberController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        onFieldSubmitted: (value) {
                                                          if (isSerialNumberUnique(allList: widget.productModel.serialNumber, newSerial: value)) {
                                                            setState(() {
                                                              widget.productModel.serialNumber.add(value);
                                                            });
                                                            productSerialNumberController.clear();
                                                          } else {
                                                            EasyLoading.showError('Serial number already added!');
                                                          }
                                                        },
                                                        textFieldType: TextFieldType.NAME,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).serialNumber,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterserialNumber,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),

                                                    ///__________serial_add_button_______________________________________________
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (isSerialNumberUnique(allList: widget.productModel.serialNumber, newSerial: productSerialNumberController.text)) {
                                                          setState(() {
                                                            widget.productModel.serialNumber.add(productSerialNumberController.text);
                                                          });
                                                          productSerialNumberController.clear();
                                                        } else {
                                                          EasyLoading.showError('Serial number already added!');
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 70,
                                                        height: 53,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kMainColor),
                                                        child: Center(
                                                          child: Text(
                                                            lang.S.of(context).add,
                                                            style: const TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      width: 400,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1, color: Colors.grey),
                                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                      ),
                                                      child: GridView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: productModel.serialNumber.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            if (productModel.serialNumber.isNotEmpty) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 170,
                                                                      child: Text(
                                                                        productModel.serialNumber[index],
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          productModel.serialNumber.removeAt(index);
                                                                        });
                                                                      },
                                                                      child: const Icon(
                                                                        Icons.cancel,
                                                                        color: Colors.red,
                                                                        size: 15,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            } else {
                                                              return Text(lang.S.of(context).noSerailNumberFound);
                                                            }
                                                          },
                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            childAspectRatio: 6,
                                                            crossAxisSpacing: .5,
                                                            mainAxisSpacing: .5,
                                                            // mainAxisExtent: 1,
                                                          )),
                                                    ),
                                                  ],
                                                ).visible(isSerialNumberTaken),

                                                ///__________save_Button___________________________________________
                                                const SizedBox(height: 30.0),
                                                Center(
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width < 1080 ? 1080 * .30 : MediaQuery.of(context).size.width * .30,
                                                    child: ButtonGlobalWithoutIcon(
                                                      buttontext: lang.S.of(context).saveandPublished,
                                                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                                                      onPressed: () async {
                                                        if (categoryValidateAndSave()) {
                                                          try {
                                                            EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                            final DatabaseReference productInformationRef = FirebaseDatabase.instance.ref("$constUserId/Products/$productKey");
                                                            productModel.productName = productNameController.text;
                                                            productModel.size = sizeController.text;
                                                            productModel.color = colorController.text;
                                                            productModel.weight = weightController.text;
                                                            productModel.type = typeController.text;
                                                            // productModel.warranty = warrantyController.text;
                                                            productModel.capacity = capacityController.text;
                                                            //_____price_____________________________________
                                                            productModel.productSalePrice = productSalePriceController.text;
                                                            productModel.productPurchasePrice = productPurchasePriceController.text;
                                                            productModel.productDealerPrice = productDealerPriceController.text;
                                                            productModel.productWholeSalePrice = productWholesalePriceController.text;

                                                            productModel.productManufacturer = productManufacturerController.text;
                                                            productModel.warranty = warrantyController.text == '' ? '' : '${warrantyController.text} $selectedTime';
                                                            productModel.productPicture = productPicture;

                                                            await productInformationRef.set(productModel.toJson());
                                                            EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                                                            ref.refresh(productProvider);
                                                            Future.delayed(const Duration(milliseconds: 100), () {
                                                              const Product().launch(context, isNewTask: true);
                                                            });
                                                          } catch (e) {
                                                            EasyLoading.dismiss();
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                          }
                                                        }
                                                      },
                                                      buttonTextColor: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///_________image___________________________________________________
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 10.0),
                                              DottedBorderWidget(
                                                padding: const EdgeInsets.all(6),
                                                color: kLitGreyColor,
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                  child: Container(
                                                    width: context.width(),
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            const Icon(Icons.cloud_upload, size: 50.0, color: kLitGreyColor).onTap(() => uploadFile()),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 5.0),
                                                        RichText(
                                                            text: TextSpan(
                                                                text: lang.S.of(context).uploadanImage,
                                                                style: kTextStyle.copyWith(color: kGreenTextColor, fontWeight: FontWeight.bold),
                                                                children: [
                                                              TextSpan(
                                                                  text: lang.S.of(context).ordragdropPNGPG,
                                                                  style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold))
                                                            ]))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              image != null
                                                  ? Image.memory(
                                                      image!,
                                                      width: 150,
                                                      height: 150,
                                                    )
                                                  : Image.network(
                                                      productPicture,
                                                      width: 150,
                                                      height: 150,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool isSerialNumberUnique({required List<String> allList, required String newSerial}) {
    for (var element in allList) {
      if (element.toLowerCase().removeAllWhiteSpace() == newSerial.toLowerCase().removeAllWhiteSpace()) {
        return false;
      }
    }
    return true;
  }
}
