

import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  final _tabs = <Tab>[
    const Tab(text: "Completed",),
    const Tab(text: "Failed",),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Order History'),
          bottom: TabBar(labelColor: Colors.orange,

            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: Colors.black38,
              child: Text('Tab1'),
            ),
            Container(
              color: Colors.black38,
              child: Text('Tab2'),
            ),
          ],
        )
      ),
    );
  }
}
