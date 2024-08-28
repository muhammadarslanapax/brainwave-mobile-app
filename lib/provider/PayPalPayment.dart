import 'dart:convert';

import 'package:aichat/provider/ProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

Future createPaymentIntent(
    {required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  final secretKey = Provider.of<ProfileProvider>(Get.context!, listen: false)
          .keysModel!
          .Stripe_SECRET_Key ??
      '';
  final body = {
    'amount': (int.parse(amount) * 100).toString(),
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test Donation",
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': country
  };

  final response = await http.post(url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body);

  print(body);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
    return json;
  } else {
    var json = jsonDecode(response.body);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text('Error: ${json['error']['message']}')),
    );
  }
  return null;
}
