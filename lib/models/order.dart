
import 'package:ecommeapp/models/product.dart';

class Order{

  int id;
  int quantity;
  double amount;
  int productId;
  String paymentType;
  Product product = Product();
}