
import 'package:ecommeapp/screens/products_by_category_screen.dart';
import 'package:flutter/material.dart';

class HomeProductCategory extends StatefulWidget{
  final int categoryId;
  final String categoryIcon;
  final String categoryName;

  HomeProductCategory(this.categoryIcon, this.categoryName, this.categoryId);

  @override
  State<StatefulWidget> createState() {
    return _HomeProductCategory();
  }

}

class _HomeProductCategory extends State<HomeProductCategory>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
        height: 190,
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsByCategoryScreen(widget.categoryName,widget.categoryId)));
          },
          child: Card(
            child: Column(
              children: <Widget>[
                Image.network(widget.categoryIcon, width: 140, height: 160,),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.categoryName),
                )
              ],
            ),
          ),
        ),
    );
  }

}