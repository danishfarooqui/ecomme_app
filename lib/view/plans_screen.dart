import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:roam_test/view/thanks_page.dart';
import 'package:roam_test/view/widgets/navigation_drawer.dart';
import 'package:roam_test/view_model/plans_view_model.dart';
import 'package:http/http.dart' as http;

import '../model/plans_model.dart';
import '../routes/routes_config.dart';

class PlansScreen extends StatefulWidget {

  final id;

   PlansScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {

    final plansProvider = Provider.of<PlansViewModel>(context, listen: false);

    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Plans-United States"),

        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: [
                  // Color.fromRGBO(205, 193, 255, 1.0),
                  Color.fromRGBO(7, 4, 33, 1),
                  Color.fromRGBO(7, 4, 33, 1),
                ],
              ),
            ),
            child: SingleChildScrollView(

              child: Column(
                mainAxisSize: MainAxisSize.min,
                  children: [
                Container(
                  height: screenSize.height * 0.12,
                  width: screenSize.width,
                  child: Center(
                      child: Text(
                    'Select your country where you want to \nsetup your Budding plan',
                    style:
                        TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  )),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                ),
                SizedBox(height: 20,),
                FutureBuilder<List<PlansModel>>(
                  future: plansProvider.getPlans(widget.id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: plansProvider.plansData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top:20,left:20,right:20),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top:20,left: 20,right: 20),
                              child: Column(
                                children: [
                                  Text(snapshot.data![index].planName.toString(),
                                  style: TextStyle(color: Colors.white,fontSize: 18),),

                                  SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      Text("Data: "+snapshot.data![index].data.toString()+"GB",
                                        style: TextStyle(color: Colors.white,fontSize: 16),),
                                      Expanded(child: Container()),

                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text("Validity: "+snapshot.data![index].validity.toString()+" Days",
                                        style: TextStyle(color: Colors.white,fontSize: 16),),
                                      Expanded(child: Container()),
                                      Text("Price: "+snapshot.data![index].price.toString()+" INR",
                                        style: TextStyle(color: Colors.white,fontSize: 16),),

                                    ],
                                  ),

                                  SizedBox(height: 10,),
                                  ElevatedButton(
                                      onPressed: (){

                                        //print("path name:"+ModalRoute.of(context)!.settings.arguments.toString());
                                        makePayment('40','INR');
                                  },
                                      style: ButtonStyle(elevation: MaterialStateProperty.all(5),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                                        // If the button is pressed, return green, otherwise blue
                                        if (states.contains(MaterialState.pressed)) {
                                          return Colors.green;
                                        }
                                        return Colors.blue;
                                      }),),
                                      child: Text('Buy Now', style: TextStyle(color: Colors.white),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          );

                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text('${snapshot.error}',style: TextStyle(color: Colors.white),);
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ]),
            )
        ),
      drawer: NavigationDrawer(),
    );
  }

  Future<void> makePayment(amount,currency) async {

    try {
      paymentIntent =
      await createPaymentIntent(amount:amount,currency: currency);
      if (paymentIntent != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              // applePay: true,
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'INR'),
              merchantDisplayName: "PGA",
              //customerId: paymentIntent!['customer'],
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              //customerEphemeralKeySecret: paymentIntent!['ephemeralkey'],
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

        Navigator.push(context, MaterialPageRoute(builder: (_)=>ThanksPage()));


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

  createPaymentIntent({amount, currency }) async {

    Map<String, String> data = {'user_id':'83'};

    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': '{"user_id":"1","plan_id":"2"}',

      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
          'Bearer sk_test_51MbzR5L8FaMTewFC0FFUSH4tBqVoawbNw0RZwIoILbgwJ9ptA5tkknvyux5gjxJirSf5TTq8TxC2yvXq5aq650UR00R8z7F3Gh',
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
