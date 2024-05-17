import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shopeease/utils/Utils.dart';

Future createPaymentIntent(String amount) async {
  try {
    Map<String, dynamic> body = {
      "amount": amount,
      "currency": "USD",
    };
    String secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;

    http.Response response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded"
        });

    return json.decode(response.body);
  } catch (e) {
    Utils().showToastMessage(e.toString() + ":: createPaymentIntent", false);
  }
}
