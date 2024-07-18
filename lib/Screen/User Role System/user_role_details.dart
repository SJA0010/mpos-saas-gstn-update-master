// ignore_for_file: unused_result

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Authentication/login_with_email.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/user_role_provider.dart';
import '../../Repository/get_user_role_repo.dart';
import '../../constant.dart';
import '../../model/user_role_model.dart';
import '../Home/home_screen.dart';
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';

class UserRoleDetails extends StatefulWidget {
  const UserRoleDetails({Key? key, required this.userRoleModel}) : super(key: key);

  final UserRoleModel userRoleModel;

  @override
  // ignore: library_private_types_in_public_api
  _UserRoleDetailsState createState() => _UserRoleDetailsState();
}

class _UserRoleDetailsState extends State<UserRoleDetails> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool allPermissions = false;
  bool salePermission = false;
  bool partiesPermission = false;
  bool purchasePermission = false;
  bool productPermission = false;
  bool profileEditPermission = false;
  bool addExpensePermission = false;
  bool lossProfitPermission = false;
  bool dueListPermission = false;
  bool stockPermission = false;
  bool reportsPermission = false;
  bool salesListPermission = false;
  bool purchaseListPermission = false;
  bool incomePermission = false;
  bool ledgerPermission = false;
  bool dailyTransactionPermission = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController userRoleNameController = TextEditingController();
  bool isMailSent = false;

  @override
  void initState() {
    getAllUserData();
    // TODO: implement initState
    super.initState();
    salePermission = widget.userRoleModel.salePermission;
    partiesPermission = widget.userRoleModel.partiesPermission;
    purchasePermission = widget.userRoleModel.purchasePermission;
    productPermission = widget.userRoleModel.productPermission;
    profileEditPermission = widget.userRoleModel.profileEditPermission;
    addExpensePermission = widget.userRoleModel.addExpensePermission;
    lossProfitPermission = widget.userRoleModel.lossProfitPermission;
    dueListPermission = widget.userRoleModel.dueListPermission;
    stockPermission = widget.userRoleModel.stockPermission;
    reportsPermission = widget.userRoleModel.reportsPermission;
    salesListPermission = widget.userRoleModel.salesListPermission;
    purchaseListPermission = widget.userRoleModel.purchaseListPermission;
    emailController.text = widget.userRoleModel.email;
    titleController.text = widget.userRoleModel.userTitle;
    incomePermission = widget.userRoleModel.incomePermission;
    ledgerPermission = widget.userRoleModel.ledgerPermission;
    dailyTransactionPermission = widget.userRoleModel.dailyTransActionPermission;
    userRoleNameController.text = widget.userRoleModel.userRoleName ?? '';
  }

  UserRoleRepo repo = UserRoleRepo();
  List<UserRoleModel> adminRoleList = [];
  List<UserRoleModel> userRoleList = [];

  String adminRoleKey = '';
  String userRoleKey = '';

  void getAllUserData() async {
    adminRoleList = await repo.getAllUserRoleFromAdmin();
    userRoleList = await repo.getAllUserRole();
    for (var element in adminRoleList) {
      if (element.email == widget.userRoleModel.email) {
        adminRoleKey = element.userKey ?? '';
        break;
      }
    }
    for (var element in userRoleList) {
      if (element.email == widget.userRoleModel.email) {
        userRoleKey = element.userKey ?? '';
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        FeatherIcons.x,
                      )),
                  Text(
                    lang.S.of(context).userRoleDetails,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            String pass = '';
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Center(
                                child: Container(
                                  width: 500,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppTextField(
                                          textFieldType: TextFieldType.EMAIL,
                                          onChanged: (value) {
                                            pass = value;
                                          },
                                          decoration: const InputDecoration(labelText: 'Enter Password', border: OutlineInputBorder()),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ButtonGlobalWithoutIcon(
                                                buttontext: lang.S.of(context).cancel,
                                                buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
                                                onPressed: (() {
                                                  Navigator.pop(context);
                                                }),
                                                buttonTextColor: Colors.white,
                                              ),
                                            ),
                                            Expanded(
                                              child: ButtonGlobalWithoutIcon(
                                                  buttontext: lang.S.of(context).delete,
                                                  buttonDecoration: kButtonDecoration.copyWith(color: Colors.red),
                                                  onPressed: (() async {
                                                    if (pass != '' && pass.isNotEmpty) {
                                                      await deleteUserRole(
                                                          email: widget.userRoleModel.email,
                                                          password: pass,
                                                          adminKey: adminRoleKey,
                                                          userKey: userRoleKey,
                                                          context: context,
                                                          ref: ref);
                                                    } else {
                                                      EasyLoading.showError('Please Enter Password');
                                                    }
                                                  }),
                                                  buttonTextColor: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: kGreyTextColor),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///_______all_&_sale____________________________________________
                      Row(
                        children: [
                          ///_______all__________________________
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: allPermissions,
                              onChanged: (value) {
                                if (value == true) {
                                  setState(() {
                                    allPermissions = value!;
                                    salePermission = true;
                                    partiesPermission = true;
                                    purchasePermission = true;
                                    productPermission = true;
                                    profileEditPermission = true;
                                    addExpensePermission = true;
                                    lossProfitPermission = true;
                                    dueListPermission = true;
                                    stockPermission = true;
                                    reportsPermission = true;
                                    salesListPermission = true;
                                    purchaseListPermission = true;
                                    ledgerPermission = true;
                                    incomePermission = true;
                                    dailyTransactionPermission = true;
                                  });
                                } else {
                                  setState(() {
                                    allPermissions = value!;
                                    salePermission = false;
                                    partiesPermission = false;
                                    purchasePermission = false;
                                    productPermission = false;
                                    profileEditPermission = false;
                                    addExpensePermission = false;
                                    lossProfitPermission = false;
                                    dueListPermission = false;
                                    stockPermission = false;
                                    reportsPermission = false;
                                    salesListPermission = false;
                                    purchaseListPermission = false;
                                    ledgerPermission = false;
                                    incomePermission = false;
                                    dailyTransactionPermission = false;
                                  });
                                }
                              },
                              title: Text(lang.S.of(context).all),
                            ),
                          ),

                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ledgerPermission,
                              onChanged: (value) {
                                setState(() {
                                  ledgerPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).ledger),
                            ),
                          ),
                        ],
                      ),

                      ///_______Edit Profile_&_sale____________________________________________
                      Row(
                        children: [
                          ///_______Edit_Profile_________________________
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: profileEditPermission,
                              onChanged: (value) {
                                setState(() {
                                  profileEditPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).profileEdit),
                            ),
                          ),

                          ///______sales____________________________
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: salePermission,
                              onChanged: (value) {
                                setState(() {
                                  salePermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).sales),
                            ),
                          ),
                        ],
                      ),

                      ///_____parties_&_Purchase_________________________________________
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: partiesPermission,
                              onChanged: (value) {
                                setState(() {
                                  partiesPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).practise),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: purchasePermission,
                              onChanged: (value) {
                                setState(() {
                                  purchasePermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).purchase),
                            ),
                          ),
                        ],
                      ),

                      ///_____Product_&_DueList_________________________________________
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: productPermission,
                              onChanged: (value) {
                                setState(() {
                                  productPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).product),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: dueListPermission,
                              onChanged: (value) {
                                setState(() {
                                  dueListPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).dueList),
                            ),
                          ),
                        ],
                      ),

                      ///_____Stock_&_Reports_________________________________________
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: stockPermission,
                              onChanged: (value) {
                                setState(() {
                                  stockPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).stock),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: reportsPermission,
                              onChanged: (value) {
                                setState(() {
                                  reportsPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).reports),
                            ),
                          ),
                        ],
                      ),

                      ///_____SalesList_&_Purchase List_________________________________________
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: salesListPermission,
                              onChanged: (value) {
                                setState(() {
                                  salesListPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).salesList),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: purchaseListPermission,
                              onChanged: (value) {
                                setState(() {
                                  purchaseListPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).purchaseList),
                            ),
                          ),
                        ],
                      ),

                      ///_____LossProfit_&_Expense_________________________________________
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: lossProfitPermission,
                              onChanged: (value) {
                                setState(() {
                                  lossProfitPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).lossProfit),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: addExpensePermission,
                              onChanged: (value) {
                                setState(() {
                                  addExpensePermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).expense),
                            ),
                          ),
                        ],
                      ),

                      ///_____income_DailyTranstion___________________________________________________
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: incomePermission,
                              onChanged: (value) {
                                setState(() {
                                  incomePermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).income),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: dailyTransactionPermission,
                              onChanged: (value) {
                                setState(() {
                                  dailyTransactionPermission = value!;
                                });
                              },
                              title: Text(lang.S.of(context).dailyTransantion),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              ///___________Text_fields_____________________________________________
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: globalKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ///__________email_________________________________________________________
                      AppTextField(
                        readOnly: true,
                        initialValue: widget.userRoleModel.email,
                        // cursorColor: kTitleColor,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).email,
                          // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterEmailAddresss,
                          // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                          contentPadding: const EdgeInsets.all(10.0),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                          ),
                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                          ),
                        ),
                        textFieldType: TextFieldType.EMAIL,
                      ),
                      const SizedBox(height: 20.0),

                      ///__________Title_________________________________________________________
                      AppTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'User title can\'n be empty';
                          }
                          return null;
                        },
                        showCursor: true,
                        controller: titleController,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).userTitle,
                          hintText: lang.S.of(context).enterYourUserTitle,
                          contentPadding: const EdgeInsets.all(10.0),
                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                          ),
                        ),
                        textFieldType: TextFieldType.EMAIL,
                      ),
                      const SizedBox(height: 20.0),

                      ///__________Title_________________________________________________________
                      AppTextField(
                        validator: (value) {
                          return null;
                        },
                        showCursor: true,
                        controller: userRoleNameController,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).userRole,
                          hintText: lang.S.of(context).enterUserRole,
                          contentPadding: const EdgeInsets.all(10.0),
                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                          ),
                        ),
                        textFieldType: TextFieldType.EMAIL,
                      ),
                      const SizedBox(height: 20.0),

                      TextButton(
                        onPressed: () async {
                          try {
                            EasyLoading.show(status: 'Loading....');
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: widget.userRoleModel.email,
                            );

                            EasyLoading.showSuccess('An Email has been sent\nCheck your inbox');
                            setState(() {
                              isMailSent = true;
                            });
                          } catch (e) {
                            EasyLoading.showError(e.toString());
                          }
                        },
                        child: const Text('Forget password? '),
                      ).visible(!isMailSent),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).update,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: (() async {
                      if (salePermission ||
                          partiesPermission ||
                          purchasePermission ||
                          productPermission ||
                          profileEditPermission ||
                          addExpensePermission ||
                          lossProfitPermission ||
                          dueListPermission ||
                          stockPermission ||
                          reportsPermission ||
                          salesListPermission ||
                          purchaseListPermission ||
                          ledgerPermission ||
                          incomePermission ||
                          dailyTransactionPermission) {
                        try {
                          EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                          DatabaseReference dataRef = FirebaseDatabase.instance.ref("$constUserId/User Role/$userRoleKey");
                          DatabaseReference adminDataRef = FirebaseDatabase.instance.ref("Admin Panel/User Role/$adminRoleKey");
                          await dataRef.update({
                            'userTitle': titleController.text,
                            'salePermission': salePermission,
                            'partiesPermission': partiesPermission,
                            'purchasePermission': purchasePermission,
                            'productPermission': productPermission,
                            'profileEditPermission': profileEditPermission,
                            'addExpensePermission': addExpensePermission,
                            'lossProfitPermission': lossProfitPermission,
                            'dueListPermission': dueListPermission,
                            'stockPermission': stockPermission,
                            'reportsPermission': reportsPermission,
                            'salesListPermission': salesListPermission,
                            'purchaseListPermission': purchaseListPermission,
                            'userRoleName': userRoleNameController.text,
                            'dailyTransActionPermission': dailyTransactionPermission,
                            'incomePermission': incomePermission,
                            'ledgerPermission': ledgerPermission,
                          });
                          await adminDataRef.update({
                            'userTitle': titleController.text,
                            'salePermission': salePermission,
                            'partiesPermission': partiesPermission,
                            'purchasePermission': purchasePermission,
                            'productPermission': productPermission,
                            'profileEditPermission': profileEditPermission,
                            'addExpensePermission': addExpensePermission,
                            'lossProfitPermission': lossProfitPermission,
                            'dueListPermission': dueListPermission,
                            'stockPermission': stockPermission,
                            'reportsPermission': reportsPermission,
                            'salesListPermission': salesListPermission,
                            'purchaseListPermission': purchaseListPermission,
                            'userRoleName': userRoleNameController.text,
                            'dailyTransActionPermission': dailyTransactionPermission,
                            'incomePermission': incomePermission,
                            'ledgerPermission': ledgerPermission,
                          });
                          ref.refresh(userRoleProvider);
                          ref.refresh(allUserRoleProvider);

                          EasyLoading.showSuccess('Successfully Updated', duration: const Duration(milliseconds: 500));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } catch (e) {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      } else {
                        EasyLoading.showError('You Have To Give Permission');
                      }
                    }),
                    buttonTextColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Future<void> deleteUserRole(
    {required String email, required String password, required String adminKey, required String userKey, required BuildContext context, required WidgetRef ref}) async {
  EasyLoading.show(status: 'Loading...');
  try {
    final userCredential = await FirebaseAuth.instance.signInWithCredential(EmailAuthProvider.credential(email: email, password: password));
    final user = userCredential.user;
    await user?.delete();
    DatabaseReference dataRef = FirebaseDatabase.instance.ref("$constUserId/User Role/$userKey");
    DatabaseReference adminDataRef = FirebaseDatabase.instance.ref("Admin Panel/User Role/$adminKey");

    await dataRef.remove();
    await adminDataRef.remove();

    if (FirebaseAuth.instance.currentUser == null) {
      try {
        await Future.delayed(const Duration(seconds: 1));
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: mainLoginEmail, password: mainLoginPassword);
        await Future.delayed(const Duration(seconds: 2));
        ref.refresh(userRoleProvider);
        ref.refresh(allUserRoleProvider);

        EasyLoading.showSuccess('Successfully deleted');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed(MtHomeScreen.route);
      } on FirebaseAuthException catch (e) {
        EasyLoading.showError('Error');
        EasyLoading.showError(e.message.toString());
        if (e.code == 'user-not-found') {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user found for that email.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (e.code == 'wrong-password') {
          EasyLoading.showError('wrong-password');
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wrong password provided for that user.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        EasyLoading.showError(e.toString());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    // await Future.delayed(const Duration(seconds: 1));
  } catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showError(e.toString());
  }
}

Future showSussesScreenAndLogOut({required BuildContext context}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      lang.S.of(context).deleteSuccessful,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.S.of(context).youhaveRELOGINonyouraccount,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).ok,
                      buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
                      onPressed: (() {
                        const LogInEmail(
                          isEmailLogin: true,
                          panelName: '',
                        ).launch(context, isNewTask: true);
                      }),
                      buttonTextColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
