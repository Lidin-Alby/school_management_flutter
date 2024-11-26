import 'package:flutter/material.dart';

class MyText {
  String textName;
  double top = 0;
  double left = 0;
  double width = 100;
  double height = 25;
  double fontSize = 14;
  FontStyle fontStyle = FontStyle.normal;
  TextAlign texAlign = TextAlign.left;
  FontWeight fontWeight = FontWeight.normal;
  TextDecoration textDecoration = TextDecoration.none;
  TextEditingController textEditingController = TextEditingController();
  Color textcolor = Color(0xff000000);

  MyText(this.textName);
}
