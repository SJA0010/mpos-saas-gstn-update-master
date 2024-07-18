/// scope : "https://uri.paypal.com/services/invoicing https://uri.paypal.com/services/vault/payment-tokens/read https://uri.paypal.com/services/disputes/read-buyer https://uri.paypal.com/services/payments/realtimepayment https://uri.paypal.com/services/disputes/update-seller https://uri.paypal.com/services/payments/payment/authcapture openid https://uri.paypal.com/services/disputes/read-seller Braintree:Vault https://uri.paypal.com/services/payments/refund https://api.paypal.com/v1/vault/credit-card https://api.paypal.com/v1/payments/.* https://uri.paypal.com/payments/payouts https://uri.paypal.com/services/vault/payment-tokens/readwrite https://api.paypal.com/v1/vault/credit-card/.* https://uri.paypal.com/services/shipping/trackers/readwrite https://uri.paypal.com/services/subscriptions https://uri.paypal.com/services/applications/webhooks"
/// access_token : "A21AAIqTb09hv7Csd2-Mv_4bDCGEnuMnW4t0QBRTAZv7e3Aq3NgQHs4nH4YFiM24Nyza3FkMM3Ihejul6Ao3ngm6Kh7K8ujYA"
/// token_type : "Bearer"
/// app_id : "APP-80W284485P519543T"
/// expires_in : 32116
/// nonce : "2022-10-13T10:51:23Zm-GDx1hI1Hw9KAJ2vCZyJbxF4uarHV_yrkCjJd81ft4"

class GeneratePaypalAccessModel {
  GeneratePaypalAccessModel({
    String? scope,
    String? accessToken,
    String? tokenType,
    String? appId,
    int? expiresIn,
    String? nonce,
  }) {
    _scope = scope;
    _accessToken = accessToken;
    _tokenType = tokenType;
    _appId = appId;
    _expiresIn = expiresIn;
    _nonce = nonce;
  }

  GeneratePaypalAccessModel.fromJson(dynamic json) {
    _scope = json['scope'];
    _accessToken = json['access_token'];
    _tokenType = json['token_type'];
    _appId = json['app_id'];
    _expiresIn = json['expires_in'];
    _nonce = json['nonce'];
  }
  String? _scope;
  String? _accessToken;
  String? _tokenType;
  String? _appId;
  int? _expiresIn;
  String? _nonce;

  String? get scope => _scope;
  String? get accessToken => _accessToken;
  String? get tokenType => _tokenType;
  String? get appId => _appId;
  int? get expiresIn => _expiresIn;
  String? get nonce => _nonce;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['scope'] = _scope;
    map['access_token'] = _accessToken;
    map['token_type'] = _tokenType;
    map['app_id'] = _appId;
    map['expires_in'] = _expiresIn;
    map['nonce'] = _nonce;
    return map;
  }
}
