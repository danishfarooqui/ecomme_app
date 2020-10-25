
import 'package:ecommeapp/screens/choose_payment_method.dart';
import 'package:ecommeapp/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: HomeScreen(),
   );
  }

}