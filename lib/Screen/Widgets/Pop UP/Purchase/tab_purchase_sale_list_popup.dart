import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../../currency.dart';
import '../../Constant Data/button_global.dart';
import '../../Constant Data/constant.dart';

class TabPurchaseSaleListPopUp extends StatefulWidget {
  const TabPurchaseSaleListPopUp({Key? key}) : super(key: key);

  @override
  State<TabPurchaseSaleListPopUp> createState() => _TabPurchaseSaleListPopUpState();
}

class _TabPurchaseSaleListPopUpState extends State<TabPurchaseSaleListPopUp> {
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
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  lang.S.of(context).yourAllSales,
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  width: context.width(),
                  child: DataTable(
                    headingRowHeight: 40.0,
                    headingRowColor: MaterialStateProperty.all(kDarkWhite),
                    headingTextStyle: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    showBottomBorder: true,
                    dividerThickness: 0,
                    columnSpacing: 5.0,
                    columns: [
                      DataColumn(
                        label: Text(lang.S.of(context).invoiceno),
                      ),
                      DataColumn(
                        label: Text(lang.S.of(context).customerName),
                      ),
                      DataColumn(
                        label: Text(lang.S.of(context).dateTime),
                      ),
                    ],
                    rows: List.generate(
                      5,
                      (index) => DataRow(cells: [
                        DataCell(
                          Text(
                            '624762',
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                        ),
                        DataCell(
                          Text(lang.S.of(context).walkInCustomer, style: kTextStyle.copyWith(color: kTitleColor)),
                        ),
                        DataCell(
                          Text('2022-06-27 22:41:13', style: kTextStyle.copyWith(color: kTitleColor)),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
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
                      const SizedBox(height: 10.0),
                      Center(
                          child: Text(
                        lang.S.of(context).saleDetails,
                        textAlign: TextAlign.center,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      )),
                      const SizedBox(height: 10.0),
                      Text(
                        'Customer: Walk-in Customer',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Phone: 017XXXXXXXX',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: context.width(),
                        child: DataTable(
                          headingRowHeight: 40.0,
                          headingRowColor: MaterialStateProperty.all(kDarkWhite),
                          headingTextStyle: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          showBottomBorder: true,
                          dividerThickness: 0,
                          columnSpacing: 5.0,
                          columns: [
                            DataColumn(
                              label: Text(lang.S.of(context).item),
                            ),
                            DataColumn(
                              label: Text(lang.S.of(context).price),
                            ),
                            DataColumn(
                              label: Text(lang.S.of(context).qty),
                            ),
                            DataColumn(
                              label: Text(lang.S.of(context).total),
                            ),
                          ],
                          rows: List.generate(
                            5,
                            (index) => DataRow(cells: [
                              DataCell(
                                Text(
                                  'Camera',
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                              ),
                              DataCell(
                                Text('$currency 2800.00', style: kTextStyle.copyWith(color: kTitleColor)),
                              ),
                              DataCell(
                                Text('1', style: kTextStyle.copyWith(color: kTitleColor)),
                              ),
                              DataCell(
                                Text('$currency 2800.00', style: kTextStyle.copyWith(color: kTitleColor)),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Total Item: 2',
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .2,
                                      child: Text(
                                        lang.S.of(context).subTotal,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '2800.00 Tk',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .2,
                                      child: Text(
                                        lang.S.of(context).shipingorother,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '0.00 Tk',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .2,
                                      child: Text(
                                        lang.S.of(context).totalPayable,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '2800.00 Tk',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .2,
                                      child: Text(
                                        lang.S.of(context).paidAmount,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '2800.00 Tk',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .2,
                                      child: Text(
                                        lang.S.of(context).dueAmonunt,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${currency}0.00',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: ButtonGlobal(
                              buttontext: lang.S.of(context).cancel,
                              buttonDecoration: kButtonDecoration.copyWith(
                                color: kRedTextColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              onPressed: () {
                                finish(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: ButtonGlobal(
                              buttontext: lang.S.of(context).print,
                              buttonDecoration: kButtonDecoration.copyWith(
                                color: kBlueTextColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              onPressed: () {
                                finish(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
