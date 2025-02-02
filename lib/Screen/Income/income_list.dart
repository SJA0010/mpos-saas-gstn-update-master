import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Income/income_edit.dart';
import 'package:salespro_admin/Screen/Income/new_income.dart';
import 'package:salespro_admin/model/income_modle.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/income_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import '../Widgets/no_data_found.dart';
import 'income_category.dart';
import 'income_details.dart';

class IncomeList extends StatefulWidget {
  const IncomeList({Key? key}) : super(key: key);

  static const String route = '/Income';

  @override
  State<IncomeList> createState() => _IncomeListState();
}

class _IncomeListState extends State<IncomeList> {
  List<int> item = [
    10,
    20,
    30,
    50,
    80,
    100,
  ];
  int selectedItem = 10;
  int itemCount = 10;

  void getSearchProduct() {
    setState(() {
      searchItems;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // voidLink(context: context);
    searchItems = '';
  }

  DropdownButton<int> selectItem() {
    List<DropdownMenuItem<int>> dropDownItems = [];
    for (int des in item) {
      var item = DropdownMenuItem(
        value: des,
        child: Text('${des.toString()} items'),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedItem,
      onChanged: (value) {
        setState(() {
          selectedItem = value!;
          itemCount = value;
        });
      },
    );
  }

  List<String> month = [
    'This Month',
    'Last Month',
    'March',
    'February',
    'January',
  ];

  String selectedMonth = 'This Month';

  DropdownButton<String> getMonth() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in month) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedMonth,
      onChanged: (value) {
        setState(() {
          selectedMonth = value!;
        });
      },
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  DateTime selected2ndDate = DateTime.now();

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selected2ndDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selected2ndDate) {
      setState(() {
        selected2ndDate = picked;
      });
    }
  }

  double calculateAllExpense({required List<IncomeModel> allExpense}) {
    double totalExpense = 0;
    for (var element in allExpense) {
      totalExpense += element.amount.toDouble();
    }

    return totalExpense;
  }

  ScrollController mainScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) {
          final incomes = ref.watch(incomeProvider);
          return incomes.when(data: (allIncome) {
            List<IncomeModel> reverseAllIncome = allIncome.reversed.toList();
            List<IncomeModel> showIncome = [];
            for (var element in reverseAllIncome) {
              if (searchItems != '' && (element.incomeFor.contains(searchItems) || element.category.contains(searchItems))) {
                showIncome.add(element);
              } else if (searchItems == '') {
                showIncome.add(element);
              }
            }
            return Scaffold(
                backgroundColor: kDarkWhite,
                body: Scrollbar(
                  controller: mainScroll,
                  child: SingleChildScrollView(
                    controller: mainScroll,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 240,
                          child: SideBarWidget(
                            index: 10,
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
                                  child: TopBar(callback: () => getSearchProduct()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: kWhiteTextColor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: FormField(
                                                builder: (FormFieldState<dynamic> field) {
                                                  return InputDecorator(
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    child: DropdownButtonHideUnderline(child: getMonth()),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 20.0),
                                            Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: kGreyTextColor)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(shape: BoxShape.rectangle, color: kGreyTextColor),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          lang.S.of(context).between,
                                                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ).onTap(() => _selectDate(context)),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      lang.S.of(context).to,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      '${selected2ndDate.day}/${selected2ndDate.month}/${selected2ndDate.year}',
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ).onTap(() => _selectedDate(context)),
                                                    const SizedBox(width: 10.0),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFFCFF4E3),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$currency ${calculateAllExpense(allExpense: incomes.value ?? [])}',
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(
                                                lang.S.of(context).totalIncome,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              lang.S.of(context).incomeList,
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                              child: Text(
                                                lang.S.of(context).incomeCategory,
                                                style: kTextStyle.copyWith(color: kWhiteTextColor),
                                              ),
                                            ).onTap(
                                              () => const IncomeCategory().launch(context),
                                            ),
                                            const SizedBox(width: 20.0),
                                            Container(
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                              child: Row(
                                                children: [
                                                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 18.0),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    lang.S.of(context).newIncome,
                                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                  ),
                                                ],
                                              ),
                                            ).onTap(
                                              () => Navigator.of(context).pushNamed(NewIncome.route),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),
                                        Divider(
                                          thickness: 1.0,
                                          color: kGreyTextColor.withOpacity(0.2),
                                        ),
                                        // const SizedBox(height: 20.0),
                                        Row(
                                          children: [
                                            Text(
                                              lang.S.of(context).show,
                                              style: kTextStyle.copyWith(color: kTitleColor),
                                            ),
                                            const SizedBox(width: 5.0),
                                            SizedBox(
                                              width: 110.0,
                                              height: 40,
                                              child: FormField(
                                                builder: (FormFieldState<dynamic> field) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        borderSide: const BorderSide(color: kGreyTextColor),
                                                      ),
                                                      contentPadding: const EdgeInsets.only(left: 10.0, right: 4.0),
                                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                                    ),
                                                    child: DropdownButtonHideUnderline(child: selectItem()),
                                                  );
                                                },
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 40.0,
                                              width: 300,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kGreyTextColor.withOpacity(0.1))),
                                              child: AppTextField(
                                                showCursor: true,
                                                cursorColor: kTitleColor,
                                                onChanged: (value) {
                                                  setState(() {
                                                    // searchItem = value;
                                                  });
                                                },
                                                textFieldType: TextFieldType.NAME,
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.all(10.0),
                                                  hintText: (lang.S.of(context).search),
                                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                  border: InputBorder.none,
                                                  suffixIcon: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Container(
                                                        padding: const EdgeInsets.all(2.0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          color: kGreyTextColor.withOpacity(0.1),
                                                        ),
                                                        child: const Icon(
                                                          FeatherIcons.search,
                                                          color: kTitleColor,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ).visible(false),
                                        // const SizedBox(height: 20.0),
                                        // const ExportButton2(),
                                        // const SizedBox(height: 20.0),

                                        ///__________Income_LIst____________________________________________________________________
                                        const SizedBox(height: 20.0),
                                        showIncome.isNotEmpty
                                            ? Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(15),
                                                    decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                                    child: const Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(width: 50, child: Text('S.L')),
                                                        SizedBox(width: 75, child: Text('Date')),
                                                        SizedBox(width: 150, child: Text('Created By')),
                                                        SizedBox(width: 100, child: Text('Category')),
                                                        SizedBox(width: 150, child: Text('Note')),
                                                        SizedBox(width: 100, child: Text('Payment Type')),
                                                        SizedBox(width: 70, child: Text('Amount')),
                                                        SizedBox(width: 30, child: Icon(FeatherIcons.settings)),
                                                      ],
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: showIncome.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(15),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                ///______________S.L__________________________________________________
                                                                SizedBox(
                                                                  width: 50,
                                                                  child: Text((index + 1).toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                ),

                                                                ///______________Date__________________________________________________
                                                                SizedBox(
                                                                  width: 75,
                                                                  child: Text(
                                                                    showIncome[index].incomeDate.substring(0, 10),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),

                                                                ///____________Created By_________________________________________________
                                                                SizedBox(
                                                                  width: 150,
                                                                  child: Text(showIncome[index].incomeFor,
                                                                      maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                ),

                                                                ///______Category___________________________________________________________
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: Text(
                                                                    showIncome[index].category,
                                                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                ///___________note______________________________________________

                                                                SizedBox(
                                                                  width: 150,
                                                                  child: Text(
                                                                    showIncome[index].note.toString(),
                                                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                ///___________Payment tYpe____________________________________________________
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: Text(
                                                                    showIncome[index].paymentType.toString(),
                                                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                ///___________Amount____________________________________________________

                                                                SizedBox(
                                                                  width: 70,
                                                                  child: Text(
                                                                    showIncome[index].amount.toString(),
                                                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                ///_______________actions_________________________________________________
                                                                SizedBox(
                                                                  width: 30,
                                                                  child: PopupMenuButton(
                                                                    padding: EdgeInsets.zero,
                                                                    itemBuilder: (BuildContext bc) => [
                                                                      PopupMenuItem(
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            showDialog(
                                                                              barrierDismissible: false,
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return StatefulBuilder(
                                                                                  builder: (context, setStates) {
                                                                                    return Dialog(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                                      ),
                                                                                      child: IncomeDetails(income: showIncome[index], manuContext: bc),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              const Icon(Icons.remove_red_eye_outlined, size: 18.0, color: kTitleColor),
                                                                              const SizedBox(width: 4.0),
                                                                              Text(
                                                                                lang.S.of(context).view,
                                                                                style: kTextStyle.copyWith(color: kTitleColor),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      ///____________edit___________________________________________
                                                                      PopupMenuItem(
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            IncomeEdit(
                                                                              menuContext: bc,
                                                                              incomeModel: showIncome[index],
                                                                            ).launch(context);
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                                                              const SizedBox(width: 4.0),
                                                                              Text(
                                                                                lang.S.of(context).edit,
                                                                                style: kTextStyle.copyWith(color: kTitleColor),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    child: Center(
                                                                      child: Container(
                                                                          height: 18,
                                                                          width: 18,
                                                                          alignment: Alignment.centerRight,
                                                                          child: const Icon(
                                                                            Icons.more_vert_sharp,
                                                                            size: 18,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: double.infinity,
                                                            height: 1,
                                                            color: kGreyTextColor.withOpacity(0.2),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            : noDataFoundImage(text: lang.S.of(context).noIncomeFound),
                                        // SizedBox(
                                        //   width: double.infinity,
                                        //   child: DataTable(
                                        //     headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                                        //     showBottomBorder: false,
                                        //     columnSpacing: 0.0,
                                        //     columns: [
                                        //       DataColumn(
                                        //         label: Text(
                                        //           'S.L',
                                        //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //         ),
                                        //       ),
                                        //       DataColumn(
                                        //         label: Text('Date', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                        //       ),
                                        //       DataColumn(
                                        //         label: SizedBox(
                                        //           width: 100.0,
                                        //           child: Text(
                                        //             'Created By',
                                        //             style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       DataColumn(
                                        //         label: Text(
                                        //           'Category',
                                        //           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //           overflow: TextOverflow.ellipsis,
                                        //         ),
                                        //       ),
                                        //       DataColumn(
                                        //         label: SizedBox(
                                        //             width: 100.0,
                                        //             child: Text(
                                        //               'Reference No',
                                        //               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        //               overflow: TextOverflow.ellipsis,
                                        //             )),
                                        //       ),
                                        //       DataColumn(
                                        //         label: Text('Note', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                        //       ),
                                        //       DataColumn(
                                        //         label: Text('Payment Type', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                        //         // label: Icon(FeatherIcons.settings, color: kGreyTextColor),
                                        //       ),
                                        //       DataColumn(
                                        //         numeric: true,
                                        //         label: Text('Amount', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                        //       ),
                                        //       DataColumn(
                                        //         numeric: true,
                                        //         label: Text('Actions', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                        //       ),
                                        //     ],
                                        //     rows: List.generate(
                                        //       showIncome.length,
                                        //       (index) => DataRow(cells: [
                                        //         DataCell(
                                        //           Text((index + 1).toString()),
                                        //         ),
                                        //         DataCell(
                                        //           GestureDetector(
                                        //               onTap: () {},
                                        //               child: Text(showIncome[index].incomeDate.substring(0, 10),
                                        //                   style: kTextStyle.copyWith(color: kGreyTextColor))),
                                        //         ),
                                        //         DataCell(
                                        //           Text(showIncome[index].incomeFor, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        //         ),
                                        //         DataCell(
                                        //           Text(showIncome[index].category, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        //         ),
                                        //         DataCell(
                                        //           Text(showIncome[index].referenceNo.toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        //         ),
                                        //         DataCell(
                                        //           SizedBox(
                                        //               width: 150,
                                        //               child: Text(showIncome[index].note,
                                        //                   maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor))),
                                        //         ),
                                        //         DataCell(
                                        //           Text(showIncome[index].paymentType, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        //         ),
                                        //         DataCell(
                                        //           Text(showIncome[index].amount, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        //         ),
                                        //
                                        //         ///__________action_menu__________________________________________________________
                                        //         DataCell(
                                        //           PopupMenuButton(
                                        //             icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                        //             padding: EdgeInsets.zero,
                                        //             itemBuilder: (BuildContext bc) => [
                                        //               ///_________view___________________________________________
                                        //               PopupMenuItem(
                                        //                 child: GestureDetector(
                                        //                   onTap: () {
                                        //                     showDialog(
                                        //                       barrierDismissible: false,
                                        //                       context: context,
                                        //                       builder: (BuildContext context) {
                                        //                         return StatefulBuilder(
                                        //                           builder: (context, setStates) {
                                        //                             return Dialog(
                                        //                               shape: RoundedRectangleBorder(
                                        //                                 borderRadius: BorderRadius.circular(20.0),
                                        //                               ),
                                        //                               child: IncomeDetails(income: showIncome[index], manuContext: bc),
                                        //                             );
                                        //                           },
                                        //                         );
                                        //                       },
                                        //                     );
                                        //                   },
                                        //                   child: Row(
                                        //                     children: [
                                        //                       const Icon(Icons.remove_red_eye_outlined, size: 18.0, color: kTitleColor),
                                        //                       const SizedBox(width: 4.0),
                                        //                       Text(
                                        //                         'View',
                                        //                         style: kTextStyle.copyWith(color: kTitleColor),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //
                                        //               ///____________edit___________________________________________
                                        //               PopupMenuItem(
                                        //                 child: GestureDetector(
                                        //                   onTap: () {
                                        //                     IncomeEdit(
                                        //                       menuContext: bc,
                                        //                       incomeModel: showIncome[index],
                                        //                     ).launch(context);
                                        //                   },
                                        //                   child: Row(
                                        //                     children: [
                                        //                       const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                        //                       const SizedBox(width: 4.0),
                                        //                       Text(
                                        //                         'Edit',
                                        //                         style: kTextStyle.copyWith(color: kTitleColor),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ]),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
            // return ExpensesTableWidget(incomes: allExpenses);
          }, error: (e, stack) {
            return Center(
              child: Text(e.toString()),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        },
      ),
    );
  }
}
