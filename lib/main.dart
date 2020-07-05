

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'gif_page.dart';
void main(){

  runApp(MaterialApp(
    title: "Buscador de gifs",
    home: Homepage(),
    theme: ThemeData(
      hintColor: Colors.white,
     primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(

        focusedBorder: (
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white,),)
        ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
      ),
    ),
  ));
}

