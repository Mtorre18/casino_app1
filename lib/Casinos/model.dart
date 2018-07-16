import 'package:meta/meta.dart';

class Casino{
  Casino({
    @required this.name,
    @required this.id,
    @required this.photos,
    @required this.rating,
    @required this.types,
    this.favored,
    this.isExpanded,
  });

  String name,id,rating,photos,types;
  bool favored, isExpanded;

  Casino.fromJson(Map json)
      : name = json["name"],
        photos = json["photos"][0]["photo_reference"],
        id = json["place_id"].toString(),
        rating = json["rating"].toString(),
        types = json["types"][0],
        favored = false;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['photos'] = photos;
    map['rating'] = rating;
    map['favored'] = favored;
    return map;
  }

  Casino.fromDb(Map map)
  :name = map["name"],
  photos = map["photos"],
  id = map["id"].toString(),
  rating = map["rating"],
  favored = map["favored"] == 1? true : false;

}