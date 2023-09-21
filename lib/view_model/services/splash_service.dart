import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roam_test/routes/routes_name.dart';
import 'package:roam_test/view/brands_screen.dart';
import 'package:roam_test/view/home_screen.dart';
import 'package:roam_test/view/pop_up_screen.dart';
import 'package:roam_test/view/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:mvvm/model/user_model.dart';
// import 'package:mvvm/utils/routes/routes_name.dart';
// import 'package:mvvm/view_model/user_view_model.dart';

class SplashService {
  // void checkAuthentication(BuildContext context) async{
  //   await Future.delayed(Duration(seconds: 3));
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
  // }

  void checkAuthentication(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value = preferences.getString('token');
    String? phone = preferences.getString('phone');
    String? email = preferences.getString('email');

    if (value == '' || value == null) {
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushNamed(RoutesName.signup);

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => SignUpScreen(),
      //     ));
    } else {
      if (phone == '0' || email == '') {
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).pushNamed(RoutesName.popup);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => PopupScreen(),
        //     ));
      } else {
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).pushNamed(RoutesName.brand);
        // Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => BrandsScreen(),
        //     ));
      }
    }
  }
}
