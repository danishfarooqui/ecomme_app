
import 'dart:convert';

import 'package:ecommeapp/models/product.dart';

import 'order.dart';

class Payment{
  int id;
  String name;
  String email;
  String cardNumber;
  String expiryMonth;
  String expiryYear;
  String cvcNumber;
  int userId;
  Order order;
  List<Product> cartItems;

  toJson(){
    return{
      'id' : id.toString(),
      'userId': userId.toString(),
      'name' : name,
      'email' : email,
      'cardNumber' : cardNumber,
      'expiryMonth': expiryMonth,
      'expiryYear' : expiryYear,
      'cvcNumber' : cvcNumber,
      'order': json.encoder.convert({
        'paymentType': order.paymentType.toString()
      }),
      'cartItems': json.encoder.convert(cartItems)
    };
  }
}