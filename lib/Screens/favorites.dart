import 'package:flutter/material.dart';
import 'package:casino_app/Casinos/model.dart';
import 'package:casino_app/Database/database.dart';
import 'package:rxdart/rxdart.dart';
const key = 'AIzaSyBFw8PokN3sZbG37jwAxk4u3tPAnS7Kz_g';

class Favorites extends StatefulWidget {
  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  List<Casino> filteredCasinos = List();
  List<Casino> casinoCache = List();

  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    filteredCasinos = [];
    casinoCache = [];
    subject.stream.listen(searchDataList);
    setupList();
  }

  void setupList() async {
    CasinoDatabase db = CasinoDatabase();
    filteredCasinos = await db.getCasinos();
    setState(() {
      casinoCache = filteredCasinos;
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void searchDataList(query) {
    if (query.isEmpty) {
      setState(() {
        filteredCasinos = casinoCache;
      });
    }
    setState(() {});
    filteredCasinos = filteredCasinos
        .where((m) => m.name
        .toLowerCase()
        .trim()
        .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
        .toList();
    setState(() {});
  }

  void onPressed(int index) {
    setState(() {
      filteredCasinos.remove(filteredCasinos[index]);
    });
    CasinoDatabase db = CasinoDatabase();
     db.deleteCasino(filteredCasinos[index].id);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => (subject.add(string)),
            keyboardType: TextInputType.url,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredCasinos.length,
              itemBuilder: (BuildContext context, int index) {
                return new ExpansionTile(
                  initiallyExpanded: filteredCasinos[index].isExpanded ?? false,
                  onExpansionChanged: (b) =>
                  filteredCasinos[index].isExpanded = b,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: RichText(
                        text: TextSpan(
                          text: filteredCasinos[index].rating,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),

                  ],
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      onPressed(index);
                    },
                  ),
                  title: Container(
                    height: 200.0,
                    child: Column(
                      children: <Widget>[
                        filteredCasinos[index].photos != null
                            ? Hero(
                          child: Image.network(
                            "https://maps.googleapis.com/maps/api/place/photo?photoreference=${filteredCasinos[index].photos}&maxheight=130&maxwidth=150&key=$key"),
                          tag: filteredCasinos[index].id,
                        )
                            : Container(),
                        Expanded(
                          child: Text(
                            filteredCasinos[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

