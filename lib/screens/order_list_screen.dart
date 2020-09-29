
import 'package:flutter/material.dart';

class OrderListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _OrderListScreen();
  }
  
}

class _OrderListScreen extends State<OrderListScreen>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Order List'),
     ),
   );
  }
  
}