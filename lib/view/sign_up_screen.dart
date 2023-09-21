import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roam_test/repository/google_signin_api.dart';
import 'package:roam_test/view/home_screen.dart';
import 'package:roam_test/view_model/signup_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    final _signUpViewModel = Provider.of<SignUpViewModel>(context);
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 200, 
                child: Image.asset('assets/logo.png'),
              ),
              SizedBox(height: 15,),
              Text('Login to continue',style: TextStyle(color: Colors.white,fontSize: 18),),
              SizedBox(height: 20,),
              SizedBox(height: 15,),
              ElevatedButton.icon(
                  onPressed: (){
                    _signUpViewModel.googlesignIn(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity,50)
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  label: Text('Sign In with Google')),
              SizedBox(height: 10,),
              ElevatedButton.icon(
                  onPressed: (){
                    _signUpViewModel.facebookSignIn(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(double.infinity,50)
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Colors.blue,
                  ),
                  label: Text('Sign In with Facebook')),
              SizedBox(height: 10,),
              // ElevatedButton.icon(
              //     onPressed: (){
              //
              //     },
              //     style: ElevatedButton.styleFrom(
              //         primary: Colors.white,
              //         onPrimary: Colors.black,
              //         minimumSize: Size(double.infinity,50)
              //     ),
              //     icon: FaIcon(
              //       FontAwesomeIcons.amazon,
              //       color: Colors.black87,
              //     ),
              //     label: Text('Sign In with Amazon')),
              SizedBox(height: 25,),
            ],
          ),
        ),
      ),
    );
  }



  // Future signIn() async{
  //   final user = await GoogleSignInApi.login();
  //
  //   if(user==null){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign In failed')));
  //   }
  //   else{
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen(user: user)));
  //   }
  // }
}
