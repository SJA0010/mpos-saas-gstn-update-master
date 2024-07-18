class PersonalInformationModel {
  PersonalInformationModel({
    required this.phoneNumber,
    required this.companyName,
    required this.pictureUrl,
    required this.businessCategory,
    required this.language,
    required this.countryName,
    required this.saleInvoiceCounter,
    required this.purchaseInvoiceCounter,
    required this.dueInvoiceCounter,
    required this.shopOpeningBalance,
    required this.remainingShopBalance,
    required this.address,
    required this.city,
    required this.email,
    required this.gstNo,
    required this.state,
    required this.zip,
    required this.bankAccountNumber,
    required this.bankBranchName,
    required this.bankName,
    required this.ifscNumber,
    required this.tAndC,
  });

  PersonalInformationModel.fromJson(dynamic json) {
    phoneNumber = json['phoneNumber'];
    companyName = json['companyName'];
    pictureUrl = json['pictureUrl'];
    businessCategory = json['businessCategory'];
    language = json['language'];
    countryName = json['countryName'];
    saleInvoiceCounter = json['saleInvoiceCounter'];
    purchaseInvoiceCounter = json['purchaseInvoiceCounter'];
    dueInvoiceCounter = json['dueInvoiceCounter'];
    shopOpeningBalance = json['shopOpeningBalance'];
    remainingShopBalance = json['remainingShopBalance'];
    email = json['email'];
    gstNo = json['gstNo'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    bankAccountNumber = json['bankAccountNumber'];
    bankBranchName = json['bankBranchName'];
    bankName = json['bankName'];
    ifscNumber = json['ifscNumber'];
    tAndC = json['tAndC'];
  }
  late dynamic phoneNumber;
  late String companyName;
  late String pictureUrl;
  late String businessCategory;
  late String language;
  late String countryName;
  late int dueInvoiceCounter;
  late int saleInvoiceCounter;
  late int purchaseInvoiceCounter;
  late int shopOpeningBalance;
  late int remainingShopBalance;

  late String email;
  late String gstNo;
  late String address;
  late String city;
  late String state;
  late String zip;
  late String bankName;
  late String bankBranchName;
  late String bankAccountNumber;
  late String ifscNumber;
  late String tAndC;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['companyName'] = companyName;
    map['pictureUrl'] = pictureUrl;
    map['businessCategory'] = businessCategory;
    map['language'] = language;
    map['countryName'] = countryName;
    map['saleInvoiceCounter'] = saleInvoiceCounter;
    map['purchaseInvoiceCounter'] = purchaseInvoiceCounter;
    map['dueInvoiceCounter'] = dueInvoiceCounter;
    map['shopOpeningBalance'] = shopOpeningBalance;
    map['remainingShopBalance'] = remainingShopBalance;
    map['email'] = email;
    map['gstNo'] = gstNo;
    map['address'] = address;
    map['city'] = city;
    map['state'] = state;
    map['zip'] = zip;
    map['ifscNumber'] = ifscNumber;
    map['bankName'] = bankName;
    map['bankBranchName'] = bankBranchName;
    map['bankAccountNumber'] = bankAccountNumber;
    map['tAndC'] = tAndC;
    return map;
  }
}
