import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/screens/cart_screen.dart';
import 'package:ecommeapp/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class ProductDetail extends StatefulWidget {
  final Product product;

  ProductDetail(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartService _cartService = CartService();
  List<Product> _cartItems;

  @override
  void initState() {

    _getCartItems();
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

  _addToCart(BuildContext context, Product product) async {
    var result = await _cartService.addToCart(product);
    if(result > 0){
      _getCartItems();
      _showSnackMessage(Text('Item added to cart successfully!', style: TextStyle(color: Colors.green),));
    } else {
      _showSnackMessage(Text('Failed to add to cart!', style: TextStyle(color: Colors.red),));
    }
  }

  _showSnackMessage(message){
    var snackBar = SnackBar(
      content: message,
    );
   _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  withoutDiscount(price, discount) {
    var val = price * discount;
    var total = val / 100;
    return total + price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(this.widget.product.name),
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
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            child: GridTile(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Container(
                  child: Image.network(this.widget.product.photo),
                ),
              ),
              ),
            ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text(this.widget.product.name, style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              ),textAlign: TextAlign.left,),
             Padding(
               padding: const EdgeInsets.all(4.0),
               child: Row(
                 children: <Widget>[
               Text('₹ ${this.widget.product.price}  ',style: TextStyle(color: Colors.black,fontSize: 22, fontWeight: FontWeight.bold),),

            Text('₹ ${withoutDiscount(this.widget.product.price, this.widget.product.discount)}', style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough)),

                   Text('  ${ this.widget.product.discount}% off', style: TextStyle(
                       color: Colors.lightGreen,
                       fontSize: 18,
                       fontWeight: FontWeight.bold))]),
             ),]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    _addToCart(context, this.widget.product);
                  });

                },
                textColor: Colors.redAccent,
                child: Row(
                  children: <Widget>[
                    Text('Add to cart'),
                    IconButton(
                      onPressed: () {

                      },
                      icon: Icon(Icons.shopping_cart),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.redAccent,
                ),
              )
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: ListTile(
              title: Text(
                'Product Detail',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Html(data:this.widget.product.details.toString()),
            ),
          )
        ],
      ),
    );
  }
}
