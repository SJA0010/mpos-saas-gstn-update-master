// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
import 'package:salespro_admin/model/category_model.dart';
import 'package:salespro_admin/model/unit_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/product_provider.dart';
import '../../constant.dart';
import '../../model/brands_model.dart';
import '../../model/product_model.dart';
import '../../subscription.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, required this.allProductsNameList, required this.allProductsCodeList, required this.sideBarNumber}) : super(key: key);
  final List<String> allProductsNameList;
  final List<String> allProductsCodeList;
  final int sideBarNumber;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool isSize = false;
  bool isColor = false;
  bool isWeight = false;
  bool isCapacity = false;
  bool isType = false;
  bool isWarranty = false;
  bool isSizedBoxShow = false;
  bool isColoredBoxShow = false;
  bool isWeightsBoxShow = false;
  bool isWarrantyBoxShow = false;
  bool isCapacityBoxShow = false;
  bool isTypeBoxShow = false;
  int brandTime = 0;
  int unitTime = 0;
  int categoryTime = 0;

  List<String> productSerialNumberList = [];

  final FocusNode _focusNode = FocusNode();

  ///_____post_General_category___________________________________________________________________
  Future<void> postGeneralCategory({required WidgetRef ref}) async {
    final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Categories');
    CategoryModel categoryModel = CategoryModel(categoryName: 'General', size: false, color: false, capacity: false, type: false, weight: false, warranty: false);
    await categoryInformationRef.push().set(categoryModel.toJson());
    ref.refresh(categoryProvider);
  }

  void addCategoryShowPopUp({required WidgetRef ref, required List<String> categoryNameList, required BuildContext addProductContext}) {
    GlobalKey<FormState> categoryNameKey = GlobalKey<FormState>();
    bool categoryValidateAndSave() {
      final form = categoryNameKey.currentState;
      if (form!.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    showDialog(
        barrierDismissible: false,
        context: addProductContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState1) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(shape: BoxShape.rectangle),
                            child: const Icon(
                              FeatherIcons.plus,
                              color: kTitleColor,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            lang.S.of(context).addItemCategory,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(
                            FeatherIcons.x,
                            color: kTitleColor,
                            size: 21.0,
                          ).onTap(() {
                            itemCategoryController.clear();
                            isSize = false;
                            isColor = false;
                            isWeight = false;
                            isCapacity = false;
                            isType = false;
                            isWarranty = false;
                            finish(context);
                          })
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).categoryName,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 20),
                          Form(
                            key: categoryNameKey,
                            child: SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: itemCategoryController,
                                validator: (value) {
                                  if (value.isEmptyOrNull) {
                                    return 'Category name is required.';
                                  } else if (categoryNameList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                    return 'Category name is already exist.';
                                  } else {
                                    return null;
                                  }
                                },
                                showCursor: true,
                                cursorColor: kTitleColor,
                                decoration: kInputDecoration.copyWith(
                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                  labelText: lang.S.of(context).categoryName,
                                  hintText: lang.S.of(context).enterCategoryName,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        lang.S.of(context).selectVariations,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isSize,
                                onChanged: (val) {
                                  setState1(
                                    () {
                                      isSize = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).size),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isColor,
                                onChanged: (val) {
                                  setState1(() {
                                    isColor = val!;
                                  });
                                },
                              ),
                              title: Text(lang.S.of(context).color),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isWeight,
                                onChanged: (val) {
                                  setState1(() {
                                    isWeight = val!;
                                  });
                                },
                              ),
                              title: Text(lang.S.of(context).weight),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isCapacity,
                                onChanged: (val) {
                                  setState1(
                                    () {
                                      isCapacity = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).capacity),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isType,
                                onChanged: (val) {
                                  setState1(
                                    () {
                                      isType = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).type),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: kMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                value: isWarranty,
                                onChanged: (val) {
                                  setState1(
                                    () {
                                      isWarranty = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).warranty),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
                            child: Text(
                              lang.S.of(context).cancel,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() {
                            itemCategoryController.clear();
                            isSize = false;
                            isColor = false;
                            isWeight = false;
                            isCapacity = false;
                            isType = false;
                            isWarranty = false;
                            finish(context);
                          }),
                          const SizedBox(width: 5.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
                            child: Text(
                              lang.S.of(context).submit,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() async {
                            if (categoryValidateAndSave()) {
                              EasyLoading.show(status: 'Adding Category');
                              try {
                                final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Categories');
                                CategoryModel categoryModel = CategoryModel(
                                  categoryName: itemCategoryController.text,
                                  size: isSize,
                                  color: isColor,
                                  capacity: isCapacity,
                                  type: isType,
                                  weight: isWeight,
                                  warranty: isWarranty,
                                );

                                await categoryInformationRef.push().set(categoryModel.toJson());
                                // setState1(() {
                                //   selectedCategories = categoryModel.categoryName;
                                //   isSizedBoxShow = isSize;
                                //   isColoredBoxShow = isColor;
                                //   isWeightsBoxShow = isWeight;
                                //   isCapacityBoxShow = isCapacity;
                                //   isTypeBoxShow = isType;
                                //   isWarrantyBoxShow = isWarranty;
                                //   categoryTime = 0;
                                //   categoryName.clear();
                                // });

                                ref.refresh(categoryProvider.future);

                                itemCategoryController.clear();
                                isSize = false;
                                isColor = false;
                                isWeight = false;
                                isCapacity = false;
                                isType = false;
                                isWarranty = false;

                                EasyLoading.showSuccess("Successfully Added");
                                finish(context);
                              } catch (e) {
                                EasyLoading.showError('Error');
                              }
                            }
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void showBrandPopUp({required WidgetRef ref, required List<String> brandNameList, required BuildContext addProductsContext}) {
    GlobalKey<FormState> brandNameKey = GlobalKey<FormState>();
    bool brandValidateAndSave() {
      final form = brandNameKey.currentState;
      if (form!.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    showDialog(
        barrierDismissible: false,
        context: addProductsContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(shape: BoxShape.rectangle),
                            child: const Icon(
                              FeatherIcons.plus,
                              color: kTitleColor,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            lang.S.of(context).addBrand,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(
                            FeatherIcons.x,
                            color: kTitleColor,
                            size: 21.0,
                          ).onTap(() {
                            brandNameController.clear();
                            finish(context);
                          })
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).brandName,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 50),
                          Form(
                            key: brandNameKey,
                            child: SizedBox(
                              width: 400,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmptyOrNull) {
                                    return 'Brand name is required.';
                                  } else if (brandNameList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                    return 'Brand name is already exist.';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: brandNameController,
                                showCursor: true,
                                cursorColor: kTitleColor,
                                decoration: kInputDecoration.copyWith(
                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                  labelText: lang.S.of(context).brandName,
                                  hintText: lang.S.of(context).enterbrandName,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Divider(
                        thickness: 1.0,
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
                            child: Text(
                              lang.S.of(context).cancel,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() {
                            brandNameController.clear();
                            finish(context);
                          }),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
                            child: Text(
                              lang.S.of(context).submit,
                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                            ),
                          ).onTap(() async {
                            if (brandValidateAndSave()) {
                              try {
                                EasyLoading.show(status: 'Adding Brand');
                                final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Brands');
                                BrandsModel brandModel = BrandsModel(brandNameController.text);
                                await categoryInformationRef.push().set(brandModel.toJson());
                                ref.refresh(brandProvider);
                                // setState(() {
                                //   selectedBrand = brandModel.brandName;
                                //   brandTime = 0;
                                //   brandName.clear();
                                // });
                                brandNameController.clear();
                                EasyLoading.showSuccess("Successfully Added");
                                finish(context);
                              } catch (e) {
                                EasyLoading.showError('Error');
                              }
                            }
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void showUnitPopUp({required WidgetRef ref, required List<String> unitNameList, required BuildContext addProductsContext}) {
    GlobalKey<FormState> unitNameKey = GlobalKey<FormState>();
    bool unitValidateAndSave() {
      final form = unitNameKey.currentState;
      if (form!.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    showDialog(
        barrierDismissible: true,
        context: addProductsContext,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(shape: BoxShape.rectangle),
                          child: const Icon(
                            FeatherIcons.plus,
                            color: kTitleColor,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          lang.S.of(context).addUnit,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(
                          FeatherIcons.x,
                          color: kTitleColor,
                          size: 21.0,
                        ).onTap(() {
                          unitNameController.clear();
                          descriptionController.clear();
                          finish(context);
                        })
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Divider(
                      thickness: 1.0,
                      color: kGreyTextColor.withOpacity(0.2),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          lang.S.of(context).unitName,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        ),
                        const SizedBox(width: 50),
                        Form(
                          key: unitNameKey,
                          child: SizedBox(
                            width: 400,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmptyOrNull) {
                                  return 'Unit name is required.';
                                } else if (unitNameList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                  return 'Unit name is already exist.';
                                } else {
                                  return null;
                                }
                              },
                              controller: unitNameController,
                              showCursor: true,
                              cursorColor: kTitleColor,
                              decoration: kInputDecoration.copyWith(
                                errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                labelText: lang.S.of(context).unitName,
                                hintText: lang.S.of(context).enterUnitName,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Divider(
                      thickness: 1.0,
                      color: kGreyTextColor.withOpacity(0.2),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kRedTextColor),
                          child: Text(
                            lang.S.of(context).cancel,
                            style: kTextStyle.copyWith(color: kWhiteTextColor),
                          ),
                        ).onTap(() {
                          unitNameController.clear();
                          finish(context);
                        }),
                        const SizedBox(width: 5.0),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kGreenTextColor),
                          child: Text(
                            lang.S.of(context).submit,
                            style: kTextStyle.copyWith(color: kWhiteTextColor),
                          ),
                        ).onTap(() async {
                          if (unitValidateAndSave()) {
                            try {
                              EasyLoading.show(status: 'Adding Units');
                              final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Units');
                              UnitModel unitModel = UnitModel(unitNameController.text);
                              await categoryInformationRef.push().set(unitModel.toJson());
                              ref.refresh(unitProvider);
                              // setState(() {
                              //   unitTime = 0;
                              //   extraAddedUnits.clear();
                              //   selectedUnit = unitModel.unitName;
                              // });
                              unitNameController.clear();
                              EasyLoading.showSuccess("Successfully Added");
                              finish(context);
                            } catch (e) {
                              EasyLoading.showError('Error');
                            }
                          }
                        })
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  String productPicture =
      'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Product%20No%20Image%2Fno-image-found-360x250.png?alt=media&token=9299964e-22b3-4d88-924e-5eeb285ae672';

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

  List<String> brandName = [];
  List<String> categoryName = [];

  List<String> warrantyTime = ['Day', 'Month', 'Year'];
  List<String> extraAddedUnits = [];
  List<String> allUnitList = [
    "PIECES (Pcs)",
    "BAGS (Bag)",
    "BOX ( Box )",
    "PACKS (Pac)",
    "PAIRS (Prs)",
    "LITRE (Ltr)",
    "CANS (Can)",
    "ROLLS (Rol)",
    "QUINTAL (Qtl)",
    "CARTONS (Ctn)",
    "DOZENS (Dzn)",
    "MILILITRE (Mr)",
    "BOTTLES (Blt)",
    "BUNDLES (Bdl)",
    "GRAMMES (Gm)",
    "KILOGRAMS (Kg)",
    "NUMBERS (Nos)",
    "TABLETS (Tbs)",
    "SQUARE FEET (Sqf)",
    "SQUARE METERS (Sqm)"
  ];

  String? selectedBrand;
  String? selectedCategories = 'General';
  String selectedTime = 'Month';
  String? selectedUnit = 'PIECES (Pcs)';
  bool isSerialNumberTaken = false;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productSalePriceController = TextEditingController();
  TextEditingController productPurchasePriceController = TextEditingController();
  TextEditingController productDiscountPriceController = TextEditingController(text: '');
  TextEditingController productWholesalePriceController = TextEditingController(text: '');
  TextEditingController productDealerPriceController = TextEditingController(text: '');
  TextEditingController productManufacturerController = TextEditingController(text: '');
  TextEditingController nsnsacController = TextEditingController(text: '');
  TextEditingController productSerialNumberController = TextEditingController(text: '');

  TextEditingController itemCategoryController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController unitNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController sizeController = TextEditingController(text: '');
  TextEditingController colorController = TextEditingController(text: '');
  TextEditingController weightController = TextEditingController(text: '');
  TextEditingController capacityController = TextEditingController(text: '');
  TextEditingController typeController = TextEditingController(text: '');
  TextEditingController warrantyController = TextEditingController(text: '');

  GlobalKey<FormState> addProductFormKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = addProductFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  ScrollController mainScroll = ScrollController();
  int counter = 0;

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
              final unitList = ref.watch(unitProvider);
              final brandList = ref.watch(brandProvider);
              final categoryList = ref.watch(categoryProvider);
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 240,
                    child: SideBarWidget(
                      index: widget.sideBarNumber,
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
                                                          } else if (widget.allProductsNameList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                                            return 'Product Name already exist.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          if (productCodeController.text.isEmptyOrNull) productCodeController.text = value!;
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
                                                    categoryList.when(
                                                      data: (category) {
                                                        List<String> editNameList = [];
                                                        if (category.isEmpty) {
                                                          counter == 0 ? postGeneralCategory(ref: ref) : null;
                                                          counter++;
                                                        }
                                                        categoryTime == 0
                                                            // ignore: avoid_function_literals_in_foreach_calls
                                                            ? category.forEach((element) {
                                                                categoryName.add(element.categoryName);
                                                                editNameList.add(element.categoryName.removeAllWhiteSpace().toLowerCase());
                                                                categoryTime++;
                                                              })
                                                            : null;
                                                        for (var element in category) {
                                                          editNameList.add(element.categoryName.toLowerCase().removeAllWhiteSpace());
                                                        }
                                                        return Expanded(
                                                          child: FormField(
                                                            builder: (FormFieldState<dynamic> field) {
                                                              return InputDecorator(
                                                                decoration: InputDecoration(
                                                                    enabledBorder: const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                    ),
                                                                    suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor)
                                                                        .onTap(() => addCategoryShowPopUp(ref: ref, categoryNameList: editNameList, addProductContext: context)),
                                                                    contentPadding: const EdgeInsets.all(8.0),
                                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                    labelText: lang.S.of(context).category),
                                                                child: DropdownButtonHideUnderline(
                                                                    child: DropdownButton<String>(
                                                                  onChanged: (String? value) {
                                                                    setState(() {
                                                                      selectedCategories = value!;
                                                                      for (var element in category) {
                                                                        if (element.categoryName == selectedCategories) {
                                                                          isSizedBoxShow = element.size;
                                                                          isColoredBoxShow = element.color;
                                                                          isWeightsBoxShow = element.weight;
                                                                          isCapacityBoxShow = element.capacity;
                                                                          isTypeBoxShow = element.type;
                                                                          isWarrantyBoxShow = element.warranty;
                                                                        }
                                                                      }
                                                                      toast(selectedCategories);
                                                                    });
                                                                  },
                                                                  value: selectedCategories,
                                                                  items: categoryName.map((String items) {
                                                                    return DropdownMenuItem(
                                                                      value: items,
                                                                      child: Text(items),
                                                                    );
                                                                  }).toList(),
                                                                )),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      error: (e, stack) {
                                                        return Center(
                                                          child: Text(
                                                            e.toString(),
                                                          ),
                                                        );
                                                      },
                                                      loading: () {
                                                        return const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///________Size_&_Color____________________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          sizeController.text = value!;
                                                        },
                                                        showCursor: true,
                                                        controller: sizeController,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).productSize,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductSize,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ).visible(isSizedBoxShow),
                                                    const SizedBox(width: 20).visible(isColoredBoxShow && isSizedBoxShow),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          colorController.text = value!;
                                                        },
                                                        showCursor: true,
                                                        controller: colorController,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).productColor,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterProductColor,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ).visible(isColoredBoxShow),
                                                  ],
                                                ),

                                                ///_____________Weight_&_Capacity___________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            weightController.text = value!;
                                                          },
                                                          showCursor: true,
                                                          controller: weightController,
                                                          cursorColor: kTitleColor,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productWeight,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductWeight,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(isWeightsBoxShow),
                                                    const SizedBox(width: 20).visible(isWeightsBoxShow && isCapacityBoxShow),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            capacityController.text = value!;
                                                          },
                                                          showCursor: true,
                                                          controller: capacityController,
                                                          cursorColor: kTitleColor,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productCapacity,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductCapacity,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(isCapacityBoxShow),
                                                  ],
                                                ),

                                                ///_____________Type_&_Warranty___________________________________________
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            typeController.text = value!;
                                                          },
                                                          showCursor: true,
                                                          controller: typeController,
                                                          cursorColor: kTitleColor,
                                                          decoration: kInputDecoration.copyWith(
                                                            labelText: lang.S.of(context).productType,
                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                            hintText: lang.S.of(context).enterProductType,
                                                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ).visible(isTypeBoxShow),
                                                    const SizedBox(width: 20).visible(isTypeBoxShow && isWarrantyBoxShow),
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
                                                    ).visible(isWarrantyBoxShow),
                                                  ],
                                                ),

                                                ///_______brand_&_ProductCode________________________________________
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    brandList.when(data: (brand) {
                                                      List<String> editBrandList = [];
                                                      brandTime == 0
                                                          // ignore: avoid_function_literals_in_foreach_calls
                                                          ? brand.forEach((element) {
                                                              brandName.add(element.brandName);
                                                              // editBrandList.add(element.brandName.removeAllWhiteSpace().toLowerCase());
                                                              brandTime++;
                                                            })
                                                          : null;
                                                      for (var element in brand) {
                                                        editBrandList.add(element.brandName.toLowerCase().removeAllWhiteSpace());
                                                      }
                                                      return Expanded(
                                                        child: FormField(
                                                          builder: (FormFieldState<dynamic> field) {
                                                            return InputDecorator(
                                                              decoration: InputDecoration(
                                                                  enabledBorder: const OutlineInputBorder(
                                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                  ),
                                                                  suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor)
                                                                      .onTap(() => showBrandPopUp(ref: ref, brandNameList: editBrandList, addProductsContext: context)),
                                                                  contentPadding: const EdgeInsets.all(8.0),
                                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                  labelText: lang.S.of(context).brand),
                                                              child: DropdownButtonHideUnderline(
                                                                  child: DropdownButton<String>(
                                                                onChanged: (String? value) {
                                                                  setState(() {
                                                                    selectedBrand = value!;
                                                                    toast(selectedBrand);
                                                                  });
                                                                },
                                                                hint: Text(lang.S.of(context).selectProductBrand),
                                                                value: selectedBrand,
                                                                items: brandName.map((String items) {
                                                                  return DropdownMenuItem(
                                                                    value: items,
                                                                    child: Text(items),
                                                                  );
                                                                }).toList(),
                                                              )),
                                                            );
                                                          },
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
                                                    }),
                                                    const SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (widget.allProductsCodeList.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                                            return 'Product Name already exist.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productCodeController.text = value!;
                                                        },
                                                        controller: productCodeController,
                                                        showCursor: true,
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
                                                        validator: (value) {
                                                          if (value.removeAllWhiteSpace().isEmptyOrNull) {
                                                            return 'Product Quantity is required.';
                                                          } else if (double.tryParse(value!) == null) {
                                                            return 'Enter Quantity in number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          productQuantityController.text = value!;
                                                        },
                                                        controller: productQuantityController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).quantitys,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterQuantity,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),
                                                    unitList.when(data: (unit) {
                                                      List<String> editUnitNameList = [];
                                                      unitTime == 0
                                                          // ignore: avoid_function_literals_in_foreach_calls
                                                          ? unit.forEach((element) {
                                                              extraAddedUnits.add(element.unitName);

                                                              // editUnitNameList.add(element.unitName.removeAllWhiteSpace().removeAllWhiteSpace());
                                                              unitTime++;
                                                              if (element.unitName == unit.last.unitName) {
                                                                allUnitList = allUnitList + extraAddedUnits;
                                                              }
                                                            })
                                                          : null;

                                                      for (var element in allUnitList) {
                                                        editUnitNameList.add(element.removeAllWhiteSpace().removeAllWhiteSpace());
                                                      }

                                                      return Expanded(
                                                        child: FormField(
                                                          builder: (FormFieldState<dynamic> field) {
                                                            return InputDecorator(
                                                              decoration: InputDecoration(
                                                                suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor)
                                                                    .onTap(() => showUnitPopUp(ref: ref, unitNameList: editUnitNameList, addProductsContext: context)),
                                                                enabledBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                ),
                                                                contentPadding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                labelText: lang.S.of(context).productUnit,
                                                              ),
                                                              child: DropdownButtonHideUnderline(
                                                                  child: DropdownButton<String>(
                                                                onChanged: (String? value) {
                                                                  setState(() {
                                                                    selectedUnit = value!;
                                                                    toast(selectedUnit);
                                                                  });
                                                                },
                                                                value: selectedUnit,
                                                                items: allUnitList.map((String items) {
                                                                  return DropdownMenuItem(
                                                                    value: items,
                                                                    child: Text(items),
                                                                  );
                                                                }).toList(),
                                                              )),
                                                            );
                                                          },
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
                                                    })
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
                                                          labelText: lang.S.of(context).purchasePrice,
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

                                                ///__________Dealer &_Wholesale_Price______________________________________
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
                                                Row(
                                                  children: [
                                                    Expanded(
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
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          nsnsacController.text = value!;
                                                        },
                                                        controller: nsnsacController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          labelText: lang.S.of(context).nsnorsac,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enternanorSac,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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

                                                ///____________serial_add_system_____________________________________________
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ///________serial_add_textField______________________________________________
                                                    Expanded(
                                                      child: AppTextField(
                                                        focus: _focusNode,
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        controller: productSerialNumberController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        onFieldSubmitted: (value) {
                                                          if (!value.trim().isEmptyOrNull) {
                                                            if (isSerialNumberUnique(allList: productSerialNumberList, newSerial: value)) {
                                                              setState(() {
                                                                productSerialNumberList.add(value);
                                                                productQuantityController.text == ''
                                                                    ? productQuantityController.text = '1'
                                                                    : productQuantityController.text = (int.parse(productQuantityController.text) + 1).toString();
                                                              });
                                                              productSerialNumberController.clear();
                                                            } else {
                                                              EasyLoading.showError('Serial number already added!');
                                                            }
                                                          } else {
                                                            EasyLoading.showError('Enter a serial number');
                                                          }
                                                          _focusNode.requestFocus();
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
                                                        if (!productSerialNumberController.text.trim().isEmptyOrNull) {
                                                          if (isSerialNumberUnique(allList: productSerialNumberList, newSerial: productSerialNumberController.text)) {
                                                            setState(() {
                                                              productSerialNumberList.add(productSerialNumberController.text);
                                                              productQuantityController.text == ''
                                                                  ? productQuantityController.text = '1'
                                                                  : productQuantityController.text = (int.parse(productQuantityController.text) + 1).toString();
                                                            });
                                                            productSerialNumberController.clear();
                                                          } else {
                                                            EasyLoading.showError('Serial number already added!');
                                                          }
                                                        } else {
                                                          EasyLoading.showError('Enter a serial number');
                                                        }

                                                        _focusNode.requestFocus();
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

                                                    ///__________serial_number_box________________________________________________
                                                    Container(
                                                      // width: context.width() < 1280 ? 200 : 400,
                                                      width: 400,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1, color: Colors.grey),
                                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                      ),
                                                      child: GridView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: productSerialNumberList.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            if (productSerialNumberList.isNotEmpty) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 170,
                                                                      child: Text(
                                                                        productSerialNumberList[index],
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          productSerialNumberList.removeAt(index);
                                                                          productQuantityController.text == '1'
                                                                              ? productQuantityController.text = ''
                                                                              : productQuantityController.text = (int.parse(productQuantityController.text) - 1).toString();
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

                                                ///_________Save_Button________________________________________________
                                                const SizedBox(height: 20.0),
                                                Center(
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width < 1080 ? 1080 * .30 : MediaQuery.of(context).size.width * .30,
                                                    child: ButtonGlobalWithoutIcon(
                                                      buttontext: lang.S.of(context).saveandPublished,
                                                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                                                      onPressed: () async {
                                                        if (validateAndSave()) {
                                                          try {
                                                            EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                            final DatabaseReference productInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Products');
                                                            ProductModel productModel = ProductModel(
                                                              productName: productNameController.text,
                                                              productCategory: selectedCategories ?? 'General',
                                                              size: sizeController.text,
                                                              color: colorController.text,
                                                              weight: weightController.text,
                                                              capacity: capacityController.text,
                                                              type: typeController.text,
                                                              warranty: warrantyController.text == '' ? '' : '${warrantyController.text} $selectedTime',
                                                              brandName: selectedBrand ?? '',
                                                              productCode: productCodeController.text,
                                                              productStock: productQuantityController.text,
                                                              productUnit: selectedUnit ?? '',
                                                              productSalePrice: productSalePriceController.text,
                                                              productPurchasePrice: productPurchasePriceController.text,
                                                              productDiscount: productDiscountPriceController.text,
                                                              productWholeSalePrice: productWholesalePriceController.text,
                                                              productDealerPrice: productDealerPriceController.text,
                                                              productManufacturer: productManufacturerController.text,
                                                              productPicture: productPicture,
                                                              nsnSAC: nsnsacController.text,
                                                              serialNumber: productSerialNumberList,
                                                            );
                                                            await productInformationRef.push().set(productModel.toJson());

                                                            ///_________subscription_plan______________________________________________________
                                                            Subscription.decreaseSubscriptionLimits(itemType: 'products', context: context);

                                                            EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                                                            ref.refresh(productProvider);
                                                            Future.delayed(const Duration(milliseconds: 100), () {
                                                              // const Product().launch(context, isNewTask: true);
                                                              Navigator.pop(context);
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
                                                const SizedBox(height: 10.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///__________Image______________________________________________________
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
                                              const SizedBox(
                                                height: 10,
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
                                    ),
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

  String printSerialNumber(List<String> numberList) {
    String finalString = '';
    for (var element in numberList) {
      finalString + element;
    }

    return finalString;
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
