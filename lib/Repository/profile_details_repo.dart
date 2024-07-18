import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import '../constant.dart';
import '../model/personal_information_model.dart';

class ProfileRepo {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<PersonalInformationModel> getDetails() async {
    PersonalInformationModel personalInfo = PersonalInformationModel(
      companyName: 'Loading...',
      businessCategory: 'Loading...',
      countryName: 'Loading...',
      language: 'Loading...',
      phoneNumber: 'Loading...',
      pictureUrl: 'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png',
      shopOpeningBalance: 0,
      dueInvoiceCounter: 1,
      purchaseInvoiceCounter: 1,
      saleInvoiceCounter: 1,
      remainingShopBalance: 0,
      address: '',
      city: '',
      email: '',
      gstNo: '',
      state: '',
      zip: '',
      ifscNumber: '',
      bankName: '',
      bankBranchName: '',
      bankAccountNumber: '',
      tAndC: '',
    );
    final model = await ref.child('${await getUserID()}/Personal Information').get();
    var data = jsonDecode(jsonEncode(model.value));
    if (data == null) {
      return personalInfo;
    } else {
      return PersonalInformationModel.fromJson(data);
    }
  }
}
