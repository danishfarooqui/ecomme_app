import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentRepository{

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(amount) async {
    try {
      paymentIntentData =
      await createPaymentIntent(amount,'INR');
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              // applePay: true,
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'INR'),
              merchantDisplayName: "PGA",
              customerId: paymentIntentData!['customer'],
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralkey'],
            ));
      }

      displayPaymentSheet();

    } catch (err) {
      print(err);
    }
  }


  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print('payment successfull');
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }

  }

  createPaymentIntent(String amount, String currency)async{

    try {
      Map<String, dynamic> body = {
        'amount': "amount",
        'currency': currency
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer sk_test_51NlYIWSB5GMnNIdOxd1zvrKnc6tLNKDolYTBMPkzKuS3sfvJPkEo29ftrx6sBozuaSAQwCLoSYpLDui5PhPoD4ma00Ie5OgkSj',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body
      );
      return json.decode(response.body);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  calculateAmount({amount}) {
    print(amount.round());
    final a = (int.parse(amount.toString())) * 100;
    print(a.toString());
    return a.toString();
  }


}