

import 'package:flutter/material.dart';

class ThanksPage extends StatefulWidget {
  const ThanksPage({Key? key}) : super(key: key);

  @override
  _ThanksPageState createState() => _ThanksPageState();
}

class _ThanksPageState extends State<ThanksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('Payment Successfull')),),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100.0,
          ),
          SizedBox(height: 20,),
          Center(
            child: Text('Thank You', style: TextStyle(fontSize: 26),),
          ),
          Center(
            child: Text('Payment Successfull',style: TextStyle(fontSize: 26)),
          ),
          SizedBox(height: 20,),
          Image.network('https://staging.commbitz.com/qr/8943108161007627353.png',height: 200,width: 200,)
        ],
      ),
    );
  }
}
