import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Repository/login_repo.dart';
import 'package:salespro_admin/Screen/Authentication/sign_up.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';
import 'forgot_password.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:salespro_admin/generated/l10n.dart' as lang;

class LogInEmail extends StatefulWidget {
  const LogInEmail({Key? key, required this.isEmailLogin, required this.panelName}) : super(key: key);

  static const String route = '/login';
  final bool isEmailLogin;
  final String panelName;

  @override
  State<LogInEmail> createState() => _LogInEmailState();
}

class _LogInEmailState extends State<LogInEmail> {
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
  void initState() {
    // TODO: implement initState
    super.initState();

    // html.window.location

    html.window.onBeforeUnload.listen((event) async {
      if (event is html.BeforeUnloadEvent) event.returnValue = "Don't go!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkWhite,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: context.width() < 750 ? 750 : MediaQuery.of(context).size.width,
              height: context.height() < 500 ? 500 : MediaQuery.of(context).size.height,
              child: Consumer(builder: (context, ref, watch) {
                final loginProvider = ref.watch(logInProvider);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      width: context.width() < 940 ? 477 : MediaQuery.of(context).size.width * .50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10.0),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('images/mlogo.png'),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                            color: kGreyTextColor.withOpacity(0.1),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'MPOS ${widget.panelName} Login Panel',
                            style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: globalKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10.0),
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
                                  const SizedBox(height: 20.0),
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
                                  const SizedBox(height: 20.0),
                                  ButtonGlobal(
                                      buttontext: lang.S.of(context).login,
                                      buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor, borderRadius: BorderRadius.circular(8.0)),
                                      onPressed: (() {
                                        if (validateAndSave()) {
                                          loginProvider.signIn(context);
                                        }
                                      })),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   children: [
                                  //
                                  //     Expanded(
                                  //       child: ButtonGlobal(
                                  //           buttontext: 'Admin',
                                  //           buttonDecoration: kButtonDecoration.copyWith(color: const Color(0xff03A9F4), borderRadius: BorderRadius.circular(8.0)),
                                  //           onPressed: (() {
                                  //             const LogInEmail(
                                  //               isEmailLogin: true,
                                  //               panelName: '',
                                  //             ).launch(context);
                                  //           })),
                                  //     ),
                                  //     const SizedBox(height: 20),
                                  //     // Expanded(
                                  //     //   child: ButtonGlobal(
                                  //     //       buttontext: 'Staff Login',
                                  //     //       buttonDecoration: kButtonDecoration.copyWith(color: const Color(0xff9039FF), borderRadius: BorderRadius.circular(8.0)),
                                  //     //       onPressed: (() {
                                  //     //         const LogInEmail(
                                  //     //           isEmailLogin: false,
                                  //     //           panelName: 'Staff',
                                  //     //         ).launch(context);
                                  //     //       })),
                                  //     // ),
                                  //     // const SizedBox(height: 20),
                                  //     Expanded(
                                  //       child: ButtonGlobal(
                                  //           buttontext: 'Seller Login',
                                  //           buttonDecoration: kButtonDecoration.copyWith(color: const Color(0xffFF4CFF), borderRadius: BorderRadius.circular(8.0)),
                                  //           onPressed: (() {
                                  //             const LogInEmail(
                                  //               isEmailLogin: false,
                                  //               panelName: 'Seller',
                                  //             ).launch(context);
                                  //           })),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 20.0).visible(widget.isEmailLogin),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          onTap: () => Navigator.pushNamed(context, ForgotPassword.route),
                                          contentPadding: EdgeInsets.zero,
                                          horizontalTitleGap: 0,
                                          leading: const Icon(
                                            Icons.lock_outline_rounded,
                                            color: kGreenTextColor,
                                          ),
                                          title: Text(
                                            'Forgot password?',
                                            style: kTextStyle.copyWith(color: kGreenTextColor),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 130,
                                        child: ListTile(
                                          onTap: (() => Navigator.pushNamed(context, SignUp.route)),
                                          contentPadding: EdgeInsets.zero,
                                          horizontalTitleGap: 0,
                                          leading: const Icon(
                                            Icons.how_to_reg,
                                            color: kGreenTextColor,
                                          ),
                                          title: Text(
                                            'Registration',
                                            style: kTextStyle.copyWith(color: kGreenTextColor),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).visible(widget.isEmailLogin),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ));
  }
}
