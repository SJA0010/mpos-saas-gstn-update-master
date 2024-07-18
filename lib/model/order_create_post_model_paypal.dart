/// intent : "CAPTURE"
/// purchase_units : [{"items":[{"name":"T-Shirt","description":"Green XL","quantity":"1","unit_amount":{"currency_code":"USD","value":"100.00"}}],"amount":{"currency_code":"USD","value":"100.00","breakdown":{"item_total":{"currency_code":"USD","value":"100.00"}}}}]
/// application_context : {"return_url":"https://example.com/return","cancel_url":"https://example.com/cancel"}

class OrderCreatePostModelPaypal {
  OrderCreatePostModelPaypal({
    String? intent,
    List<PurchaseUnits>? purchaseUnits,
    ApplicationContext? applicationContext,
  }) {
    _intent = intent;
    _purchaseUnits = purchaseUnits;
    _applicationContext = applicationContext;
  }

  OrderCreatePostModelPaypal.fromJson(dynamic json) {
    _intent = json['intent'];
    if (json['purchase_units'] != null) {
      _purchaseUnits = [];
      json['purchase_units'].forEach((v) {
        _purchaseUnits?.add(PurchaseUnits.fromJson(v));
      });
    }
    _applicationContext = json['application_context'] != null ? ApplicationContext.fromJson(json['applicationContext']) : null;
  }
  String? _intent;
  List<PurchaseUnits>? _purchaseUnits;
  ApplicationContext? _applicationContext;

  String? get intent => _intent;
  List<PurchaseUnits>? get purchaseUnits => _purchaseUnits;
  ApplicationContext? get applicationContext => _applicationContext;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['intent'] = _intent;
    if (_purchaseUnits != null) {
      map['purchase_units'] = _purchaseUnits?.map((v) => v.toJson()).toList();
    }
    if (_applicationContext != null) {
      map['application_context'] = _applicationContext?.toJson();
    }
    return map;
  }
}

/// return_url : "https://example.com/return"
/// cancel_url : "https://example.com/cancel"

class ApplicationContext {
  ApplicationContext({
    String? returnUrl,
    String? cancelUrl,
  }) {
    _returnUrl = returnUrl;
    _cancelUrl = cancelUrl;
  }

  ApplicationContext.fromJson(dynamic json) {
    _returnUrl = json['return_url'];
    _cancelUrl = json['cancel_url'];
  }
  String? _returnUrl;
  String? _cancelUrl;

  String? get returnUrl => _returnUrl;
  String? get cancelUrl => _cancelUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['return_url'] = _returnUrl;
    map['cancel_url'] = _cancelUrl;
    return map;
  }
}

/// items : [{"name":"T-Shirt","description":"Green XL","quantity":"1","unit_amount":{"currency_code":"USD","value":"100.00"}}]
/// amount : {"currency_code":"USD","value":"100.00","breakdown":{"item_total":{"currency_code":"USD","value":"100.00"}}}

class PurchaseUnits {
  PurchaseUnits({
    List<Items>? items,
    Amount? amount,
  }) {
    _items = items;
    _amount = amount;
  }

  PurchaseUnits.fromJson(dynamic json) {
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
  }
  List<Items>? _items;
  Amount? _amount;

  List<Items>? get items => _items;
  Amount? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    if (_amount != null) {
      map['amount'] = _amount?.toJson();
    }
    return map;
  }
}

/// currency_code : "USD"
/// value : "100.00"
/// breakdown : {"item_total":{"currency_code":"USD","value":"100.00"}}

class Amount {
  Amount({
    String? currencyCode,
    String? value,
    Breakdown? breakdown,
  }) {
    _currencyCode = currencyCode;
    _value = value;
    _breakdown = breakdown;
  }

  Amount.fromJson(dynamic json) {
    _currencyCode = json['currency_code'];
    _value = json['value'];
    _breakdown = json['breakdown'] != null ? Breakdown.fromJson(json['breakdown']) : null;
  }
  String? _currencyCode;
  String? _value;
  Breakdown? _breakdown;

  String? get currencyCode => _currencyCode;
  String? get value => _value;
  Breakdown? get breakdown => _breakdown;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency_code'] = _currencyCode;
    map['value'] = _value;
    if (_breakdown != null) {
      map['breakdown'] = _breakdown?.toJson();
    }
    return map;
  }
}

/// item_total : {"currency_code":"USD","value":"100.00"}

class Breakdown {
  Breakdown({
    ItemTotal? itemTotal,
  }) {
    _itemTotal = itemTotal;
  }

  Breakdown.fromJson(dynamic json) {
    _itemTotal = json['item_total'] != null ? ItemTotal.fromJson(json['itemTotal']) : null;
  }
  ItemTotal? _itemTotal;

  ItemTotal? get itemTotal => _itemTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_itemTotal != null) {
      map['item_total'] = _itemTotal?.toJson();
    }
    return map;
  }
}

/// currency_code : "USD"
/// value : "100.00"

class ItemTotal {
  ItemTotal({
    String? currencyCode,
    String? value,
  }) {
    _currencyCode = currencyCode;
    _value = value;
  }

  ItemTotal.fromJson(dynamic json) {
    _currencyCode = json['currency_code'];
    _value = json['value'];
  }
  String? _currencyCode;
  String? _value;

  String? get currencyCode => _currencyCode;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency_code'] = _currencyCode;
    map['value'] = _value;
    return map;
  }
}

/// name : "T-Shirt"
/// description : "Green XL"
/// quantity : "1"
/// unit_amount : {"currency_code":"USD","value":"100.00"}

class Items {
  Items({
    String? name,
    String? description,
    String? quantity,
    UnitAmount? unitAmount,
  }) {
    _name = name;
    _description = description;
    _quantity = quantity;
    _unitAmount = unitAmount;
  }

  Items.fromJson(dynamic json) {
    _name = json['name'];
    _description = json['description'];
    _quantity = json['quantity'];
    _unitAmount = json['unit_amount'] != null ? UnitAmount.fromJson(json['unitAmount']) : null;
  }
  String? _name;
  String? _description;
  String? _quantity;
  UnitAmount? _unitAmount;

  String? get name => _name;
  String? get description => _description;
  String? get quantity => _quantity;
  UnitAmount? get unitAmount => _unitAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['description'] = _description;
    map['quantity'] = _quantity;
    if (_unitAmount != null) {
      map['unit_amount'] = _unitAmount?.toJson();
    }
    return map;
  }
}

/// currency_code : "USD"
/// value : "100.00"

class UnitAmount {
  UnitAmount({
    String? currencyCode,
    String? value,
  }) {
    _currencyCode = currencyCode;
    _value = value;
  }

  UnitAmount.fromJson(dynamic json) {
    _currencyCode = json['currency_code'];
    _value = json['value'];
  }
  String? _currencyCode;
  String? _value;

  String? get currencyCode => _currencyCode;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency_code'] = _currencyCode;
    map['value'] = _value;
    return map;
  }
}
