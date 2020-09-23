import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/screens/product_detail.dart';
import 'package:flutter/material.dart';

class HomeNewProduct extends StatefulWidget {
  final Product product;
  HomeNewProduct(this.product);
  @override
  _HomeNewProductState createState() => _HomeNewProductState();
}

class _HomeNewProductState extends State<HomeNewProduct> {

  withoutDiscount(price,discount){
    var val= price*discount;
    var total= val/100;
    return total+price;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190.0,
      height: 260.0,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(this.widget.product)));
        },
        child: Card(
          child: Column(
            children: <Widget>[
              Image.network(widget.product.photo, width: 190.0, height: 150.0,),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(this.widget.product.name,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
              ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(children: <Widget>[
                Text('₹ ${this.widget.product.price}  ',),
                Text('₹ ${withoutDiscount(this.widget.product.price, this.widget.product.discount)}',style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey),),
              ],mainAxisAlignment: MainAxisAlignment.center,),
            )

            ],
          ),
        ),
      ),
    );
  }
}