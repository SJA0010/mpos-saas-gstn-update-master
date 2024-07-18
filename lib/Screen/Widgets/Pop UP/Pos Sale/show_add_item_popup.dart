import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Constant Data/constant.dart';

class ShowAddItemPopUp extends StatefulWidget {
  const ShowAddItemPopUp({Key? key}) : super(key: key);

  @override
  State<ShowAddItemPopUp> createState() => _ShowAddItemPopUpState();
}

class _ShowAddItemPopUpState extends State<ShowAddItemPopUp> {
  List<String> categoryList = [
    'Accessories',
    'Computer',
    'Jacket',
    'T-shirt',
    'Shoes',
    'Fruit',
  ];

  String selectedCategoryList = 'Accessories';

  DropdownButton<String> getCategoryList() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in categoryList) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCategoryList,
      onChanged: (value) {
        setState(() {
          selectedCategoryList = value!;
        });
      },
    );
  }

  bool isChecked = true;
  List<String> brandName = [
    'Nike',
    'Puma',
    'Adidas',
  ];

  String selectedBrand = 'Nike';

  DropdownButton<String> getBrand() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in brandName) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedBrand,
      onChanged: (value) {
        setState(() {
          selectedBrand = value!;
        });
      },
    );
  }

  List<String> unit = [
    'Kilogram',
    'Meter',
    'Piece',
  ];

  String selectedUnit = 'Kilogram';

  DropdownButton<String> getUnit() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in unit) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedUnit,
      onChanged: (value) {
        setState(() {
          selectedUnit = value!;
        });
      },
    );
  }

  void showCategoryAddPopUp() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: 600,
                height: context.height() / 1.6,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
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
                            lang.S.of(context).nam,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 50),
                          SizedBox(
                            width: 400,
                            child: Expanded(
                              child: AppTextField(
                                showCursor: true,
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.NAME,
                                decoration: kInputDecoration.copyWith(
                                  hintText: lang.S.of(context).name,
                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
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
                                value: isChecked,
                                onChanged: (val) {
                                  setState(
                                    () {
                                      isChecked = val!;
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
                                value: isChecked,
                                onChanged: (val) {
                                  setState(
                                    () {
                                      isChecked = val!;
                                    },
                                  );
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
                                value: isChecked,
                                onChanged: (val) {
                                  setState(
                                    () {
                                      isChecked = val!;
                                    },
                                  );
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
                                value: isChecked,
                                onChanged: (val) {
                                  setState(
                                    () {
                                      isChecked = val!;
                                    },
                                  );
                                },
                              ),
                              title: Text(lang.S.of(context).capacity),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: Checkbox(
                          activeColor: kMainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          value: isChecked,
                          onChanged: (val) {
                            setState(
                              () {
                                isChecked = val!;
                              },
                            );
                          },
                        ),
                        title: Text(lang.S.of(context).type),
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
                          ).onTap(() {
                            finish(context);
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

  void showBrandPopUp() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: 600,
                height: context.height() / 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
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
                            lang.S.of(context).nam,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                          ),
                          const SizedBox(width: 50),
                          SizedBox(
                            width: 400,
                            child: Expanded(
                              child: AppTextField(
                                showCursor: true,
                                cursorColor: kTitleColor,
                                textFieldType: TextFieldType.NAME,
                                decoration: kInputDecoration.copyWith(
                                  hintText: lang.S.of(context).name,
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
                          ).onTap(() {
                            finish(context);
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

  void showUnitPopUp() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: 320,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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
                          lang.S.of(context).nam,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        ),
                        const SizedBox(width: 50),
                        SizedBox(
                          width: 400,
                          child: Expanded(
                            child: AppTextField(
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).name,
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          lang.S.of(context).description,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        ),
                        const SizedBox(width: 10.0),
                        SizedBox(
                          width: 400,
                          child: Expanded(
                            child: AppTextField(
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).description,
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
                        ).onTap(() {
                          finish(context);
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

  // Import Image
  File? image;

  Future pickImage(ImageSource gallery) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  lang.S.of(context).addItem,
                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                const Spacer(),
                const Icon(FeatherIcons.x, color: kTitleColor, size: 25.0).onTap(() => {finish(context)})
              ],
            ),
          ),
          const Divider(thickness: 1.0, color: kLitGreyColor),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).productName,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterProductName,
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                ),
                                suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showCategoryAddPopUp()),
                                contentPadding: const EdgeInsets.all(8.0),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).category),
                            child: DropdownButtonHideUnderline(child: getCategoryList()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                ),
                                suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showBrandPopUp()),
                                contentPadding: const EdgeInsets.all(8.0),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).brand),
                            child: DropdownButtonHideUnderline(child: getBrand()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).productCodes,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterProductCode,
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).stock,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterStockAmount,
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showUnitPopUp()),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                ),
                                contentPadding: const EdgeInsets.all(8.0),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).productUnit),
                            child: DropdownButtonHideUnderline(child: getUnit()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).salePrice,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterSalePrice,
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).purchasePrice,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterPurchasePrice,
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).discountPrice,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterDiscountPrice,
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
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
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).dealerPice,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterDealerPrice,
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: SizedBox(
                        width: (context.width() / 4),
                        child: AppTextField(
                          showCursor: true,
                          cursorColor: kTitleColor,
                          textFieldType: TextFieldType.NAME,
                          decoration: kInputDecoration.copyWith(
                            labelText: lang.S.of(context).menufetather,
                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText: lang.S.of(context).enterMenuFeatherName,
                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 300,
                  child: DottedBorderWidget(
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
                                const Icon(Icons.cloud_upload, size: 50.0, color: kLitGreyColor).onTap(() => pickImage(ImageSource.gallery)),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            RichText(
                                text: TextSpan(
                                    text: lang.S.of(context).uploadanImage,
                                    style: kTextStyle.copyWith(color: kGreenTextColor, fontWeight: FontWeight.bold),
                                    children: [TextSpan(text: lang.S.of(context).ordragdropPNGPG, style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold))]))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                image != null
                    ? Image.network(
                        image!.path,
                        width: 150,
                        height: 150,
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: kRedTextColor,
                        ),
                        child: Text(
                          lang.S.of(context).cancel,
                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                        )).onTap(() => {finish(context)}),
                    const SizedBox(width: 10.0),
                    Container(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: kBlueTextColor,
                        ),
                        child: Text(
                          lang.S.of(context).submit,
                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                        )).onTap(() => {finish(context)})
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
