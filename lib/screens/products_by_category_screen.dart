

import 'dart:convert';

import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/services/product_service.dart';
import 'package:ecommeapp/widgets/product_by_category.dart';
import 'package:flutter/material.dart';

class ProductsByCategoryScreen extends StatefulWidget{
  final String categoryName;
  final int categoryId;

  ProductsByCategoryScreen(this.categoryName, this.categoryId);

  @override
  State<StatefulWidget> createState() {
    return _ProductsByCategoryScreenState();
  }

}

class _ProductsByCategoryScreenState extends State<ProductsByCategoryScreen>{
  ProductService _productService = ProductService();

  List<Product> _productListByCategory = List<Product>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductsByCategory();
  }

  _getProductsByCategory() async{
    var products = await _productService.getProductByCategoryId(this.widget.categoryId);
    var _list = json.decode(products.body);
    _list['data'].forEach((data){
      var model = Product();
      model.id = data['id'];
      model.name = data['name'];
      model.photo = data['photo'];
      model.price = data['price'];
      model.discount = data['discount'];
      model.details = data['detail'];
      setState(() {
        _productListByCategory.add(model);
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _productListByCategory.length,
            itemBuilder: (context,index){
              return ProductByCategory(this._productListByCategory[index]);
            },
        ),
      ),
    );
  }

}