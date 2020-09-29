import 'dart:convert';

import 'package:ecommeapp/helpers/side_drawer_navigation.dart';
import 'package:ecommeapp/models/category.dart';
import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/screens/cart_screen.dart';
import 'package:ecommeapp/services/cart_service.dart';
import 'package:ecommeapp/services/category_service.dart';
import 'package:ecommeapp/services/product_service.dart';
import 'package:ecommeapp/services/slider_service.dart';
import 'package:ecommeapp/widgets/carousel_slider.dart';
import 'package:ecommeapp/widgets/home_hot_products.dart';
import 'package:ecommeapp/widgets/home_new_products.dart';
import 'package:ecommeapp/widgets/home_product_categories.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenSate();
  }
}

class _HomeScreenSate extends State<HomeScreen> {
  SliderService _sliderService = SliderService();
  CategoryService _categoryService = CategoryService();
  ProductService _productService = ProductService();

  List<Category> _categoryList = List<Category>();
  List<Product> _productList = List<Product>();
  List<Product> _newProductList = List<Product>();
  var items = [];

  CartService _cartService = CartService();
  List<Product> _cartItems;

  @override
  void initState() {
    super.initState();
    _getAllSliders();
    _getAllCategories();
    _getAllHotProducts();
    _getAllNewProducts();
    _getCartItems();
  }

  _getAllSliders() async{
    var sliders = await _sliderService.getSliders();
    var result = json.decode(sliders.body);
    result["data"].forEach((data){
      setState(() {
        items.add(NetworkImage(data["image_url"]));
      });
    });

  }

  _getAllCategories() async{
    var sliders = await _categoryService.getCategories();
    var result = json.decode(sliders.body);
    result["data"].forEach((data){
      var model = Category();
      model.id = data['id'];
      model.name = data['categoryName'];
      model.icon = data['categoryIcon'];
      setState(() {
        _categoryList.add(model);
      });
    });

  }

  _getAllHotProducts() async {
    var hotProducts = await _productService.getHotProducts();
    var result = json.decode(hotProducts.body);
    result["data"].forEach((data){
      var model = Product();
      model.id = data['id'];
      model.name = data['name'];
      model.photo = data['photo'];
      model.price = data['price'];
      model.discount = data['discount'];
      model.details = data['detail'];
      setState(() {
        _productList.add(model);
      });
    });
    print(result);
  }

  _getAllNewProducts() async{
    var newProducts = await _productService.getNewProducts();
    var result = json.decode(newProducts.body);
    result['data'].forEach((data){
      var model = Product();
      model.id = data['id'];
      model.name = data['name'];
      model.photo = data['photo'];
      model.price = data['price'];
      model.discount = data['discount'];
      model.details = data['detail'];
      setState(() {
        _newProductList.add(model);
      });
    });
  }

  _getCartItems() async {
    _cartItems = List<Product>();
    var cartItems = await _cartService.getCartItems();
    cartItems.forEach((data){
      var product = Product();
      product.id = data['productId'];
      product.name = data['productName'];
      product.photo = data['productPhoto'];
      product.price = data['productPrice'];
      product.discount = data['productDiscount'];
      product.details = data['productDetail'] ?? 'No detail';
      product.quantity = data['productQuantity'];

      setState(() {
        _cartItems.add(product);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawerNavigation(),
      appBar: AppBar(
        title: Text("Mobi Genius"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen(_cartItems)));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 150,
                width: 30,
                child: Stack(
                  children: <Widget>[
                    IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.shopping_cart,color: Colors.white,),
                      onPressed: (){
                      },
                    ),
                    Positioned(
                      child: Stack(
                        children: <Widget>[
                          Icon(Icons.brightness_1,size: 25,color: Colors.blueGrey,),
                          Positioned(
                            top: 4,
                            right: 8,
                            child: Center(child:Text(_cartItems.length.toString())),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],      ),
      body: Container(child: ListView(
        children: <Widget>[
          carouselSlider(items),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Product Categories',style: TextStyle(color: Colors.black,fontSize: 18),),
          ),
          HomeProductCategories(_categoryList),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Hot Products',style: TextStyle(color: Colors.black,fontSize: 18),),
          ),
          HomeHotProducts(productList: _productList,),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('New Arrival',style: TextStyle(color: Colors.black,fontSize: 18),),
          ),
          HomeNewProducts(productList: _newProductList,),
        ],
      ),color: Color.fromRGBO(240,240,240,1),)
    );
  }
}
