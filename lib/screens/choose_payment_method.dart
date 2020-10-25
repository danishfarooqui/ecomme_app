
import 'dart:async';
import 'dart:convert';

import 'package:ecommeapp/models/Payment.dart';
import 'package:ecommeapp/models/order.dart';
import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/screens/payment_screen.dart';
import 'package:ecommeapp/services/cart_service.dart';
import 'package:ecommeapp/services/payment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class ChoosePaymentOption extends StatefulWidget{
  final List<Product> cartItems;
  ChoosePaymentOption({this.cartItems});

  @override
  State<StatefulWidget> createState() {
    return _ChoosePaymentOptionState();
  }

}

class _ChoosePaymentOptionState extends State<ChoosePaymentOption>{
  var _selectPaymentOption = 'Card';

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
      appBar: AppBar(
        title: Text('Checkout'),
        leading: Text(''),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:28,right:28 ,top:28 ,bottom: 15),
            child: Text("Choose payment option", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          Divider(height: 5,color: Colors.black54,),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 5,right: 15),
            child: Card(child: RadioListTile(title: Text('Credit/Debit Card'),value: 'Card',
            groupValue: _selectPaymentOption,
            onChanged: (param){
              setState(() {
                _selectPaymentOption = param;
              });
            },),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 5,right: 15),
            child: Card(child: RadioListTile(title: Text('Cash on delivery'),value: 'Cash on delivery',
              groupValue: _selectPaymentOption,
              onChanged: (param){
                setState(() {
                  _selectPaymentOption = param;
                });
              },),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25,top: 10,right: 25,bottom: 10),
            child: ButtonTheme(minWidth: 320,
            height: 45,
            child: FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                color: Colors.redAccent,
                onPressed: () async{
                if(_selectPaymentOption == 'Card'){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> PaymentScreen(
                       paymentType: _selectPaymentOption,
                      cartItems: this.widget.cartItems)));
                }
                else{
                  SharedPreferences _prefs = await SharedPreferences.getInstance();
                  var payment = Payment();
                  payment.userId = _prefs.getInt('userId');
                  payment.cartItems = this.widget.cartItems;
                  payment.order = Order();
                  payment.order.paymentType = _selectPaymentOption;
                  _makePayment(context, payment);
                }
                },
                child: Text('Continue',style: TextStyle(color: Colors.white),)),),
          )
        ],
      ),
    );
  }

}