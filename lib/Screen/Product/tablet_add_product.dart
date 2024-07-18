import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Product/tablet_product.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class TabletAddProduct extends StatefulWidget {
  const TabletAddProduct({Key? key}) : super(key: key);
  static const String route = '/mProduct/maddProduct';

  @override
  State<TabletAddProduct> createState() => _TabletAddProductState();
}

class _TabletAddProductState extends State<TabletAddProduct> {
  bool isChecked = true;

  void showPopUp() {
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
                            'Name*',
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

  List<String> categories = [
    'Accessories',
    'Computer',
    'Jacket',
    'T-shirt',
    'Shoes',
    'Fruit',
  ];

  String selectedCategories = 'Accessories';

  DropdownButton<String> getCategories() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in categories) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCategories,
      onChanged: (value) {
        setState(() {
          selectedCategories = value!;
        });
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          lang.S.of(context).counterSale,
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
        iconTheme: const IconThemeData(color: kTitleColor),
        actions: const [Center(child: TopBarTablate())],
      ),
      drawer: const Drawer(
        child: SideBarWidget(
          index: 3,
          isTab: true,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Text(
                                lang.S.of(context).addProduct,
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                lang.S.of(context).addProduct,
                                style: kTextStyle.copyWith(color: kTitleColor),
                              ),
                              const SizedBox(width: 5.0),
                              Container(
                                decoration: const BoxDecoration(
                                  color: kGreyTextColor,
                                ),
                                width: 1.0,
                                height: 20,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                lang.S.of(context).product,
                                style: kTextStyle.copyWith(color: kTitleColor),
                              ),
                            ],
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10.0),
                                      AppTextField(
                                        showCursor: true,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.NAME,
                                        decoration: kInputDecoration.copyWith(
                                          labelText: lang.S.of(context).productNam,
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: lang.S.of(context).enterProductName,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      FormField(
                                        builder: (FormFieldState<dynamic> field) {
                                          return InputDecorator(
                                            decoration: InputDecoration(
                                                enabledBorder: const OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                ),
                                                suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showPopUp()),
                                                contentPadding: const EdgeInsets.all(8.0),
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                labelText: lang.S.of(context).category),
                                            child: DropdownButtonHideUnderline(child: getCategories()),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20.0),
                                      FormField(
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
                                      const SizedBox(height: 20.0),
                                      AppTextField(
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
                                      const SizedBox(height: 20.0),
                                      AppTextField(
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
                                      const SizedBox(height: 20.0),
                                      FormField(
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
                                      const SizedBox(height: 20.0),
                                      AppTextField(
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
                                      const SizedBox(height: 20.0),
                                      AppTextField(
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
                                      const SizedBox(height: 20.0),
                                      AppTextField(
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
                                      const SizedBox(height: 20.0),
                                      AppTextField(
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
                                      const SizedBox(height: 20.0),
                                      AppTextField(
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
                                      const SizedBox(height: 20.0),
                                      SizedBox(
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),
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
                                                    const Icon(Icons.cloud_upload, size: 50.0, color: kLitGreyColor).onTap(() => pickImage(ImageSource.gallery)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                RichText(
                                                    text: TextSpan(
                                                        text: lang.S.of(context).uploadanImage,
                                                        style: kTextStyle.copyWith(color: kGreenTextColor, fontWeight: FontWeight.bold),
                                                        children: [
                                                      TextSpan(
                                                          text: lang.S.of(context).ordragdropPNGPG, style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold))
                                                    ]))
                                              ],
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
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        Center(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * .40,
                              child: ButtonGlobal(
                                  buttontext: lang.S.of(context).saveandPublished,
                                  buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor),
                                  onPressed: () {
                                    finish(context);
                                    const TabletProductScreen().launch(context);
                                  })),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
