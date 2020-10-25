

import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/screens/checkout_screen.dart';
import 'package:ecommeapp/screens/login_screen.dart';
import 'package:ecommeapp/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget{
  final List<Product> cartItems;

  CartScreen(this.cartItems);

  @override
  State<StatefulWidget> createState() {
    return _CartScreenState();
  }

}

class _CartScreenState extends State<CartScreen>{
  double _total;
  CartService _cartService = CartService();
  @override
  void initState() {
    super.initState();
    _getTotal();
  }

  _getTotal(){
    _total = 0.0;
    this.widget.cartItems.forEach((item) {
      setState(() {
        _total += item.price * item.quantity;
      });
    });
  }

  void _checkOut(List<Product> cartItems) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _userId = _prefs.getInt('userId');
    if(_userId!=null && _userId>0){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutScreen(cartItems: this.widget.cartItems,)));
    }
    else{
      Navigator.push(this.context, MaterialPageRoute(builder: (context)=>LoginScreen(cartItems:cartItems)));
    }
  }

  void _deleteCartItems(int index, int id) async{
    setState(() {
      this.widget.cartItems.removeAt(index);
    });
    var result = await _cartService.deleteItem(id);
    if(result>0){
      print('deleted'+index.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(''),
        title: Text('Cart Items'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
                icon: Icon(Icons.close),
              onPressed: (){
                  Navigator.pop(context);
              })
        ],
      ),

      body: ListView.builder(
        itemCount: this.widget.cartItems.length,
        itemBuilder: (context, index){
          return Dismissible(
            key: Key(this.widget.cartItems[index].name),
            onDismissed: (param){
              _deleteCartItems(index,this.widget.cartItems[index].id);
            },
            background: Container(
              color: Colors.redAccent,
            ) ,
            child: Card(
              child: ListTile(
                leading: Image.network(this.widget.cartItems[index].photo),
                title: Text(this.widget.cartItems[index].name),
                subtitle: Row(
                  children: <Widget>[
                    Text('₹${this.widget.cartItems[index].price}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    Text(' x ',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(' ${this.widget.cartItems[index].quantity}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(' = ',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    Text('₹ ${this.widget.cartItems[index].quantity * this.widget.cartItems[index].price} ',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),

                trailing: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        setState(() {
                          _total += this.widget.cartItems[index].price;
                          this.widget.cartItems[index].quantity++;
                        });
                      },
                      child: Icon(
                        Icons.add,
                        size: 18,
                      ),
                    ),
                    Text(' ${this.widget.cartItems[index].quantity}',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: (){
                        if(this.widget.cartItems[index].quantity>1){
                        setState(() {
                          _total -= this.widget.cartItems[index].price;
                          this.widget.cartItems[index].quantity--;
                        });
                        }
                      },
                      child: Icon(
                        Icons.remove,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(' Total: ₹ ${_total}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),)),
              Expanded(
                child: RaisedButton(
                  color: Colors.redAccent,
                  onPressed: (){
                    _checkOut(this.widget.cartItems);
                  },
                  child: Text('Checkout',style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }





}