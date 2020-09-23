import 'dart:convert';

import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/models/shipping.dart';
import 'package:ecommeapp/screens/payment_screen.dart';
import 'package:ecommeapp/services/shipping_address.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> cartItems;
  CheckoutScreen({this.cartItems});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _name = TextEditingController();

  final _email = TextEditingController();

  final _address = TextEditingController();

  void _addShipping(BuildContext context, Shipping shipping) async {
    var _shippingService = ShippingService();
    var _shipping = await _shippingService.addShipping(shipping);
    print(_shipping.body);
    var _result = json.decode(_shipping.body);

    if(_result['result'] == true){
     Navigator.push(context, MaterialPageRoute(builder: (context)=>  PaymentScreen(this.widget.cartItems)));
    }
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 28.0, right: 28.0, bottom: 14.0),
            child: Text('Shipping Address',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              controller: _name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              decoration: InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
            child: TextField(
              controller: _address,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Address',
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: ButtonTheme(
          minWidth: 320.0,
          height: 45.0,
          child: FlatButton(
            color: Colors.redAccent,
            onPressed: () {
              var model = Shipping();
              model.name = _name.text;
              model.email = _email.text;
              model.address = _address.text;
              _addShipping(context, model);
            },
            child: Text('Continue to payment', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
