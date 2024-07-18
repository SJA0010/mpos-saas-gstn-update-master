import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import '../constant.dart';
import '../model/customer_model.dart';

class CustomerRepo {
  Future<List<CustomerModel>> getAllCustomer() async {
    List<CustomerModel> allCustomerList = [];
    // final prefs = await SharedPreferences.getInstance();
    // final String? uid = prefs.getString('userId');
    // print('UID: $uid');

    await FirebaseDatabase.instance.ref(await getUserID()).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = CustomerModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allCustomerList.add(data);
      }
    });
    return allCustomerList;
  }

  Future<List<CustomerModel>> getAllBuyer() async {
    List<CustomerModel> customerList = [];

    await FirebaseDatabase.instance.ref(await getUserID()).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = CustomerModel.fromJson(jsonDecode(jsonEncode(element.value)));
        if (data.type != "Supplier") {
          customerList.add(data);
        }
      }
    });
    return customerList;
  }

  Future<List<CustomerModel>> getAllSupplier() async {
    List<CustomerModel> supplierList = [];

    await FirebaseDatabase.instance.ref(await getUserID()).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = CustomerModel.fromJson(jsonDecode(jsonEncode(element.value)));
        if (data.type == "Supplier") {
          supplierList.add(data);
        }
      }
    });
    return supplierList;
  }
}
