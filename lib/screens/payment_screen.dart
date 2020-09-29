import 'dart:async';
import 'dart:convert';

import 'package:ecommeapp/models/Payment.dart';
import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/screens/home_screen.dart';
import 'package:ecommeapp/services/cart_service.dart';
import 'package:ecommeapp/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final List<Product> cartItems;

  PaymentScreen(this.cartItems);

  @override
  State<StatefulWidget> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _cardHolderName = TextEditingController();
  final _cardHolderEmail = TextEditingController();
  final _cardNumber = TextEditingController();
  final _expiryMonth = TextEditingController();
  final _expiryYear = TextEditingController();
  final _cvcNumber = TextEditingController();

  _showSnackBarMessage(message) {
    var snackBar = SnackBar(content: message);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _makePayment(BuildContext context, Payment payment) async{
    PaymentService _paymentService = PaymentService();
    var paymentData = await _paymentService.makePayment(payment);
    var result = json.decode(paymentData.body);
    print(result);
    if(result['result'] == true){
      CartService _cartService = CartService();
      this.widget.cartItems.forEach((cartItem) {
        _cartService.deleteItem(cartItem);
      });
        _showPaymentSuccessMessage(context);
        Timer(Duration(seconds: 2),(){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
        });
    }
  }

   _showPaymentSuccessMessage(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
          content: Container(
            height: 360,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/success.png'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Order and Payment is successfully done!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 28.0, right: 28.0, bottom: 14.0),
            child: Text('Enter card details',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              controller: _cardHolderName,
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _cardHolderEmail,
              decoration: InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              controller: _cardNumber,
              decoration: InputDecoration(
                hintText: 'Enter card number',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              controller: _expiryMonth,
              decoration: InputDecoration(
                hintText: 'Expiry month',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              controller: _expiryYear,
              decoration: InputDecoration(
                hintText: 'Expiry year',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              controller: _cvcNumber,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'CVC number',
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: ButtonTheme(
          minWidth: 320,
          height: 40,
          child: FlatButton(
              color: Colors.redAccent,
              onPressed: () async{
                SharedPreferences _prefs = await SharedPreferences.getInstance();
                var payment = Payment();
                payment.userId = _prefs.getInt('userId');
                payment.name = _cardHolderName.text;
                payment.email = _cardHolderEmail.text;
                payment.cardNumber = _cardNumber.text;
                payment.expiryMonth = _expiryMonth.text;
                payment.expiryYear = _expiryYear.text;
                payment.cvcNumber = _cvcNumber.text;
                payment.cartItems = this.widget.cartItems;
                print(payment.toJson());
                _makePayment(context,payment);
              },
              child: Text(
                'Make Payments',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }


}
