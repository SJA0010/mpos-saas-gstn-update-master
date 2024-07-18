import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:salespro_admin/model/create_paypal_order_model.dart';
import '../Screen/Widgets/Constant Data/constant.dart';
import '../constant.dart';
import '../currency.dart';

class PaypalRepo {
  String domain = sandbox ? "https://api.sandbox.paypal.com" : "https://api.paypal.com"; // for sandbox mode

  Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(paypalClientId, paypalClientSecret);
      var response = await client.post(Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["access_token"];
      }
      return 'Not Found';
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getPaymentUrl(String planName, String amount, String siteUrl) async {
    Map<String, dynamic> transaction = {
      "intent": "CAPTURE",
      "purchase_units": [
        {
          "items": [
            {
              "name": planName,
              "description": "Green XL",
              "quantity": "1",
              "unit_amount": {"currency_code": currency, "value": amount}
            }
          ],
          "amount": {
            "currency_code": currency,
            "value": amount,
            "breakdown": {
              "item_total": {"currency_code": currency, "value": amount}
            }
          }
        }
      ],
      "application_context": {"return_url": "${siteUrl}success/?userId=$constUserId&plan=$planName", "cancel_url": '$siteUrl/cancel'}
    };
    var token = await getAccessToken();
    var response =
        await http.post(Uri.parse('$domain/v2/checkout/orders'), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'}, body: jsonEncode(transaction));

    var data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      var decodedData = CreatePaypalOrderModel.fromJson(data);
      String url = decodedData.links![1].href.toString();
      return url;
    }
    return '$siteUrl/cancel';
  }
}
