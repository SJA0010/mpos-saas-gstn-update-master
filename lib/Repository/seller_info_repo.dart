import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import '../model/seller_info_model.dart';

class SellerInfoRepo {
  Future<List<SellerInfoModel>> getAllSeller() async {
    List<SellerInfoModel> sellerList = [];

    await FirebaseDatabase.instance.ref('Admin Panel').child('Seller List').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = SellerInfoModel.fromJson(jsonDecode(jsonEncode(element.value)));
        sellerList.add(data);
      }
    });
    return sellerList;
  }
}
// class SellerInfoRepo {
//   DatabaseReference ref = FirebaseDatabase.instance.ref();
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//
//
//   Future<SellerInfoModel> getDetails() async {
//     SellerInfoModel personalInfo = SellerInfoModel(
//         phoneNumber: 'Loading...',
//         companyName: 'Loading...',
//         businessCategory: 'Loading...',
//         language: 'Loading...',
//         countryName: 'Loading...',
//         userID: 'Loading',
//         subscriptionName: 'Loading',
//         subscriptionDate: 'Loading',
//         subscriptionMethod: 'Loading',
//         pictureUrl: 'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png');
//     final model = await ref.child('Admin Panel/Seller List').get();
//     var data = jsonDecode(jsonEncode(model.value));
//     if (data == null) {
//       return personalInfo;
//     } else {
//       return SellerInfoModel.fromJson(data);
//     }
//   }
// }
