/// id : "4BD41253H8746053T"
/// intent : "CAPTURE"
/// status : "CREATED"
/// purchase_units : [{"reference_id":"default","amount":{"currency_code":"USD","value":"100.00","breakdown":{"item_total":{"currency_code":"USD","value":"100.00"}}},"payee":{"email_address":"sb-4rfqc20911789@business.example.com","merchant_id":"B9XUMEYE56MYA"},"items":[{"name":"T-Shirt","unit_amount":{"currency_code":"USD","value":"100.00"},"quantity":"1","description":"Green XL"}]}]
/// create_time : "2022-10-13T10:58:56Z"
/// links : [{"href":"https://api.sandbox.paypal.com/v2/checkout/orders/4BD41253H8746053T","rel":"self","method":"GET"},{"href":"https://www.sandbox.paypal.com/checkoutnow?token=4BD41253H8746053T","rel":"approve","method":"GET"},{"href":"https://api.sandbox.paypal.com/v2/checkout/orders/4BD41253H8746053T","rel":"update","method":"PATCH"},{"href":"https://api.sandbox.paypal.com/v2/checkout/orders/4BD41253H8746053T/capture","rel":"capture","method":"POST"}]

class CreatePaypalOrderModel {
  CreatePaypalOrderModel({
    String? id,
    String? intent,
    String? status,
    List<PurchaseUnits>? purchaseUnits,
    String? createTime,
    List<Links>? links,
  }) {
    _id = id;
    _intent = intent;
    _status = status;
    _purchaseUnits = purchaseUnits;
    _createTime = createTime;
    _links = links;
  }

  CreatePaypalOrderModel.fromJson(dynamic json) {
    _id = json['id'];
    _intent = json['intent'];
    _status = json['status'];
    if (json['purchase_units'] != null) {
      _purchaseUnits = [];
      json['purchase_units'].forEach((v) {
        _purchaseUnits?.add(PurchaseUnits.fromJson(v));
      });
    }
    _createTime = json['create_time'];
    if (json['links'] != null) {
      _links = [];
      json['links'].forEach((v) {
        _links?.add(Links.fromJson(v));
      });
    }
  }
  String? _id;
  String? _intent;
  String? _status;
  List<PurchaseUnits>? _purchaseUnits;
  String? _createTime;
  List<Links>? _links;

  String? get id => _id;
  String? get intent => _intent;
  String? get status => _status;
  List<PurchaseUnits>? get purchaseUnits => _purchaseUnits;
  String? get createTime => _createTime;
  List<Links>? get links => _links;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['intent'] = _intent;
    map['status'] = _status;
    if (_purchaseUnits != null) {
      map['purchase_units'] = _purchaseUnits?.map((v) => v.toJson()).toList();
    }
    map['create_time'] = _createTime;
    if (_links != null) {
      map['links'] = _links?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// href : "https://api.sandbox.paypal.com/v2/checkout/orders/4BD41253H8746053T"
/// rel : "self"
/// method : "GET"

class Links {
  Links({
    String? href,
    String? rel,
    String? method,
  }) {
    _href = href;
    _rel = rel;
    _method = method;
  }

  Links.fromJson(dynamic json) {
    _href = json['href'];
    _rel = json['rel'];
    _method = json['method'];
  }
  String? _href;
  String? _rel;
  String? _method;

  String? get href => _href;
  String? get rel => _rel;
  String? get method => _method;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['href'] = _href;
    map['rel'] = _rel;
    map['method'] = _method;
    return map;
  }
}

/// reference_id : "default"
/// amount : {"currency_code":"USD","value":"100.00","breakdown":{"item_total":{"currency_code":"USD","value":"100.00"}}}
/// payee : {"email_address":"sb-4rfqc20911789@business.example.com","merchant_id":"B9XUMEYE56MYA"}
/// items : [{"name":"T-Shirt","unit_amount":{"currency_code":"USD","value":"100.00"},"quantity":"1","description":"Green XL"}]

class PurchaseUnits {
  PurchaseUnits({
    String? referenceId,
    Amount? amount,
    Payee? payee,
    List<Items>? items,
  }) {
    _referenceId = referenceId;
    _amount = amount;
    _payee = payee;
    _items = items;
  }

  PurchaseUnits.fromJson(dynamic json) {
    _referenceId = json['reference_id'];
    _amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    _payee = json['payee'] != null ? Payee.fromJson(json['payee']) : null;
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  String? _referenceId;
  Amount? _amount;
  Payee? _payee;
  List<Items>? _items;

  String? get referenceId => _referenceId;
  Amount? get amount => _amount;
  Payee? get payee => _payee;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reference_id'] = _referenceId;
    if (_amount != null) {
      map['amount'] = _amount?.toJson();
    }
    if (_payee != null) {
      map['payee'] = _payee?.toJson();
    }
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// name : "T-Shirt"
/// unit_amount : {"currency_code":"USD","value":"100.00"}
/// quantity : "1"
/// description : "Green XL"

class Items {
  Items({
    String? name,
    UnitAmount? unitAmount,
    String? quantity,
    String? description,
  }) {
    _name = name;
    _unitAmount = unitAmount;
    _quantity = quantity;
    _description = description;
  }

  Items.fromJson(dynamic json) {
    _name = json['name'];
    _unitAmount = json['unit_amount'] != null ? UnitAmount.fromJson(json['unitAmount']) : null;
    _quantity = json['quantity'];
    _description = json['description'];
  }
  String? _name;
  UnitAmount? _unitAmount;
  String? _quantity;
  String? _description;

  String? get name => _name;
  UnitAmount? get unitAmount => _unitAmount;
  String? get quantity => _quantity;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    if (_unitAmount != null) {
      map['unit_amount'] = _unitAmount?.toJson();
    }
    map['quantity'] = _quantity;
    map['description'] = _description;
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

/// email_address : "sb-4rfqc20911789@business.example.com"
/// merchant_id : "B9XUMEYE56MYA"

class Payee {
  Payee({
    String? emailAddress,
    String? merchantId,
  }) {
    _emailAddress = emailAddress;
    _merchantId = merchantId;
  }

  Payee.fromJson(dynamic json) {
    _emailAddress = json['email_address'];
    _merchantId = json['merchant_id'];
  }
  String? _emailAddress;
  String? _merchantId;

  String? get emailAddress => _emailAddress;
  String? get merchantId => _merchantId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email_address'] = _emailAddress;
    map['merchant_id'] = _merchantId;
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
