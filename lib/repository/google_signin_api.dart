
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi{

  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> logout()=> _googleSignIn.signOut();

}

class FacebookSignInApi{
  static final _facebookSignIn = FacebookAuth.getInstance();

  static Future<LoginResult> login()=> _facebookSignIn.login(permissions: ["public_profile", "email"]);
  static Future logout()=> _facebookSignIn.logOut();
}

