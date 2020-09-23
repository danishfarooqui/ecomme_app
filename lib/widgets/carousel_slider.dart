

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

Widget carouselSlider(items)=> SizedBox(
  height: 200,
  child: Carousel(
    boxFit: BoxFit.cover,
    images: items,
    animationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 300),
    dotBgColor: Colors.transparent,
  ),
);