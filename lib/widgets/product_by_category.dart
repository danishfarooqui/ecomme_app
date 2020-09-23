

import 'package:ecommeapp/models/product.dart';
import 'package:ecommeapp/screens/product_detail.dart';
import 'package:flutter/material.dart';

class ProductByCategory extends StatefulWidget{
  final Product product;

  ProductByCategory(this.product);

  @override
  State<StatefulWidget> createState() {

    return _ProductByCategoryState();
  }

}

class _ProductByCategoryState extends State<ProductByCategory>{

  withoutDiscount(price,discount){
    var val= price*discount;
    var total= val/100;
    return total+price;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 190,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(this.widget.product)));
        },
        child: Card(
          child: Column(
            children: <Widget>[
              Image.network(widget.product.photo, width: 190,height: 130,),
              Text(this.widget.product.name,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(children: <Widget>[
                  Text('₹  ${widget.product.price}  '),
                  Text('₹ ${withoutDiscount(widget.product.price, widget.product.discount) }',style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey),),
                ],mainAxisAlignment: MainAxisAlignment.center,),
              )
            ],
          ),
        ),
      ),
    );

  }

}