import 'package:flutter/material.dart';
import 'package:casino_app/Casinos/model.dart';
import 'package:casino_app/Database/database.dart';

const key = 'AIzaSyBFw8PokN3sZbG37jwAxk4u3tPAnS7Kz_g';

class CasinoView extends StatefulWidget {
  CasinoView(this.casino);

  final Casino casino;

  @override
  CasinoViewState createState() => CasinoViewState();

}

class CasinoViewState extends State<CasinoView> {
  Casino casinoState;

  @override
  void initState() {
    super.initState();
    casinoState = widget.casino;
    CasinoDatabase db = CasinoDatabase();
    db.getCasino(casinoState.id).then((casino) {
      setState(() => casinoState.favored = casino.favored);
    });
  }

  void onPressed(){
    CasinoDatabase db = CasinoDatabase();
    setState(() => casinoState.favored = !casinoState.favored);
    casinoState.favored == true
        ? db.addCasino(casinoState)
        : db.deleteCasino(casinoState.id);
  }


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        initiallyExpanded: casinoState.isExpanded ?? false,
        onExpansionChanged: (b) => casinoState.isExpanded = b,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: RichText(
              text:  TextSpan(
                text: casinoState.rating,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: casinoState.favored
              ? Icon(Icons.star)
              : Icon(Icons.star_border),
          color: Colors.white,
          onPressed: () {
            onPressed();
          },
        ),
        title: Container(
            height: 180.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                casinoState.photos != null
                    ? Hero(
                  child: Image.network(
                      "https://maps.googleapis.com/maps/api/place/photo?photoreference=${casinoState
                          .photos}&maxheight=130&maxwidth=150&key=$key"),
                  tag: casinoState.id,
                )
                    : Container(),
                Expanded(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              casinoState.name,
                              maxLines: 10,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            )
        )
    );
  }
}

