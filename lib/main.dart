import 'package:flutter/material.dart';
import 'Model/basic_model.dart';
import 'Screens/home_screen.dart';

List<String> favlist = [];
String? favourite;
List<Datum> basicdata = [];

const String discover_page_Url = "https://expresstemplate.in/mix_drawing/webservice/app_detail.php?code=en&pp=100&page=1&id=8";
const String Base_Url_image = "https://expresstemplate.in/mix_drawing/images/tattoo/thumb/";

const String favourite_page_Url = "https://expresstemplate.in/mix_drawing/webservice/bookmark.php?code=en&id=";

const String Detail_page_Url = "https://expresstemplate.in/mix_drawing/webservice/get_step.php?code=en&tattoo_id=";
const String Detail_page_Image_Url = "https://expresstemplate.in/mix_drawing/images/steps/";

List allclr = [
  const Color(0xFF3FA39D),
  const Color(0xFF74A3EB),
  const Color(0xFFEB982B),
  const Color(0xFFDA73EB),
];

void main() {
  runApp(MaterialApp(
    home: home_screen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
  ));
}

