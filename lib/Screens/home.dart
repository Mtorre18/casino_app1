import 'package:flutter/material.dart';
import 'package:casino_app/Casinos/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:casino_app/Screens/casinoView.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

const key = 'AIzaSyBFw8PokN3sZbG37jwAxk4u3tPAnS7Kz_g';



class HomePage extends StatefulWidget{
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  List<Casino> casinos = List();

  bool hasLoaded = true;


  final PublishSubject subject = PublishSubject<String>();


  @override
  void dispose() {
    subject.close();
    super.dispose();
  }


  @override
  void initState(){
    super.initState();

    subject.stream.debounce(Duration(milliseconds: 400)).listen(searchCasinos);


  }


  void searchCasinos(query){
    resetCasinos();
    if (query.isEmpty){
      setState((){
        hasLoaded = true;
      });
      return;
    }


    setState(()=> hasLoaded = false);
    http.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=3000000&type=casino&key=$key&location=36.17497, -115.13722')
        .then((res) => (res.body))
        .then(json.decode)
        .then((map) => map["results"])
        .then((casinos) => casinos.forEach(addCasino))
        .catchError(onError)
        .then((e){
      setState(() {
        hasLoaded = true;
      });
    });
  }

  void onError(dynamic d){
    setState((){
      hasLoaded = true;
    });
  }

  void addCasino(item){
    setState((){
      casinos.add(Casino.fromJson(item));
    });
    print('${casinos.map((m) => m.name)}');
  }


  void resetCasinos(){
    setState(() => casinos.clear());
  }


  @override
  Widget build (BuildContext context){
    return  Container(
          padding: EdgeInsets.all(10.0),
          child:Column(
            children: <Widget>[
              TextField(
                onChanged: (String string) => (subject.add(string)),

              ),

              hasLoaded ? Container () : CircularProgressIndicator(),
              Expanded(
                  child:ListView.builder(

                    padding: EdgeInsets.all(10.0),
                    itemCount: casinos.length,
                    itemBuilder: (BuildContext context, int index){
                      return new CasinoView(casinos[index]);
                    },
                  )


              ),
            ],
          )
    );
  }
}

