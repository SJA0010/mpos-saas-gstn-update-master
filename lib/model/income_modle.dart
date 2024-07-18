class IncomeModel {
  late String incomeDate, category, incomeFor, paymentType, account, amount, referenceNo, note;

  IncomeModel({
    required this.incomeDate,
    required this.category,
    required this.account,
    required this.amount,
    required this.incomeFor,
    required this.paymentType,
    required this.referenceNo,
    required this.note,
  });

  IncomeModel.fromJson(Map<dynamic, dynamic> json) {
    incomeDate = json['incomeDate'].toString();
    category = json['category'].toString();
    account = json['account'].toString();
    amount = json['amount'].toString();
    incomeFor = json['incomeFor'].toString();
    paymentType = json['paymentType'].toString();
    referenceNo = json['referenceNo'].toString();
    note = json['note'].toString();
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'incomeDate': incomeDate,
        'category': category,
        'account': account,
        'amount': amount,
        'incomeFor': incomeFor,
        'paymentType': paymentType,
        'referenceNo': referenceNo,
        'note': note,
      };
}
