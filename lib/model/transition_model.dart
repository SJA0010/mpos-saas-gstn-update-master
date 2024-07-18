import 'package:salespro_admin/model/customer_model.dart';
import 'package:salespro_admin/model/product_model.dart';

import 'add_to_cart_model.dart';

class SaleTransactionModel {
  late String customerName, customerPhone, customerType, invoiceNumber, purchaseDate;
  double? totalAmount;
  double? dueAmount;
  double? returnAmount;
  double? serviceCharge;
  double? cgst;
  double? sgst;
  double? igst;
  double? discountAmount;
  double? lossProfit;
  int? totalQuantity;
  late CustomerModel customer;

  bool? isPaid;
  String? paymentType;
  List<AddToCartModel>? productList;
  String? sellerName;
  String? bankNEFT;

  SaleTransactionModel(
      {required this.customerName,
      required this.customerType,
      required this.customerPhone,
      required this.invoiceNumber,
      required this.purchaseDate,
      required this.customer,
      this.dueAmount,
      this.totalAmount,
      this.returnAmount,
      this.cgst,
      this.serviceCharge,
      this.discountAmount,
      this.isPaid,
      this.paymentType,
      this.productList,
      this.lossProfit,
      this.totalQuantity,
      this.sellerName,
      this.bankNEFT,
      this.sgst,
      this.igst});

  SaleTransactionModel.fromJson(Map<dynamic, dynamic> json) {
    customerName = json['customerName'] as String;
    customerPhone = json['customerPhone'].toString();
    invoiceNumber = json['invoiceNumber'].toString();
    customerType = json['customerType'].toString();
    purchaseDate = json['purchaseDate'].toString();
    customer = CustomerModel.fromJson(json['customer']);
    totalAmount = double.parse(json['totalAmount'].toString());
    discountAmount = double.parse(json['discountAmount'].toString());
    serviceCharge = double.parse(json['serviceCharge'].toString());
    cgst = double.parse(json['vat'].toString());
    sgst = double.parse(json['sgst'].toString());
    igst = double.parse(json['igst'].toString());
    lossProfit = double.parse(json['lossProfit'].toString());
    totalQuantity = json['totalQuantity'];
    dueAmount = double.parse(json['dueAmount'].toString());
    returnAmount = double.parse(json['returnAmount'].toString());
    isPaid = json['isPaid'];
    sellerName = json['sellerName'];
    paymentType = json['paymentType'].toString();
    bankNEFT = json['bankNEFT'];
    if (json['productList'] != null) {
      productList = <AddToCartModel>[];
      json['productList'].forEach((v) {
        productList!.add(AddToCartModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'customerName': customerName,
        'customer': customer.toJson(),
        'customerPhone': customerPhone,
        'customerType': customerType,
        'invoiceNumber': invoiceNumber,
        'purchaseDate': purchaseDate,
        'discountAmount': discountAmount,
        'vat': cgst,
        'sgst': sgst,
        'igst': igst,
        'serviceCharge': serviceCharge,
        'totalAmount': totalAmount,
        'dueAmount': dueAmount,
        'returnAmount': returnAmount,
        'lossProfit': lossProfit,
        'totalQuantity': totalQuantity,
        'sellerName': sellerName,
        'isPaid': isPaid,
        'paymentType': paymentType,
        'bankNEFT': bankNEFT,
        'productList': productList?.map((e) => e.toJson()).toList(),
      };
}

class PurchaseTransactionModel {
  late String customerName, customerPhone, customerType, invoiceNumber, purchaseDate;
  double? totalAmount;
  double? dueAmount;
  double? returnAmount;
  double? discountAmount;

  bool? isPaid;
  String? paymentType;
  List<ProductModel>? productList;
  String? sellerName;
  late CustomerModel customer;

  PurchaseTransactionModel({
    required this.customerName,
    required this.customerType,
    required this.customerPhone,
    required this.invoiceNumber,
    required this.purchaseDate,
    required this.customer,
    this.dueAmount,
    this.totalAmount,
    this.returnAmount,
    this.discountAmount,
    this.isPaid,
    this.paymentType,
    this.productList,
    this.sellerName,
  });

  PurchaseTransactionModel.fromJson(Map<dynamic, dynamic> json) {
    customerName = json['customerName'] as String;
    customerPhone = json['customerPhone'].toString();
    invoiceNumber = json['invoiceNumber'].toString();
    customerType = json['customerType'].toString();
    purchaseDate = json['purchaseDate'].toString();
    customer = CustomerModel.fromJson(json['customer']);
    totalAmount = double.parse(json['totalAmount'].toString());
    discountAmount = double.parse(json['discountAmount'].toString());
    dueAmount = double.parse(json['dueAmount'].toString());
    returnAmount = double.parse(json['returnAmount'].toString());
    sellerName = json['sellerName'].toString();
    isPaid = json['isPaid'];
    paymentType = json['paymentType'].toString();
    if (json['productList'] != null) {
      productList = <ProductModel>[];
      json['productList'].forEach((v) {
        productList!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'customerName': customerName,
        'customer': customer.toJson(),
        'customerPhone': customerPhone,
        'customerType': customerType,
        'invoiceNumber': invoiceNumber,
        'purchaseDate': purchaseDate,
        'discountAmount': discountAmount,
        'totalAmount': totalAmount,
        'dueAmount': dueAmount,
        'returnAmount': returnAmount,
        'sellerName': sellerName,
        'isPaid': isPaid,
        'paymentType': paymentType,
        'productList': productList?.map((e) => e.toJson()).toList(),
      };
}
