
import 'package:ecommeapp/models/category.dart';
import 'package:flutter/material.dart';

import 'home_product_category.dart';

class HomeProductCategories extends StatefulWidget{
  final List<Category> categoryList;

  HomeProductCategories(this.categoryList);

  @override
  State<StatefulWidget> createState() {

    return _HomeProductCategoriesState();
  }

}

class _HomeProductCategoriesState extends State<HomeProductCategories>{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      child: ListView.builder(
      scrollDirection: Axis.horizontal,
        itemCount: this.widget.categoryList.length,
        itemBuilder: (context,index){
        return HomeProductCategory(this.widget.categoryList[index].icon, this.widget.categoryList[index].name, this.widget.categoryList[index].id);
        },
      ),
    );
  }
  
}