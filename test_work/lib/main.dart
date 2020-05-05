import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());
class BigPhoto extends StatefulWidget{
  String urlb;

  BigPhoto({this.urlb});

  @override
  _BigPhotoState createState() => _BigPhotoState(url: urlb);

}

class _BigPhotoState extends State<BigPhoto>{
  String url;
  _BigPhotoState({this.url});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("photo"),
      ),
      body: Center(
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/loading.gif',
          image: url,
        ),
      ),
    );
  }
}

class PhotoListItem extends StatelessWidget{
  final String url;
  final String urlb;
  final String username;
  PhotoListItem({this.url,this.username,this.urlb});

  Widget build(BuildContext context){

    return  FlatButton(
      padding: const EdgeInsets.all(8),
      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>BigPhoto(urlb: urlb)));},
      child: Container(
          child: Row(
            children: <Widget>[Image(
              image: NetworkImage(this.url),
              width: 100,
            ),Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                username,
              ),
            )],
          )
      ),
    );
  }
}

class Photo{
  final String urlsm;
  final String urlbg;
  final String username;

  Photo({this.urlsm, this.urlbg, this.username});
  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      urlsm: json['urls']['thumb'] as String,
      urlbg:json['urls']['full'] as String,
      username: json['user']['name'] as String,
    );
  }
}
List<Photo> parsePhotos(String response){
  final parsed = json.decode(response).cast<Map<String,dynamic>>();
  return parsed.map<Photo>((json)=>Photo.fromJson(json)).toList();
}
Future<List<Photo>> getData(http.Client client) async {
  final response= await client.get(
      'https://api.unsplash.com/photos/?client_id=-W4cFVFtfNwMfqm-23iZh7lGPs3bre2NfzTgidF2akc'
  );
  return compute(parsePhotos,response.body);
}
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Photos")
        ),
        body: FutureBuilder<List<Photo>>(
          future: getData(http.Client()),
          builder: (context,snapshot){
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  return PhotoListItem(username: snapshot.data[index].username,url: snapshot.data[index].urlsm,urlb: snapshot.data[index].urlbg);
                }) : Center(child: Text("loading"));
          },
        )

      )
    );
  }
}

