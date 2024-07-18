class SubscriptionPlanModel {
  SubscriptionPlanModel({
    required this.subscriptionName,
    required this.saleNumber,
    required this.purchaseNumber,
    required this.partiesNumber,
    required this.dueNumber,
    required this.duration,
    required this.products,
    required this.subscriptionPrice,
    required this.offerPrice,
  });

  String subscriptionName;
  int saleNumber, purchaseNumber, partiesNumber, dueNumber, duration, products;
  int subscriptionPrice, offerPrice;

  SubscriptionPlanModel.fromJson(Map<dynamic, dynamic> json)
      : subscriptionName = json['subscriptionName'] as String,
        saleNumber = json['saleNumber'],
        purchaseNumber = json['purchaseNumber'],
        partiesNumber = json['partiesNumber'],
        subscriptionPrice = json['subscriptionPrice'],
        dueNumber = json['dueNumber'],
        duration = json['duration'],
        products = json['products'],
        offerPrice = json['offerPrice'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'subscriptionName': subscriptionName,
        'subscriptionPrice': subscriptionPrice,
        'saleNumber': saleNumber,
        'purchaseNumber': purchaseNumber,
        'partiesNumber': partiesNumber,
        'dueNumber': dueNumber,
        'duration': duration,
        'products': products,
        'offerPrice': offerPrice,
      };
}
