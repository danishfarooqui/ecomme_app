
import 'dart:convert';

import 'package:ecommeapp/models/product.dart';

class Payment{
  int id;
  String name;
  String email;
  String cardNumber;
  String expiryMonth;
  String expiryYear;
  String cvcNumber;
  int userId;
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
      'cartItems': json.encoder.convert(cartItems)
    };
  }
}