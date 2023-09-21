import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:roam_test/routes/routes_config.dart';
import 'package:roam_test/routes/routes_name.dart';
import 'package:roam_test/view/sign_up_screen.dart';
import 'package:roam_test/view/splash_screen.dart';
import 'package:roam_test/view_model/BrandsViewModel.dart';
import 'package:roam_test/view_model/number_view_model.dart';
import 'package:roam_test/view_model/payment_view_model.dart';
import 'package:roam_test/view_model/plans_view_model.dart';
import 'package:roam_test/view_model/signup_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      'pk_test_51MbzR5L8FaMTewFCEZX3m5T5alL1HNq5u2nmZi3XrwEqFeqcYYKMkePhwY1wjpEsCzrOWpaSozP1nlet7LAzKnGM00tKkapCIM';

  await dotenv.load(fileName: 'assets/.env');
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PaymenViewModel()),
          ChangeNotifierProvider(create: (_) => SignUpViewModel()),
          ChangeNotifierProvider(create: (_) => BrandsViewModel()),
          ChangeNotifierProvider(create: (_) => PlansViewModel()),
          ChangeNotifierProvider(create: (_) => NumberViewModel())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        )
    );
  }
}
