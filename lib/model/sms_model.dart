class SmsModel {
  SmsModel(
      {this.customerName,
      this.customerPhone,
      this.sellerId,
      this.sellerName,
      this.sellerMobile,
      this.invoiceNumber,
      this.totalAmount,
      this.dueAmount,
      this.paidAmount,
      this.status});

  SmsModel.fromJson(dynamic json) {
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    sellerId = json['sellerId'];
    sellerName = json['sellerName'];
    sellerMobile = json['sellerMobile'];
    invoiceNumber = json['invoiceNumber'];
    totalAmount = json['totalAmount'];
    dueAmount = json['dueAmount'];
    paidAmount = json['paidAmount'];
    status = json['status'];
  }
  String? customerName;
  String? customerPhone;
  String? sellerId;
  String? sellerName;
  String? sellerMobile;
  String? invoiceNumber;
  String? totalAmount;
  String? dueAmount;
  String? paidAmount;
  bool? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customerName'] = customerName;
    map['customerPhone'] = customerPhone;
    map['sellerId'] = sellerId;
    map['sellerName'] = sellerName;
    map['sellerMobile'] = sellerMobile;
    map['invoiceNumber'] = invoiceNumber;
    map['totalAmount'] = totalAmount;
    map['dueAmount'] = dueAmount;
    map['paidAmount'] = paidAmount;
    map['status'] = status;
    return map;
  }
}
