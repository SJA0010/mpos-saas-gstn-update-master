// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:pinput/pinput.dart';
// import 'package:salespro_admin/Screen/Authentication/phone_authentication.dart';
// import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
//
// import '../Widgets/Constant Data/constant.dart';
//
// class VerifyOtp extends StatefulWidget {
//   const VerifyOtp({Key? key, required this.confirmationResult, required this.phoneNumber}) : super(key: key);
//   final ConfirmationResult confirmationResult;
//   final String phoneNumber;
//
//   static const String route = '/verifyOtp';
//
//   @override
//   State<VerifyOtp> createState() => _VerifyOtpState();
// }
//
// class _VerifyOtpState extends State<VerifyOtp> {
//   String code = '';
//   TextEditingController otpController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kDarkWhite,
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SizedBox(
//             width: context.width() < 750 ? 750 : MediaQuery.of(context).size.width,
//             height: context.height() < 500 ? 500 : MediaQuery.of(context).size.height,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Container(
//                           width: context.width() < 940 ? 477 : MediaQuery.of(context).size.width * .50,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 10.0),
//                               Container(
//                                 height: 80,
//                                 width: 80,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   image: DecorationImage(
//                                     image: AssetImage('images/mpos.png'),
//                                   ),
//                                 ),
//                               ),
//                               Divider(
//                                 thickness: 1.0,
//                                 color: kGreyTextColor.withOpacity(0.1),
//                               ),
//                               const SizedBox(height: 10.0),
//                               Text(
//                                 'Phone Verification',
//                                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 10.0),
//                               Text(
//                                 'We need to register your phone before getting started!',
//                                 style: kTextStyle.copyWith(
//                                   color: kGreyTextColor,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 30.0),
//                               Pinput(
//                                 length: 6,
//                                 showCursor: true,
//                                 controller: otpController,
//                                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                                 onCompleted: (pin) async {
//                                   code = pin;
//                                   await FirebaseAuthentication().authenticateMe(
//                                     confirmationResult: widget.confirmationResult,
//                                     otp: code,
//                                     context: context,
//                                     otpController: otpController,
//                                     phone: widget.phoneNumber,
//                                   );
//                                 },
//                               ),
//                               const SizedBox(height: 10.0),
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: ButtonGlobal(
//                                   buttontext: 'Verify Phone Number',
//                                   buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor, borderRadius: BorderRadius.circular(8.0)),
//                                   onPressed: (() async {
//                                     await FirebaseAuthentication().authenticateMe(
//                                       confirmationResult: widget.confirmationResult,
//                                       otp: code,
//                                       context: context,
//                                       otpController: otpController,
//                                       phone: widget.phoneNumber,
//                                     );
//                                   }),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
