import 'package:ecommeapp/models/product.dart';
import 'package:flutter/material.dart';

import 'home_hot_product.dart';
import 'home_new_product.dart';

class HomeNewProducts extends StatefulWidget {
  final List<Product> productList;
  HomeNewProducts({this.productList});
  @override
  _HomeNewProductsState createState() => _HomeNewProductsState();
}

class _HomeNewProductsState extends State<HomeNewProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this.widget.productList.length,
        itemBuilder: (context, index){
          return
            HomeNewProduct(this.widget.productList[index]);
        },
      ),
    );
  }
}