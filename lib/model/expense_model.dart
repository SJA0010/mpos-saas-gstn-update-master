class ExpenseModel {
  late String expenseDate, category, expanseFor, paymentType, account, amount, referenceNo, note;

  ExpenseModel({
    required this.expenseDate,
    required this.category,
    required this.account,
    required this.amount,
    required this.expanseFor,
    required this.paymentType,
    required this.referenceNo,
    required this.note,
  });

  ExpenseModel.fromJson(Map<dynamic, dynamic> json) {
    expenseDate = json['expenseDate'].toString();
    category = json['category'].toString();
    account = json['account'].toString();
    amount = json['amount'].toString();
    expanseFor = json['expanseFor'].toString();
    paymentType = json['paymentType'].toString();
    referenceNo = json['referenceNo'].toString();
    note = json['note'].toString();
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'expenseDate': expenseDate,
        'category': category,
        'account': account,
        'amount': amount,
        'expanseFor': expanseFor,
        'paymentType': paymentType,
        'referenceNo': referenceNo,
        'note': note,
      };
}
