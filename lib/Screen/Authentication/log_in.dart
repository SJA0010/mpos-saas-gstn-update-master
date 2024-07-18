// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:salespro_admin/Screen/Authentication/login_with_email.dart';
// import 'package:salespro_admin/Screen/Authentication/phone_authentication.dart';
// import 'package:salespro_admin/Screen/Authentication/verify_otp.dart';
// import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
//
// import '../Widgets/Constant Data/constant.dart';
//
// class LogIn extends StatefulWidget {
//   const LogIn({Key? key}) : super(key: key);
//
//   static const String route = '/login';
//
//   @override
//   State<LogIn> createState() => _LogInState();
// }
//
// class _LogInState extends State<LogIn> {
//   late String email, password;
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//   String? user;
//   static String phoneNumber = '';
//   static String countryCode = '+880';
//
//   bool validateAndSave() {
//     final form = globalKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }
//
//   void showPopUP() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: SizedBox(
//             height: 400,
//             width: 600,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const Icon(
//                         FeatherIcons.x,
//                         color: kTitleColor,
//                       ).onTap(() {
//                         finish(context);
//                       }),
//                     ],
//                   ),
//                   const SizedBox(height: 100.0),
//                   Text(
//                     'Please download our mobile app and subscribe to a package to use the desktop version',
//                     textAlign: TextAlign.center,
//                     style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
//                   ),
//                   const SizedBox(height: 50.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 60,
//                         width: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15.0),
//                           image: const DecorationImage(image: AssetImage('images/playstore.png'), fit: BoxFit.cover),
//                         ),
//                       ),
//                       const SizedBox(width: 20.0),
//                       Container(
//                         height: 60,
//                         width: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15.0),
//                           image: const DecorationImage(image: AssetImage('images/appstore.png'), fit: BoxFit.cover),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   var currentUser = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: kDarkWhite,
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SizedBox(
//               width: context.width() < 750 ? 750 : MediaQuery.of(context).size.width,
//               height: context.height() < 500 ? 500 : MediaQuery.of(context).size.height,
//               child: Consumer(builder: (context, ref, watch) {
//                 return Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Center(
//                     child: Container(
//                       width: context.width() < 940 ? 477 : MediaQuery.of(context).size.width * .50,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const SizedBox(height: 10.0),
//                           Container(
//                             height: 80,
//                             width: 80,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                 image: AssetImage('images/mpos.png'),
//                               ),
//                             ),
//                           ),
//                           Divider(
//                             thickness: 1.0,
//                             color: kGreyTextColor.withOpacity(0.1),
//                           ),
//                           const SizedBox(height: 10.0),
//                           Text(
//                             'MPOS Login Panel',
//                             style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 10.0),
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Form(
//                               key: globalKey,
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: AppTextField(
//                                       showCursor: true,
//                                       cursorColor: kTitleColor,
//                                       textFieldType: TextFieldType.PHONE,
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Phone Number can\'n be empty';
//                                         } else if (value.length < 8) {
//                                           return 'Enter a valid Phone Number';
//                                         }
//                                         return null;
//                                       },
//                                       onChanged: (value) {
//                                         phoneNumber = value;
//                                       },
//                                       onFieldSubmitted: (value) async {
//                                         if (validateAndSave()) {
//                                           ConfirmationResult confirmationResult = await FirebaseAuthentication().sendOTP(countryCode + value);
//
//                                           // ignore: use_build_context_synchronously
//                                           VerifyOtp(
//                                             confirmationResult: confirmationResult,
//                                             phoneNumber: countryCode + value,
//                                           ).launch(context);
//                                         }
//                                       },
//                                       decoration: kInputDecoration.copyWith(
//                                         errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
//                                         labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                         hintText: 'Enter your phone Number',
//                                         hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
//                                         prefixIcon: CountryCodePicker(
//                                           favorite: const ['BD'],
//                                           padding: EdgeInsets.zero,
//                                           onChanged: (value) {
//                                             countryCode = value.dialCode!;
//                                             countryName = value.name!;
//                                           },
//                                           initialSelection: 'BD',
//                                           showFlag: true,
//                                           showDropDownButton: true,
//                                           alignLeft: false,
//                                         ),
//                                       ),
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.digitsOnly,
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20.0),
//                                   ButtonGlobal(
//                                     buttontext: 'Get OTP',
//                                     buttonDecoration: kButtonDecoration.copyWith(
//                                       color: kGreenTextColor,
//                                       borderRadius: BorderRadius.circular(8.0),
//                                     ),
//                                     onPressed: (() async {
//                                       if (validateAndSave()) {
//                                         ConfirmationResult confirmationResult = await FirebaseAuthentication().sendOTP(countryCode + phoneNumber);
//
//                                         // ignore: use_build_context_synchronously
//                                         VerifyOtp(
//                                           confirmationResult: confirmationResult,
//                                           phoneNumber: countryCode + phoneNumber,
//                                         ).launch(context);
//                                       }
//                                     }),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 TextButton(
//                                     onPressed: () {
//                                       const LogInEmail(
//                                         isEmailLogin: false,
//                                       ).launch(context);
//                                     },
//                                     child: const Text('Staff Login')),
//                                 TextButton(
//                                     onPressed: () {
//                                       const LogInEmail(
//                                         isEmailLogin: true,
//                                       ).launch(context);
//                                     },
//                                     child: const Text('Login with Email')),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ));
//   }
// }
