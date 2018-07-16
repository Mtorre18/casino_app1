import 'package:flutter/material.dart';
import 'package:casino_app/Screens/home.dart';
import 'package:casino_app/Screens/favorites.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(buildContext){
    return MaterialApp(
      title: "Casino App",
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Lucky Casino App'),
            bottom:TabBar(
              tabs: <Widget>[
                Tab(
                  icon:Icon(Icons.home),
                  text:'Home Page',
          ),
          Tab(
            icon: Icon(Icons.favorite),
            text: 'Favorites',
                )
              ]
            )
          ),
          body: TabBarView(
            children: <Widget>[
              HomePage(),
              Favorites(),
            ]
          )
        ),
      )

    );
  }
}

