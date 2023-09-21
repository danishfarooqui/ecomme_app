import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roam_test/routes/routes_name.dart';
import 'package:roam_test/view/brands_screen.dart';
import 'package:roam_test/view/order_history.dart';
import 'package:roam_test/view/plans_screen.dart';
import 'package:roam_test/view/pop_up_screen.dart';
import 'package:roam_test/view/sign_up_screen.dart';
import 'package:roam_test/view/splash_screen.dart';

class Routes {

  static Route<dynamic> generateRoute(RouteSettings settings){
return MaterialPageRoute(
  settings: settings,
    builder: ((context) {
  switch(settings.name){
    case RoutesName.splash:
      return SplashView();
    case RoutesName.popup:
      return PopupScreen();
    case RoutesName.signup:
      return SignUpScreen();
    case RoutesName.brand:
       return BrandsScreen();
    case RoutesName.plans:

      final args = settings.arguments as ScreenArguments;

      return
             PlansScreen(
              id: args.id,
            );

    case RoutesName.orderHistory:
      return OrderHistory();

    default:
      return  Scaffold(
          body: Center(
              child:Text('No route defined')
          ),
        );

  }
    }));

  }
}

class ScreenArguments{
  final String id;
  ScreenArguments(this.id);
}