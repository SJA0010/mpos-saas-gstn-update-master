import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../../constant.dart';
import '../../../../currency.dart';
import '../../Constant Data/constant.dart';

class DueSalePopUp extends StatefulWidget {
  const DueSalePopUp({Key? key}) : super(key: key);

  @override
  State<DueSalePopUp> createState() => _DueSalePopUpState();
}

class _DueSalePopUpState extends State<DueSalePopUp> {
  List<String> userId = [
    'Select Customer',
    'Shahidul\n017XXXXXXXX',
    'Prince\n017XXXXXXXX',
    'Alif\n017XXXXXXXX',
  ];
  String selectedUserId = 'Select Customer';

  DropdownButton<String> getResult() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in userId) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedUserId,
      onChanged: (value) {
        setState(() {
          selectedUserId = value!;
        });
      },
    );
  }

  List<String> userId2 = [
    'Select Customer',
    'Shahidul\n017XXXXXXXX',
    'Prince\n017XXXXXXXX',
    'Alif\n017XXXXXXXX',
  ];
  String selectedUserId2 = 'Select Customer';

  DropdownButton<String> getResult2() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in userId) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedUserId,
      onChanged: (value) {
        setState(() {
          selectedUserId = value!;
        });
      },
    );
  }

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
                            lang.S.of(context).add,
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

  DateTime selectedDueDate = DateTime.now();

  Future<void> _selectedDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDueDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  DateTime selectedSaleDate = DateTime.now();

  DateTime selectedBirthDate = DateTime.now();

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
                  lang.S.of(context).yourDueSales,
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
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FormField(
                    builder: (FormFieldState<dynamic> field) {
                      return InputDecorator(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(FeatherIcons.calendar, color: kTitleColor, size: 18.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                          ),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        child: Text(
                          '${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}',
                          style: kTextStyle.copyWith(color: kTitleColor),
                        ),
                      );
                    },
                  ).onTap(() => _selectedDueDate(context)),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  flex: 2,
                  child: FormField(
                    builder: (FormFieldState<dynamic> field) {
                      return InputDecorator(
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                            contentPadding: EdgeInsets.all(5.0)),
                        child: DropdownButtonHideUnderline(child: getResult()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    showCursor: true,
                    cursorColor: kTitleColor,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      suffixIcon: const Icon(
                        FeatherIcons.search,
                        color: kTitleColor,
                      ),
                      hintText: ('Invoice No..'),
                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                      border: InputBorder.none,
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(color: kDarkWhite, border: Border(bottom: BorderSide(width: 1.0, color: kTitleColor))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                      lang.S.of(context).invoiceno,
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                      maxLines: 2,
                                    )),
                                SizedBox(
                                    width: 180,
                                    child: Text(
                                      lang.S.of(context).customerName,
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                      maxLines: 2,
                                    )),
                                SizedBox(
                                    width: 150,
                                    child: Text(
                                      lang.S.of(context).dateTime,
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                      maxLines: 2,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      '000958',
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                      width: 180,
                                      child: Text(
                                        lang.S.of(context).walkInCustomer,
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                        maxLines: 2,
                                      )),
                                  SizedBox(
                                      width: 150,
                                      child: Text(
                                        '2022-06-27 22:41:13',
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                        maxLines: 2,
                                      )),
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: kWhiteTextColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              lang.S.of(context).saleDetails,
                              textAlign: TextAlign.center,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                            )),
                            Text(
                              'Customer: Walk-in Customer',
                              style: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Phone: 017XXXXXXXX',
                              style: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                            const SizedBox(height: 5.0),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(color: kDarkWhite, border: Border(bottom: BorderSide(width: 1.0, color: kTitleColor))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 120,
                                          child: Text(
                                            lang.S.of(context).item,
                                            style: kTextStyle.copyWith(color: kTitleColor),
                                            maxLines: 2,
                                          )),
                                      SizedBox(
                                          width: 110,
                                          child: Text(
                                            lang.S.of(context).price,
                                            style: kTextStyle.copyWith(color: kTitleColor),
                                            maxLines: 2,
                                          )),
                                      SizedBox(
                                          width: 80,
                                          child: Text(
                                            lang.S.of(context).qty,
                                            style: kTextStyle.copyWith(color: kTitleColor),
                                            maxLines: 2,
                                          )),
                                      SizedBox(
                                          width: 100,
                                          child: Text(
                                            lang.S.of(context).total,
                                            style: kTextStyle.copyWith(color: kTitleColor),
                                            maxLines: 2,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                                itemCount: 5,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            lang.S.of(context).total,
                                            style: kTextStyle.copyWith(color: kTitleColor),
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(
                                            width: 110,
                                            child: Text(
                                              '${currency}2800.00',
                                              style: kTextStyle.copyWith(color: kTitleColor),
                                              maxLines: 2,
                                            )),
                                        SizedBox(
                                            width: 80,
                                            child: Text(
                                              '1',
                                              style: kTextStyle.copyWith(color: kTitleColor),
                                              maxLines: 2,
                                            )),
                                        SizedBox(
                                            width: 100,
                                            child: Text(
                                              '2800.00 tk',
                                              style: kTextStyle.copyWith(color: kTitleColor),
                                              maxLines: 2,
                                            )),
                                      ],
                                    ),
                                  );
                                }),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Item: 2',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    lang.S.of(context).subTotal,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    '2800.00 Tk',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Shipping/Other',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    '0.00 Tk',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.0,
                              color: kLitGreyColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    lang.S.of(context).totalPayable,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    '2800.00 Tk',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    lang.S.of(context).paidAmount,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    '2800.00 Tk',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    lang.S.of(context).dueAmonunt,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    '${currency}0.00',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25.0),
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
                                      lang.S.of(context).print,
                                      style: kTextStyle.copyWith(color: kWhiteTextColor),
                                    )).onTap(() => {finish(context)})
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
