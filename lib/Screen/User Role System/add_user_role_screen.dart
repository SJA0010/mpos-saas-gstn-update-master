// ignore_for_file: unused_result

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/user_role_provider.dart';
import '../../constant.dart';
import '../../model/user_role_model.dart';
import '../Home/home_screen.dart';
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';

class AddUserRole extends StatefulWidget {
  const AddUserRole({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddUserRoleState createState() => _AddUserRoleState();
}

class _AddUserRoleState extends State<AddUserRole> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

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
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController userRoleName = TextEditingController();

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
                children: [
                  Text(
                    lang.S.of(context).addUserRole,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_sharp,
                      color: Colors.black,
                    ),
                  )
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
                                    dailyTransactionPermission = true;
                                    ledgerPermission = true;
                                    incomePermission = true;
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
                                    dailyTransactionPermission = false;
                                    ledgerPermission = false;
                                    incomePermission = false;
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
                    children: [
                      ///__________email_________________________________________________________
                      AppTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email can\'n be empty';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        showCursor: true,
                        controller: emailController,
                        // cursorColor: kTitleColor,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).email,
                          // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: 'maantheme@gmail.com',
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

                      ///______password___________________________________________________________
                      AppTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password can\'t be empty';
                          } else if (value.length < 4) {
                            return 'Please enter a bigger password';
                          }
                          return null;
                        },
                        controller: passwordController,
                        showCursor: true,
                        // cursorColor: kTitleColor,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Password',
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: 'Enter your password',
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
                        textFieldType: TextFieldType.PASSWORD,
                      ),

                      ///________retype_email____________________________________________________
                      const SizedBox(height: 20.0),
                      AppTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password can\'t be empty';
                          } else if (value != passwordController.text) {
                            return 'Password and confirm password does not match';
                          } else if (value.length < 4) {
                            return 'Please enter a bigger password';
                          }
                          return null;
                        },
                        controller: confirmPasswordController,
                        showCursor: true,
                        // cursorColor: kTitleColor,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).confirmPassword,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).enterYourConfirmPassord,
                          // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
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
                        textFieldType: TextFieldType.PASSWORD,
                      ),

                      ///__________Title_________________________________________________________
                      const SizedBox(height: 20.0),
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
                      AppTextField(
                        showCursor: true,
                        validator: (value) {
                          return null;
                        },
                        controller: userRoleName,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).userRoleName,
                          hintText: lang.S.of(context).enterYourUserRoleName,
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
                    ],
                  ),
                ),
              ),

              ///_________button__________________________________________________
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).create,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: (() {
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
                          purchaseListPermission) {
                        if (validateAndSave()) {
                          UserRoleModel userRoleData = UserRoleModel(
                            email: emailController.text,
                            userTitle: titleController.text,
                            databaseId: FirebaseAuth.instance.currentUser!.uid,
                            salePermission: salePermission,
                            partiesPermission: partiesPermission,
                            purchasePermission: purchasePermission,
                            productPermission: productPermission,
                            profileEditPermission: profileEditPermission,
                            addExpensePermission: addExpensePermission,
                            lossProfitPermission: lossProfitPermission,
                            dueListPermission: dueListPermission,
                            stockPermission: stockPermission,
                            reportsPermission: reportsPermission,
                            salesListPermission: salesListPermission,
                            purchaseListPermission: purchaseListPermission,
                            dailyTransActionPermission: dailyTransactionPermission,
                            ledgerPermission: ledgerPermission,
                            incomePermission: incomePermission,
                            userRoleName: userRoleName.text,
                          );
                          // print(FirebaseAuth.instance.currentUser!.uid);
                          signUp(
                            context: context,
                            email: emailController.text,
                            password: passwordController.text,
                            ref: ref,
                            userRoleModel: userRoleData,
                          );
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

void signUp({required BuildContext context, required String email, required String password, required WidgetRef ref, required UserRoleModel userRoleModel}) async {
  EasyLoading.show(status: 'Registering....');
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    if (userCredential.additionalUserInfo!.isNewUser) {
      await FirebaseDatabase.instance.ref().child(userRoleModel.databaseId).child('User Role').push().set(userRoleModel.toJson());
      await FirebaseDatabase.instance.ref().child('Admin Panel').child('User Role').push().set(userRoleModel.toJson());

      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));
      try {
        await Future.delayed(const Duration(seconds: 1));
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: mainLoginEmail, password: mainLoginPassword);
        await Future.delayed(const Duration(seconds: 2));
        ref.refresh(userRoleProvider);

        EasyLoading.showSuccess('Successfully Added');
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
  } on FirebaseAuthException catch (e) {
    EasyLoading.showError('Failed with Error');
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The password provided is too weak.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The account already exists for that email.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    EasyLoading.showError('Failed with Error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
