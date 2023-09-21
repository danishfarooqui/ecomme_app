import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_test/repository/google_signin_api.dart';
import 'package:roam_test/routes/routes_name.dart';
import 'package:roam_test/view/order_history.dart';
import 'package:roam_test/view/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.black87
      ),
        accountName: Text('User Name'),
        accountEmail: Text('7014811509'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset('assets/logo.png'),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          leading: FaIcon(FontAwesomeIcons.signOut),
          title: Text('Order History'),
          onTap: ()async{
            SharedPreferences preferences =  await SharedPreferences.getInstance();
            await preferences.getString('token');
            await preferences.clear();
            GoogleSignInApi.logout();
            FacebookSignInApi.logout();
            Navigator.pushNamed(context, RoutesName.orderHistory);
          },
        ),
        Divider(thickness: 2,),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.signOut),
          title: Text('Logout'),
          onTap: ()async{
            SharedPreferences preferences =  await SharedPreferences.getInstance();
            await preferences.getString('token');
            await preferences.clear();
            GoogleSignInApi.logout();
            FacebookSignInApi.logout();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
          },
        ),
        Divider(thickness: 2,)
      ],
    );
    return Drawer(
      child: drawerItems,
    );
  }
}
