import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 Color blueBackgroundColor = _colorFromHex("#42b9dd");Color greenBackgroundColor = _colorFromHex("#74c44c");
const Color loginIconsColor = Colors.white;
const Color white = Colors.white;
const Color cyan = Colors.cyan;
const Color red = Colors.red;
const Color redAccent = Colors.redAccent;
const Color pink = Colors.pink;
 Color lightpink = Colors.pink[300];
 Color darkpink = Colors.pink[800];
const Color deepOrange = Colors.deepOrange;
const Color green = Colors.green;
 Color darkBlue = Colors.blue[900];
const Color grey = Colors.grey;
Color gradient = <Color>[grey,pink] as Color ;

TextStyle textStyle = new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: white);
TextStyle redTextStyle = new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: red);
TextStyle blackTextStyle = new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black);
TextStyle whiteButtonTextStyle = new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0, color: darkBlue);
TextStyle formButtonTextStyle = new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0, color: darkBlue);

TextStyle whiteTextFormStyle = new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0, color: white);
TextStyle blueTextFormStyle = new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0, color: darkBlue);

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}