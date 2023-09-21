import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:roam_test/repository/payment_repository.dart';
import 'package:roam_test/view/thanks_page.dart';
import 'package:roam_test/view_model/payment_view_model.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntent;
  final paymentRepo = PaymentRepository();

  @override
  Widget build(BuildContext context) {
    // final payProvider = Provider.of<PaymenViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Plans')),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.orange,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Turkey_1GB_7D'),
                    Row(
                      children: [
                        Text('Data'),
                        Expanded(child: Container(),),
                        Text('1GB')
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(height: 2, width: MediaQuery
                        .of(context)
                        .size
                        .width, color: Colors.white,),
                    SizedBox(height: 5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Calls'),
                        Expanded(child: Container(),),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(height: 2, width: MediaQuery
                        .of(context)
                        .size
                        .width, color: Colors.white,),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('Validity'),
                        Expanded(child: Container(),),
                        Text('30 Days')
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text('USD 19.99',
                      style: TextStyle(color: Colors.white, fontSize: 20),),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: () async{
                     makePayment("60");
                     print('sjdnskdksfkf');
                    },
                        child: Text('Buy Now',
                          style: TextStyle(color: Colors.white, fontSize: 20),))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


Future<void> makePayment(amount) async {
    try {
      paymentIntent =
      await createPaymentIntent(amount:amount,currency: 'INR');
      if (paymentIntent != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              // applePay: true,
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'INR'),
              merchantDisplayName: "PGA",
              customerId: paymentIntent!['customer'],
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              customerEphemeralKeySecret: paymentIntent!['ephemeralkey'],
            ));
      }

      await displayPaymentSheet();

    } catch (err) {
      print("Errorrrrrrrr1: " + err.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  content: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));


        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Errorrrrrrrrrr: ' + error.toString());
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
      print('Errorrrrrrrrr: ' + e.toString());
    }
  }

  createPaymentIntent({amount, currency}) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
          'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        print(decode);

        return decode;
      }
    } catch (e) {
      print(e);
    }

  }
  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

}