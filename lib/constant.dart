import 'package:nb_utils/nb_utils.dart';
import 'model/user_role_model.dart';

// void voidLink({required BuildContext context}) {
//   (constUserId == '' || constUserId.isEmptyOrNull)
//       ? const LogInEmail(
//           isEmailLogin: true,
//           panelName: '',
//         ).launch(context, isNewTask: true)
//       : null;
// }

String currencyLogo = '₹';

String constUserId = '';
bool isSubUser = false;
String constSubUserTitle = '';

String subUserEmail = '';

String searchItems = '';

String mainLoginPassword = '';
String mainLoginEmail = '';

UserRoleModel finalUserRoleModel = UserRoleModel(
  email: '',
  userTitle: '',
  databaseId: '',
  salePermission: true,
  partiesPermission: true,
  purchasePermission: true,
  productPermission: true,
  profileEditPermission: true,
  addExpensePermission: true,
  lossProfitPermission: true,
  dueListPermission: true,
  stockPermission: true,
  reportsPermission: true,
  salesListPermission: true,
  purchaseListPermission: true,
  dailyTransActionPermission: true,
  incomePermission: true,
  ledgerPermission: true,
);

Future<void> setUserDataOnLocalData({required String uid, required String subUserTitle, required bool isSubUser}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', uid);
  await prefs.setString('subUserTitle', subUserTitle);
  await prefs.setBool('isSubUser', isSubUser);
}

Future<void> printUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final String? uid = prefs.getString('userId');
  final String? subUserTitle = prefs.getString('subUserTitle');
  final bool? isSubU = prefs.getBool('isSubUser');

  constUserId = uid ?? '';
  constSubUserTitle = subUserTitle ?? '';
  isSubUser = isSubU ?? false;
}

Future<String> getUserID() async {
  final prefs = await SharedPreferences.getInstance();
  final String? uid = prefs.getString('userId');

  return uid ?? '';
}

void putUserDataImidiyate({required String uid, required String title, required bool isSubUse}) {
  constUserId = uid;
  constSubUserTitle = title;
  isSubUser = isSubUse;
}

// class CurrentUserData {
//   void getUserData() async {
//     constUserId = prefs.getString('userId') ?? '';
//     isSubUser = prefs.getBool('isSubUser') ?? false;
//     subUserEmail = prefs.getString('subUserEmail') ?? '';
//     await updateData();
//   }
//
//   Future<void> updateData() async {
//     await FirebaseDatabase.instance.ref(constUserId).child('User Role').orderByKey().get().then((value) async {
//       for (var element in value.children) {
//         var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));
//         if (data.email == subUserEmail) {
//           finalUserRoleModel = data;
//         }
//       }
//     });
//   }
// }
