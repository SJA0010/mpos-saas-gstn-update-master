import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Authentication/tablet_signup.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Repository/login_repo.dart';
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';

class TabletLogIn extends StatefulWidget {
  const TabletLogIn({Key? key}) : super(key: key);

  static const String route = '/mlogin';

  @override
  State<TabletLogIn> createState() => _TabletLogInState();
}

class _TabletLogInState extends State<TabletLogIn> {
  late String email, password;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final loginProvider = ref.watch(logInProvider);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 100.0),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/mpos.png'),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1.0,
                                color: kGreyTextColor.withOpacity(0.1),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                lang.S.of(context).counterSaleSingUpPanel,
                                style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Form(
                                  key: globalKey,
                                  child: Column(
                                    children: [
                                      AppTextField(
                                        showCursor: true,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.EMAIL,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Email can\'n be empty';
                                          } else if (!value.contains('@')) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          loginProvider.email = value;
                                        },
                                        decoration: kInputDecoration.copyWith(
                                          labelText: lang.S.of(context).email,
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: lang.S.of(context).enterEmailAddresss,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                          prefixIcon: const Icon(FeatherIcons.mail, color: kTitleColor),
                                        ),
                                      ),
                                      const SizedBox(height: 30.0),
                                      AppTextField(
                                        showCursor: true,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.PASSWORD,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Password can\'t be empty';
                                          } else if (value.length < 4) {
                                            return 'Please enter a bigger password';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          loginProvider.password = value;
                                        },
                                        decoration: kInputDecoration.copyWith(
                                          contentPadding: EdgeInsets.zero,
                                          labelText: lang.S.of(context).password,
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: lang.S.of(context).enterYourPassword,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                          prefixIcon: const Icon(FeatherIcons.lock, color: kTitleColor),
                                        ),
                                      ),
                                      const SizedBox(height: 30.0),
                                      ButtonGlobal(
                                          buttontext: lang.S.of(context).login,
                                          buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor, borderRadius: BorderRadius.circular(8.0)),
                                          onPressed: (() {
                                            if (validateAndSave()) {
                                              loginProvider.signIn(context);
                                            }
                                          })),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              horizontalTitleGap: 0,
                                              leading: const Icon(
                                                Icons.lock_outline,
                                                color: kTitleColor,
                                              ),
                                              title: Text(
                                                lang.S.of(context).forgotpassword,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Expanded(
                                            child: ListTile(
                                              onTap: (() => Navigator.of(context).pushNamed(TabletSignUp.route)),
                                              contentPadding: EdgeInsets.zero,
                                              horizontalTitleGap: 0,
                                              title: Text(
                                                lang.S.of(context).register,
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
