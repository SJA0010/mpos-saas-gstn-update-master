import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';

import '../constant.dart';
import '../model/user_role_model.dart';

final logInProvider = ChangeNotifierProvider((ref) => LogInRepo());

class LogInRepo extends ChangeNotifier {
  String email = '';
  String password = '';

  Future<void> signIn(BuildContext context) async {
    EasyLoading.show(status: 'Login...');
    try {
      mainLoginEmail = email;
      mainLoginPassword = password;
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) async {
        if (await checkSubUser()) {
          EasyLoading.showSuccess('Successful');
          setUserDataOnLocalData(uid: constUserId, subUserTitle: constSubUserTitle, isSubUser: true);
          putUserDataImidiyate(uid: constUserId, title: '', isSubUse: true);
          // printUserData();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushNamed(MtHomeScreen.route);
        } else {
          EasyLoading.showSuccess('Successful');
          setUserDataOnLocalData(uid: FirebaseAuth.instance.currentUser!.uid, subUserTitle: '', isSubUser: false);
          putUserDataImidiyate(uid: FirebaseAuth.instance.currentUser!.uid, title: '', isSubUse: false);
          // printUserData();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushNamed(MtHomeScreen.route);
        }
      });

      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('loginOrNot', true);

      // EasyLoading.showSuccess('Successful');
      // setUserDataOnLocalData(uid: FirebaseAuth.instance.currentUser!.uid);
      // pushDataOnGlobalVariable(userId: FirebaseAuth.instance.currentUser!.uid, userName: '');
      // // ignore: use_build_context_synchronously
      // Navigator.of(context).pushNamed(MtHomeScreen.route);
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<bool> checkSubUser() async {
    // bool isSubUser = false;
    // final reference = FirebaseDatabase.instance.ref('Admin Panel').child('User Role');
    //
    // final query = reference.orderByChild('email').equalTo(email);
    //
    // query.once().then((snapshot) {
    //   if (snapshot.snapshot.value != null) {
    //     print('User Data ${snapshot.snapshot.value}');
    //     var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(snapshot.snapshot.value)));
    //
    //     finalUserRoleModel = data;
    //     constUserId = data.databaseId;
    //     constSubUserTitle = data.userTitle;
    //     isSubUser = true;
    //   }
    //
    //   // The `snapshot` contains all the items that match the search criteria
    //   // Loop through the items and do something with each one
    //   // Map<dynamic, dynamic> values = snapshot.snapshot[];
    //   // values.forEach((key, values) {
    //   //   // Do something with each item
    //   //   print('Item id: $key');
    //   //   print('Item name: ${values['itemName']}');
    //   // });
    // });
    // return isSubUser;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSubUser = false;
    await FirebaseDatabase.instance.ref('Admin Panel').child('User Role').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));

        if (data.email == email) {
          finalUserRoleModel = data;
          prefs.setString('userPermission', json.encode(data));
          constUserId = data.databaseId;
          constSubUserTitle = data.userTitle;
          isSubUser = true;
          return;
        }
      }
    });
    return isSubUser;
  }
}
