class SalesReport {
  late String customerName, purchasePrice, purchaseQuantity;

  SalesReport(this.customerName, this.purchasePrice, this.purchaseQuantity);

  SalesReport.fromJson(Map<dynamic, dynamic> json)
      : customerName = json['customerName'] as String,
        purchasePrice = json['purchasePrice'] as String,
        purchaseQuantity = json['purchaseQuantity'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'customerName': customerName,
        'purchasePrice': purchasePrice,
        'purchaseQuantity': purchaseQuantity,
      };
}
