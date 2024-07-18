// ignore_for_file: unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/model/income_catehory_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/expense_category_proivder.dart';
import '../../constant.dart';
import '../../model/expense_category_model.dart';
import '../Widgets/Constant Data/constant.dart';

class EditIncomeCategory extends StatefulWidget {
  const EditIncomeCategory({Key? key, required this.listOfExpanseCategory, required this.incomeCategoryModel, required this.menuContext}) : super(key: key);

  final List<IncomeCategoryModel> listOfExpanseCategory;
  final IncomeCategoryModel incomeCategoryModel;
  final BuildContext menuContext;

  @override
  State<EditIncomeCategory> createState() => _EditIncomeCategoryState();
}

class _EditIncomeCategoryState extends State<EditIncomeCategory> {
  String categoryDescription = '';
  String categoryName = '';

  String expenseKey = '';

  void getExpenseKey() async {
    await FirebaseDatabase.instance.ref(constUserId).child('Income Category').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['categoryName'].toString() == widget.incomeCategoryModel.categoryName) {
          expenseKey = element.key.toString();
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryDescription = widget.incomeCategoryModel.categoryDescription;
    categoryName = widget.incomeCategoryModel.categoryName;
    getExpenseKey();
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = [];
    for (var element in widget.listOfExpanseCategory) {
      names.add(element.categoryName.removeAllWhiteSpace().toLowerCase());
    }
    return Consumer(
      builder: (context, ref, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: kWhiteTextColor,
              ),
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              lang.S.of(context).enterCategoryName,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                            ),
                            const Spacer(),
                            const Icon(FeatherIcons.x, color: kTitleColor, size: 30.0).onTap(() {
                              Navigator.pop(context);
                              Navigator.pop(widget.menuContext);
                            })
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Divider(
                          thickness: 1.0,
                          color: kGreyTextColor.withOpacity(0.2),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          lang.S.of(context).pleaseEnterValidData,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: 580,
                          child: AppTextField(
                            initialValue: categoryName,
                            onChanged: (value) {
                              categoryName = value;
                            },
                            showCursor: true,
                            cursorColor: kTitleColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: lang.S.of(context).categoryName,
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              hintText: lang.S.of(context).enterCategoryName,
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: 580,
                          child: AppTextField(
                            initialValue: categoryDescription,
                            onChanged: (value) {
                              categoryDescription = value;
                            },
                            showCursor: true,
                            cursorColor: kTitleColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: lang.S.of(context).description,
                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                              hintText: lang.S.of(context).adddescription,
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.red,
                              ),
                              width: 150,
                              child: Column(
                                children: [
                                  Text(
                                    lang.S.of(context).cancel,
                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                  ),
                                ],
                              ),
                            ).onTap(() {
                              Navigator.pop(context);
                              Navigator.pop(widget.menuContext);
                            }),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: kGreenTextColor,
                              ),
                              width: 150,
                              child: Column(
                                children: [
                                  Text(
                                    lang.S.of(context).saveandPublished,
                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                  ),
                                ],
                              ),
                            ).onTap(() {
                              ExpenseCategoryModel expenseCategory = ExpenseCategoryModel(categoryName: categoryName, categoryDescription: categoryDescription);
                              if (categoryName != '' && categoryName == widget.incomeCategoryModel.categoryName
                                  ? true
                                  : !names.contains(categoryName.toLowerCase().removeAllWhiteSpace())) {
                                setState(() async {
                                  try {
                                    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                    final DatabaseReference productInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Income Category').child(expenseKey);
                                    await productInformationRef.set(expenseCategory.toJson());
                                    EasyLoading.showSuccess('Edit Successfully', duration: const Duration(milliseconds: 500));

                                    ///____provider_refresh____________________________________________
                                    ref.refresh(incomeCategoryProvider);

                                    Future.delayed(const Duration(milliseconds: 100), () {
                                      Navigator.pop(context);
                                      Navigator.pop(widget.menuContext);
                                    });
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                });
                              } else if (names.contains(categoryName.toLowerCase().removeAllWhiteSpace())) {
                                EasyLoading.showError('Category Name Already Exists');
                              } else {
                                EasyLoading.showError('Enter Category Name');
                              }
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
