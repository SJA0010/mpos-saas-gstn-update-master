import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salespro_admin/model/daily_transaction_model.dart';

import '../../../constant.dart';

String paypalClientId = '';
String paypalClientSecret = '';
const bool sandbox = true;
// const String currency = 'USD';
String countryName = 'Bangladesh';

// const kMainColor = Color(0xFF3F8CFF);
const kMainColor = Color(0xFF5BB26E);
const kDarkGreyColor = Color(0xFF2E2E3E);
const kLitGreyColor = Color(0xFFD4D4D8);
const kGreyTextColor = Color(0xFF585865);
const kBorderColorTextField = Color(0xFFE8E7E5);
const kDarkWhite = Color(0xFFF2F6F8);
const kWhiteTextColor = Color(0xFFFFFFFF);
const kRedTextColor = Color(0xFFFE2525);
const kBlueTextColor = Color(0xFF2DB0F6);
const kYellowColor = Color(0xFFFF8C00);
const kGreenTextColor = Color(0xFF15CD75);
const kTitleColor = Color(0xFF2E2E3E);
final kTextStyle = GoogleFonts.manrope(
  color: Colors.white,
);
const kButtonDecoration = BoxDecoration(
  color: kMainColor,
  borderRadius: BorderRadius.all(
    Radius.circular(40.0),
  ),
);

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kBorderColorTextField),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

List<String> businessCategory = ['Fashion Store', 'Electronics Store', 'Computer Store', 'Vegetable Store', 'Sweet Store', 'Meat Store'];
List<String> language = ['English', 'Bengali', 'Hindi', 'Urdu', 'French', 'Spanish'];

List<String> productCategory = ['Fashion', 'Electronics', 'Computer', 'Gadgets', 'Watches', 'Cloths'];

List<String> userRole = [
  'Super Admin',
  'Admin',
  'User',
];

List<String> paymentType = [
  'Cheque',
  'Deposit',
  'Cash',
  'Transfer',
  'Sales',
];
List<String> posStats = [
  'Daily',
  'Monthly',
  'Yearly',
];
List<String> saleStats = [
  'Weekly',
  'Monthly',
  'Yearly',
];

void updateInvoice({required String typeOfInvoice, required int invoice}) async {
  ///_______invoice_Update_____________________________________________
  final DatabaseReference personalInformationRef =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.ref().child(constUserId).child('Personal Information');

  await personalInformationRef.update({typeOfInvoice: invoice + 1});
}

void postDailyTransaction({required DailyTransactionModel dailyTransactionModel}) async {
  final DatabaseReference personalInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Personal Information');
  double remainingBalance = 0;

  await personalInformationRef.orderByKey().get().then((value) {
    var data = jsonDecode(jsonEncode(value.value));
    remainingBalance = data['remainingShopBalance'];
  });

  if (dailyTransactionModel.type == 'Sale' || dailyTransactionModel.type == 'Due Collection' || dailyTransactionModel.type == 'Income') {
    remainingBalance += dailyTransactionModel.paymentIn;
  } else {
    remainingBalance -= dailyTransactionModel.paymentOut;
  }

  dailyTransactionModel.remainingBalance = remainingBalance;

  ///________post_remaining Balance_on_personal_information___________________________________________________
  await personalInformationRef.update({'remainingShopBalance': remainingBalance});

  ///_________dailyTransaction_Posting________________________________________________________________________
  DatabaseReference dailyTransactionRef = FirebaseDatabase.instance.ref("$constUserId/Daily Transaction");
  await dailyTransactionRef.push().set(dailyTransactionModel.toJson());
}
