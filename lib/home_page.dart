import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
   String _search;
   int _offset = 0;

 Future<Map> _getGifs() async{
    http.Response response;
    if(_search==null||_search.isEmpty){
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=12233445678&rating=g");//arrume sua propria key !!!!
    }else{
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=12233445678$_search&limit=20&offset=$_offset&rating=g&lang=e");
    }
    return json.decode(response.body);
  }
  int _getItemCount(List data){
    if(_search==null){
      return data.length;
    }else{
      return data.length+1;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _getGifs().then((map){
      //print(map);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),//pega imagem da internet
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              //onChanged: , verifica sempre uma mudança no texto
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });

              },// é verifica quando clica em OK
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white,),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white,fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context,snapshot);

                }
              },
            ) ,
          )
        ],
      ),
    );
  }
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){

    return GridView.builder(
      padding: EdgeInsets.all(10),//mostra a view em formato de grade
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,//qtd de itens na horizontal
          crossAxisSpacing: 10,//espaçamento vertical
          mainAxisSpacing: 10,//espaçamento horizontal
        ), //o delegate mostra como os itens vao ser organizados na tela
        itemBuilder: (context,index){
          if(_search==null || index < snapshot.data['data'].length){
            return GestureDetector(//para poder deixar clicar na imagem
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,//por imagem transparente
                  image: snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300,
                fit: BoxFit.cover,
              ),
             onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return GifPage(snapshot.data['data'][index]);
                }));
             },
            onLongPress: (){
                Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            } ,//segurar apertardo
            );
          }else{
            return Container(
             child: GestureDetector(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Icon(Icons.add,size: 70,color: Colors.white,),
                   Text('Carregar mais...',style: TextStyle(color: Colors.white,fontSize: 22),)
                 ],
               ),
               onTap:(){
                 setState(() {
                   _offset+=19;

                 });
               }
             ),
            );
          }

        },//funçao que retorna o widget de cada posiçao
        itemCount: _getItemCount(snapshot.data['data']),
    );
  }
}

