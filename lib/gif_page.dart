import 'package:flutter/material.dart';
import 'package:share/share.dart';
class GifPage extends StatelessWidget {
  Map gifData;
  GifPage(this.gifData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Share.share(gifData['images']['fixed_height']['url']);
            },
            icon: Icon(Icons.share),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.black,
        title: Text(gifData['title'],style: TextStyle(color: Colors.white),),
       iconTheme: IconThemeData(
         color: Colors.white,
       ),
      ),

      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(gifData['images']['fixed_height']['url']),
      ),
    );
  }
}
