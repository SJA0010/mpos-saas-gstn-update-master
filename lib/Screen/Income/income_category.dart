import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/expense_category_proivder.dart';
import 'package:salespro_admin/Provider/income_provider.dart';
import 'package:salespro_admin/Screen/Income/add_income_category.dart';
import 'package:salespro_admin/Screen/Income/edit_income_category.dart';
import 'package:salespro_admin/model/income_catehory_model.dart';
import 'package:salespro_admin/model/income_modle.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import '../Widgets/no_data_found.dart';

class IncomeCategory extends StatefulWidget {
  const IncomeCategory({Key? key}) : super(key: key);

  static const String route = '/expenses/expensesCategory';

  @override
  State<IncomeCategory> createState() => _IncomeCategoryState();
}

class _IncomeCategoryState extends State<IncomeCategory> {
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

  String searchItem = '';

  bool checkAnyIncome({required List<IncomeModel> allList, required String category}) {
    for (var element in allList) {
      if (element.category == category) {
        return false;
      }
    }
    return true;
  }

  void deleteExpenseCategory({required String incomeCategoryName, required WidgetRef updateRef, required BuildContext context}) async {
    EasyLoading.show(status: 'Deleting..');
    String expenseKey = '';
    await FirebaseDatabase.instance.ref(constUserId).child('Income Category').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['categoryName'].toString() == incomeCategoryName) {
          expenseKey = element.key.toString();
        }
      }
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Income Category/$expenseKey");
    await ref.remove();
    // ignore: unused_result
    updateRef.refresh(expenseCategoryProvider);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    EasyLoading.showSuccess('Done');
  }

  ScrollController mainScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) {
          final allIncome = ref.watch(incomeCategoryProvider);
          final allIncomes = ref.watch(incomeProvider);
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
                              child: const TopBar(),
                            ),
                            allIncome.when(data: (allIncomeCategory) {
                              List<IncomeCategoryModel> reverseAllIncomeCategory = allIncomeCategory.reversed.toList();
                              List<IncomeCategoryModel> showIncomeCategory = [];
                              for (var element in reverseAllIncomeCategory) {
                                if (searchItem != '' && (element.categoryName.contains(searchItem) || element.categoryName.contains(searchItem))) {
                                  showIncomeCategory.add(element);
                                } else if (searchItem == '') {
                                  showIncomeCategory.add(element);
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            lang.S.of(context).incomeCategoryList,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                          ),
                                          const Spacer(),
                                          const SizedBox(width: 20.0),
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                            child: Container(
                                              padding: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                              child: Row(
                                                children: [
                                                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 18.0),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    lang.S.of(context).addCategory,
                                                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).onTap(
                                            () => showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder: (context, setStates) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      child: AddIncomeCategory(listOfIncomeCategory: allIncomeCategory),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Divider(
                                        thickness: 1.0,
                                        color: kGreyTextColor.withOpacity(0.2),
                                      ),
                                      const SizedBox(height: 20.0),
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
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 20.0),
                                      // const ExportButton2(),
                                      const SizedBox(height: 20.0),

                                      ///__________expense_LIst____________________________________________________________________
                                      showIncomeCategory.isNotEmpty
                                          ? SizedBox(
                                              width: double.infinity,
                                              child: DataTable(
                                                headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                                                showBottomBorder: false,
                                                columnSpacing: 0.0,
                                                columns: [
                                                  DataColumn(
                                                    label: Text(
                                                      'S.L',
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: SizedBox(
                                                      width: 100.0,
                                                      child: Text(
                                                        lang.S.of(context).categoryName,
                                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      lang.S.of(context).description,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    numeric: true,
                                                    label: Text(lang.S.of(context).action, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                                  ),
                                                ],
                                                rows: List.generate(
                                                  showIncomeCategory.length,
                                                  (index) => DataRow(cells: [
                                                    DataCell(
                                                      Text((index + 1).toString()),
                                                    ),
                                                    DataCell(
                                                      Text(showIncomeCategory[index].categoryName, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                    ),
                                                    DataCell(
                                                      Text(showIncomeCategory[index].categoryDescription, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                    ),

                                                    ///__________action_menu__________________________________________________________
                                                    DataCell(
                                                      PopupMenuButton(
                                                        icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                                        padding: EdgeInsets.zero,
                                                        itemBuilder: (BuildContext bc) => [
                                                          ///_________Edit___________________________________________
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
                                                                          child: EditIncomeCategory(
                                                                            listOfExpanseCategory: allIncomeCategory,
                                                                            incomeCategoryModel: showIncomeCategory[index],
                                                                            menuContext: bc,
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  const Icon(Icons.edit, size: 18.0, color: kTitleColor),
                                                                  const SizedBox(width: 4.0),
                                                                  Text(
                                                                    'Edit',
                                                                    style: kTextStyle.copyWith(color: kTitleColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          ///____________Delete___________________________________________
                                                          PopupMenuItem(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                if (checkAnyIncome(allList: allIncomes.value!, category: showIncomeCategory[index].categoryName)) {
                                                                  showDialog(
                                                                      barrierDismissible: false,
                                                                      context: context,
                                                                      builder: (BuildContext dialogContext) {
                                                                        return Center(
                                                                          child: Container(
                                                                            decoration: const BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(20.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    lang.S.of(context).areYouWantTodeletethisCusotmer,
                                                                                    style: const TextStyle(fontSize: 22),
                                                                                  ),
                                                                                  const SizedBox(height: 30),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        child: Container(
                                                                                          width: 130,
                                                                                          height: 50,
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Colors.green,
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(15),
                                                                                            ),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              lang.S.of(context).cancel,
                                                                                              style: const TextStyle(color: Colors.white),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          Navigator.pop(dialogContext);
                                                                                          Navigator.pop(bc);
                                                                                        },
                                                                                      ),
                                                                                      const SizedBox(width: 30),
                                                                                      GestureDetector(
                                                                                        child: Container(
                                                                                          width: 130,
                                                                                          height: 50,
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Colors.red,
                                                                                            borderRadius: BorderRadius.all(
                                                                                              Radius.circular(15),
                                                                                            ),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              lang.S.of(context).delete,
                                                                                              style: const TextStyle(color: Colors.white),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          deleteExpenseCategory(
                                                                                            incomeCategoryName: showIncomeCategory[index].categoryName,
                                                                                            updateRef: ref,
                                                                                            context: dialogContext,
                                                                                          );
                                                                                          Navigator.pop(dialogContext);
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                } else {
                                                                  EasyLoading.showError('This category Cannot be deleted');
                                                                }
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                                                  const SizedBox(width: 4.0),
                                                                  Text(
                                                                    lang.S.of(context).delete,
                                                                    style: kTextStyle.copyWith(color: kTitleColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            )
                                          : noDataFoundImage(text: lang.S.of(context).noIncomeCategoryFound),
                                    ],
                                  ),
                                ),
                              );

                              // return ExpensesTableWidget(expenses: allExpenses);
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
