import 'package:flutter/material.dart';
import '../view_model/services/splash_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  SplashService splashService = SplashService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.checkAuthentication(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Image.asset('assets/logo.png'),
          ),
        )
    );
  }
}
