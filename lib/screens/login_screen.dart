

import 'dart:convert';

import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/models/user.dart';
import 'package:ecommeapp/screens/checkout_screen.dart';
import 'package:ecommeapp/screens/home_screen.dart';
import 'package:ecommeapp/screens/registeration_screen.dart';
import 'package:ecommeapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget{
  final List<Product> cartItems;

  LoginScreen({this.cartItems});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LoginScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final email = TextEditingController();
  final password = TextEditingController();


  @override
  void initState() {
    super.initState();
    _setSharedPrefs();
  }

  _setSharedPrefs() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('userId', 0);
    _prefs.setString('userName', '');
    _prefs.setString('userEmail', '');
  }

  _login(BuildContext context,User user) async{
    var userService = UserService();
    var registeredUser = await userService.login(user);
    var result = json.decode(registeredUser.body);
    if(result['result']==true){
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setInt('userId', result['user']['id']);
      _prefs.setString('username', result['user']['name']);
      _prefs.setString('userEmail', result['user']['email']);

      if(this.widget.cartItems !=null && this.widget.cartItems.length > 0){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutScreen(cartItems: this.widget.cartItems,)));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }

    }
    else{
      _showSnackMessage(Text('Filed to login!'));
    }
  }

  _showSnackMessage(message) {
    var snackBar = SnackBar(
      content: message,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
              color: Colors.red,),
              onPressed: (){
                Navigator.pop(context);
              }
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(top:120.0),
        child: ListView(
          children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 48,top: 14,right: 48,bottom: 14),
                child: TextField(
                  controller:   email,
                  decoration: InputDecoration(
                    hintText: 'youremail@example.com',labelText: 'Enter your email'
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 48,top: 14,right: 48,bottom: 14),
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Enter your password',labelText: '******'
                ),
              ),
            ),
            Column(
              children: <Widget>[
                ButtonTheme(
                  minWidth: 320,
                  height: 45,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.redAccent,
                    onPressed: (){
                      var user = User();
                      user.email = email.text;
                      user.password = password.text;
                      _login(context,user);
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterationScreen(this.widget.cartItems)));
                  },
                  child: FittedBox(child: Text('Register your account'),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}