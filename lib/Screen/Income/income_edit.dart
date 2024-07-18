import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/income_provider.dart';
import 'package:salespro_admin/model/income_modle.dart';
import '../../constant.dart';
import '../../model/expense_category_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

class IncomeEdit extends StatefulWidget {
  const IncomeEdit({Key? key, required this.incomeModel, required this.menuContext}) : super(key: key);

  final IncomeModel incomeModel;
  final BuildContext menuContext;

  @override
  State<IncomeEdit> createState() => _IncomeEditState();
}

class _IncomeEditState extends State<IncomeEdit> {
  void showCategoryPopUp() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
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
                                lang.S.of(context).addCategory,
                                style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(
                                FeatherIcons.x,
                                color: kTitleColor,
                                size: 50.0,
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
                ),
              ),
            );
          });
        });
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

  List<String> categories = [
    'Accessories',
    'Computer',
    'Office Vehicle',
    'Lunch',
    'Snacks',
  ];
  List<String> paymentMethods = [
    'Cash',
    'Bank',
    'Card',
    'Mobile Payment',
    'Snacks',
  ];

  String selectedCategories = 'Accessories';
  String selectedPaymentType = 'Cash';

  String expenseKey = '';

  void getExpenseKey() async {
    await FirebaseDatabase.instance.ref(constUserId).child('Income').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['incomeFor'].toString() == widget.incomeModel.incomeFor &&
            data['amount'].toString() == widget.incomeModel.amount &&
            data['incomeDate'].toString() == widget.incomeModel.incomeDate &&
            data['paymentType'].toString() == widget.incomeModel.paymentType) {
          expenseKey = element.key.toString();
        }
      }
    });
  }

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

  DropdownButton<String> getPaymentMethods() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in paymentMethods) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedPaymentType,
      onChanged: (value) {
        setState(() {
          selectedPaymentType = value!;
        });
      },
    );
  }

  Future<void> category() async {
    await FirebaseDatabase.instance.ref(constUserId).child('Income Category').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = ExpenseCategoryModel.fromJson(jsonDecode(jsonEncode(element.value)));
        categories.add(data.categoryName);
      }
    });
    selectedCategories = widget.incomeModel.category;
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  TextEditingController incomeForNameController = TextEditingController();
  TextEditingController incomeAmountController = TextEditingController();
  TextEditingController incomeNoteController = TextEditingController();
  TextEditingController incomeRefController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    incomeForNameController.text = widget.incomeModel.incomeFor;
    incomeAmountController.text = widget.incomeModel.amount;
    incomeNoteController.text = widget.incomeModel.note;
    incomeRefController.text = widget.incomeModel.referenceNo;
    selectedDate = DateTime.parse(widget.incomeModel.incomeDate);
    selectedPaymentType = widget.incomeModel.paymentType;
    getExpenseKey();
    category();
  }

  ScrollController mainScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          backgroundColor: kDarkWhite,
          body: Scrollbar(
            controller: mainScroll,
            child: SingleChildScrollView(
              controller: mainScroll,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(
                    width: 240,
                    child: SideBarWidget(
                      index: 11,
                      isTab: false,
                    ),
                  ),
                  Container(
                    width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: kWhiteTextColor,
                            ),
                            child: const TopBar(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang.S.of(context).income,
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          lang.S.of(context).addUpdateIncomeList,
                                          style: kTextStyle.copyWith(color: kLitGreyColor),
                                        ),
                                        const Spacer(),
                                        const Icon(FeatherIcons.x, color: kTitleColor, size: 30.0).onTap(() => Navigator.pop(context))
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Divider(
                                      thickness: 1.0,
                                      color: kGreyTextColor.withOpacity(0.2),
                                    ),
                                    const SizedBox(height: 20.0),

                                    ///______date_&_category____________________________________
                                    Row(
                                      children: [
                                        ///__________date_picker________________________________
                                        Expanded(
                                          child: FormField(
                                            builder: (FormFieldState<dynamic> field) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                  suffixIcon: const Icon(FeatherIcons.calendar, color: kGreyTextColor),
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                  ),
                                                  contentPadding: const EdgeInsets.all(8.0),
                                                  labelText: lang.S.of(context).incomeDate,
                                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                  hintText: lang.S.of(context).enterIncomeDate,
                                                  hintStyle: kTextStyle.copyWith(color: kTitleColor),
                                                ),
                                                child: Text(
                                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                                  style: kTextStyle.copyWith(color: kTitleColor),
                                                ),
                                              );
                                            },
                                          ).onTap(() => _selectDate(context)),
                                        ),
                                        const SizedBox(width: 20.0),

                                        ///_____category___________________________________________
                                        Expanded(
                                          child: FormField(
                                            builder: (FormFieldState<dynamic> field) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                    ),
                                                    suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showCategoryPopUp()),
                                                    contentPadding: const EdgeInsets.all(8.0),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: lang.S.of(context).category),
                                                child: DropdownButtonHideUnderline(child: getCategories()),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),

                                    ///________payment Type_&_expanseFor_______________________________
                                    Row(
                                      children: [
                                        ///___________________Expanse for_______________________________
                                        Expanded(
                                          child: TextFormField(
                                            showCursor: true,
                                            controller: incomeForNameController,
                                            validator: (value) {
                                              if (value.isEmptyOrNull) {
                                                return 'Please Enter Name';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              incomeForNameController.text = value!;
                                            },
                                            cursorColor: kTitleColor,
                                            decoration: kInputDecoration.copyWith(
                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                              labelText: lang.S.of(context).incomefor,
                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                              hintText: 'Enter Name',
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        ///________PaymentType__________________________________
                                        Expanded(
                                          child: FormField(
                                            builder: (FormFieldState<dynamic> field) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                    ),
                                                    suffixIcon: const Icon(FeatherIcons.plus, color: kTitleColor).onTap(() => showCategoryPopUp()),
                                                    contentPadding: const EdgeInsets.all(8.0),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: lang.S.of(context).paymentType),
                                                child: DropdownButtonHideUnderline(child: getPaymentMethods()),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),

                                    ///_______amount_reference_number______________________________________
                                    Row(
                                      children: [
                                        ///_________________Amount_____________________________
                                        Expanded(
                                          child: TextFormField(
                                            showCursor: true,
                                            controller: incomeAmountController,
                                            validator: (value) {
                                              if (value.isEmptyOrNull) {
                                                return 'please Inter Amount';
                                              } else if (double.tryParse(value!) == null) {
                                                return 'Enter a valid Amount';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              incomeAmountController.text = value!;
                                            },
                                            cursorColor: kTitleColor,
                                            decoration: kInputDecoration.copyWith(
                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                              labelText: lang.S.of(context).amount,
                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                              hintText: lang.S.of(context).enterAmount,
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        ///_______reference_________________________________
                                        Expanded(
                                          child: TextFormField(
                                            showCursor: true,
                                            controller: incomeRefController,
                                            validator: (value) {
                                              return null;
                                            },
                                            onSaved: (value) {
                                              incomeRefController.text = value!;
                                            },
                                            cursorColor: kTitleColor,
                                            decoration: kInputDecoration.copyWith(
                                              labelText: lang.S.of(context).referenceNumber,
                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                              hintText: lang.S.of(context).enterReferenceNumber,
                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    ///_________note____________________________________________________
                                    const SizedBox(height: 20.0),
                                    SizedBox(
                                      width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                                      child: TextFormField(
                                        showCursor: true,
                                        controller: incomeNoteController,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'please Inter Amount';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          incomeNoteController.text = value!;
                                        },
                                        cursorColor: kTitleColor,
                                        decoration: kInputDecoration.copyWith(
                                          labelText: lang.S.of(context).note,
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: lang.S.of(context).enterNote,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        ),
                                      ),
                                    ),

                                    ///___________buttons___________________________________________
                                    const SizedBox(height: 30.0),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ///_______cancel__________________________________________________

                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 120,
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              color: Colors.red,
                                            ),
                                            child: Center(
                                              child: Text(
                                                lang.S.of(context).cancel,
                                                style: kTextStyle.copyWith(color: kWhiteTextColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),

                                        ///________save__________________________________________________
                                        Container(
                                          width: 120,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: kGreenTextColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              lang.S.of(context).saveandPublished,
                                              style: kTextStyle.copyWith(color: kWhiteTextColor),
                                            ),
                                          ),
                                        ).onTap(() async {
                                          if (validateAndSave()) {
                                            IncomeModel income = IncomeModel(
                                              incomeDate: selectedDate.toString(),
                                              category: selectedCategories,
                                              account: '',
                                              amount: incomeAmountController.text,
                                              incomeFor: incomeForNameController.text,
                                              paymentType: selectedPaymentType,
                                              referenceNo: incomeRefController.text,
                                              note: incomeNoteController.text,
                                            );
                                            try {
                                              EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                              final DatabaseReference productInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Income').child(expenseKey);
                                              await productInformationRef.set(income.toJson());
                                              EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));

                                              ///____provider_refresh____________________________________________
                                              // ignore: unused_result
                                              ref.refresh(incomeProvider);

                                              Future.delayed(const Duration(milliseconds: 100), () {
                                                // const Product().launch(context, isNewTask: true);
                                                Navigator.pop(context);
                                              });
                                            } catch (e) {
                                              EasyLoading.dismiss();
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                            }
                                          }
                                        }),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],
                                ),
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
          ),
        );
      },
    );
  }
}
