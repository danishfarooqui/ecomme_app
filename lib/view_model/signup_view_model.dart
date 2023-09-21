import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:roam_test/repository/google_signin_api.dart';
import 'package:roam_test/repository/signup_repository.dart';
import 'package:roam_test/routes/routes_name.dart';
import 'package:roam_test/view/brands_screen.dart';
import 'package:roam_test/view/home_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:roam_test/view/pop_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpViewModel extends ChangeNotifier {


  final _signUpRepository = SignUpRepository();


  Future googlesignIn(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final user = await GoogleSignInApi.login();

    var userAuth = await user!.authentication;

    print(user.id);//id
    print(user.email);
    print(user.serverAuthCode);
    print(user.photoUrl);//picture
    print(user.displayName);
    Map<String,dynamic> _userObj = {};
    _userObj['"name"'] = '"'+user.displayName.toString()+'"';
    _userObj['"email"'] = '"'+user.email.toString()+'"';
    _userObj['"picture"'] = '"'+user.photoUrl.toString()+'"';
    _userObj['"oauth_uid"'] = '"'+user.id.toString()+'"';
    _userObj['"oauth_provider"'] = '"google"';
    String base64Token = generateBase64(_userObj.toString());
    String md5Token = generateMd5('name='+user.displayName.toString()+'&email='+user.email.toString()+'&picture='+user.photoUrl.toString()+'&oauth_uid='+user.id+'&oauth_provider=google');
    print("Base64: "+base64Token);
    print("Md5: "+md5Token);
    _signUpRepository.signInPostAuth(md5Token,base64Token).then((value) {
      preferences.setString('token', value['data'][0]['id']);
      preferences.setString('phone', value['data'][0]['phone']);
      preferences.setString('email', value['data'][0]['email']);
      print("Api response: "+value.toString());
      if(value['data'][0]['phone'] =='0' || value['data'][0]['email'] ==''){
        Navigator.of(context).pushNamed(RoutesName.popup);
      }
      else{
        Navigator.of(context).pushNamed(RoutesName.brand);
      }
    });
  }

  Future facebookSignIn(context) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, dynamic> _userObj = {};
    FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]).then((value) {
      FacebookAuth.instance.getUserData().then((value) {
        print('login successfull');
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => BrandsScreen()));

        _userObj = value;

        String base64body = generateBase64(mapObject(_userObj, 'facebook'));
        print(mapObject(_userObj, 'facebook'));
        String md5token = generateMd5(serializeData(_userObj,"facebook")).toString();
        print(serializeData(_userObj,"facebook"));
        //calling repositry method here and providing value
         _signUpRepository.signInPostAuth(md5token,base64body).then((value) {
         preferences.setString('token', value['data'][0]['id']);
         preferences.setString('phone', value['data'][0]['phone']);
         preferences.setString('email', value['data'][0]['email']);

         if(value['data'][0]['phone'] =='0' || value['data'][0]['email'] ==''){
           Navigator.of(context).pushNamed(RoutesName.popup);
         }
         else{
           Navigator.of(context).pushNamed(RoutesName.brand);
         }
       });

        notifyListeners();
      });
    });
  }
}


mapObject(Map<String, dynamic> data, String oAuthprovider){
  Map<String,dynamic> valueData = {};

  data.forEach((key, value) {
    if (key.toString()=='picture' ) {
      Map<String, dynamic> pic = data['picture']['data'];
      valueData['"'+key.toString()+'"'] =  '"'+pic['url'].toString()+'"';
      print(pic['url'].toString());
    }else if (key.toString()=='id' ){
      valueData['"oauth_uid"']= '"'+value.toString()+'"';
    }else{
      valueData['"'+key.toString()+'"'] = '"'+value.toString()+'"';
    }
  });
  valueData['"oauth_provider"'] = '"'+oAuthprovider+'"';
  print(valueData);

  return valueData.toString();
}

serializeData(Map data, String oAuthprovider)  {
  String valueData = '';

  data.forEach((key, value) {

    if (key.toString()=='picture' ) {
      Map<String, dynamic> pic = data['picture']['data'];
      valueData += key.toString() + '=' + pic['url'].toString() + '&';
      print(pic['url'].toString());
    }else if (key.toString()=='id' ){
      valueData += 'oauth_uid=' + value.toString() + '&';
    }else{
      valueData += key.toString() + '=' + value.toString() + '&';
    }

  });

  print(valueData+'oauth_provider='+oAuthprovider);
  return valueData+'oauth_provider='+oAuthprovider;
}




String generateMd5(String input){
  return md5.convert(utf8.encode(input)).toString();
}

String generateBase64(String input) {
  String mydata = input;
  String bs64 = base64.encode(mydata.codeUnits);
  print(bs64);
  return bs64;
}

//{oauth_provider: facebook, name: Danish Farooqui, email: danishfarooqui99@yahoo.com, picture: https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=6242159969245122&width=200&ext=1696424171&hash=AeRcIZhe42dOOYzzjYo, oauth_uid: 6242159969245122}
//

// 'https://staging.commbitz.com/api/login?token=' + md5
  //     data.forEach((element) {
  //   valueData += element.key.toString() + '=' + element.value.toString() + '&';
  //   if (data.containsKey('picture')) {
  //
  //     Map<String, dynamic> pic = data['picture']['data'];
  //     pic.forEach((key, value) {
  //       valueData += key.toString() + '=' + value.toString() + '&';
  //     });
  //   }
  // });

// data.forEach((key, value) {
//   valueData += key.toString()+'='+value.toString()+'&';
//   if(data.containsKey('picture')){
//     valueData += key.toString()+'='+value.toString()+'&';
//   }
//
// });

//  if(i == data.length -1){
//
// }
//
//  if(key == picture){
//   valueData += key.toString()+'='+value.data['data'].toString()+'&';
// }
