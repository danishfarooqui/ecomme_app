

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roam_test/repository/payment_repository.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymenViewModel extends ChangeNotifier{

  // Map<String, dynamic>? paymentIntent;
  //
  // final _paymentRepository = PaymentRepository();
  //
  // Future<void> makePayment(BuildContext context) async {
  //   try {
  //     paymentIntent = await _paymentRepository.createPaymentIntent('100', 'INR');
  //
  //     //STEP 2: Initialize Payment Sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //             paymentIntentClientSecret: paymentIntent![
  //             'client_secret'], //Gotten from payment intent
  //             style: ThemeMode.dark,
  //             merchantDisplayName: 'Ikay'))
  //         .then((value) {});
  //
  //     //STEP 3: Display Payment sheet
  //     displayPaymentSheet(context);
  //   } catch (err) {
  //     throw Exception(err);
  //   }
  // }
  //
  // displayPaymentSheet(BuildContext context) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(
  //                   Icons.check_circle,
  //                   color: Colors.green,
  //                   size: 100.0,
  //                 ),
  //                 SizedBox(height: 10.0),
  //                 Text("Payment Successful!"),
  //               ],
  //             ),
  //           ));
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //     AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: const [
  //               Icon(
  //                 Icons.cancel,
  //                 color: Colors.red,
  //               ),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
  //
  // calculateAmount(String amount) {
  //   final calculatedAmout = (int.parse(amount)) * 100;
  //   return calculatedAmout.toString();
  // }

  Map<String, dynamic>? paymentIntentData;

  final _paymentRepository = PaymentRepository();

  Future<void> makePayment(amount) async {
    try {
      paymentIntentData =
      await _paymentRepository.createPaymentIntent(amount,'INR');
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
      notifyListeners();
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
    notifyListeners();
  }

  calculateAmount({amount}) {
    print(amount.round());
    final a = (int.parse(amount.toString())) * 100;
    print(a.toString());
    return a.toString();
  }

}