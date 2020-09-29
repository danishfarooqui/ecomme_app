
import 'package:ecommeapp/screens/order_list_screen.dart';
import 'package:flutter/material.dart';

class SideDrawerNavigation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SideDrawerNavigationState();
  }

}

class _SideDrawerNavigationState extends State<SideDrawerNavigation>{
  @override
  Widget build(BuildContext context) {
   return Container(
     color: Colors.redAccent,
     child: Drawer(
       child: Container(
         color: Colors.redAccent,
         child: ListView(
             padding: EdgeInsets.zero,
           children: <Widget>[
             UserAccountsDrawerHeader(
               decoration: BoxDecoration(
                 color: Colors.redAccent
               ),
               accountName: Text('Danish Farooqui'),
             accountEmail: Text("danishfarooqui99@yahoo.com"),
             currentAccountPicture:  GestureDetector(
               child: CircleAvatar(
                 radius: 50,
                 child: Image.asset('asset/user.png'),
               ),
             ),),
             ListTile(
               title: Text('Home',style: TextStyle(color: Colors.white)),
               leading: Icon(Icons.home, color: Colors.white,),
             ),
             InkWell(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderListScreen()));
               },
               child: ListTile(
                 title: Text('Orders', style: TextStyle(color: Colors.white)),
                 leading: Icon(Icons.list, color: Colors.white,),
               ),
             )
           ],
         ),
       ),
     ),
   );
  }
  
}