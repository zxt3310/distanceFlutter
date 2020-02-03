import 'package:flutter/material.dart';

class AppStateProvider with ChangeNotifier{
  String localLang;
  Place myLocate;
  ContentData content;

  changeContent(ContentData data){
    content = data;
    notifyListeners();
  }

  changeLang(String local) => localLang = local;
  changeLocal(Place locate) => myLocate = locate;
}

class ContentData {
  List<News> news;
  List<Situations> situations;

  ContentData.fromJson(Map<String, dynamic> json)
      : news = News.getnews(json['news']),
        situations = Situations.getSituations(json['list']);
}

//标题抬头
class News {
  String imageSrc;
  int imageWidth;
  int imageHeight;
  String title;
  String url;

  News.fromJson(Map<String, dynamic> json)
      : imageSrc = json['image_src'],
        imageWidth = json['image_width'],
        imageHeight = json['image_height'],
        title = json['title'],
        url = json['url'];

  static List<News> getnews(List list) {
    return List<News>.generate(list.length, (idx) {
      return News.fromJson(list[idx]);
    });
  }
}

class Situations {
  int id;
  String type;
  String typeColor;
  String title;
  String level;
  String levelColor;
  String startTime;
  String endTime;
  String detail;
  int distance;
  String url;
  String source;
  String createAt;
  String updateAt;
  List<Place> places;

  Situations.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        typeColor = json['type_color'],
        title = json['title'],
        level = json['level'],
        levelColor = json['level_color'],
        startTime = json['start_time'],
        endTime = json['end_time'],
        detail = json['detail'],
        distance = json['distance'],
        url = json['url'],
        source = json['source'],
        createAt = json['created_at'],
        updateAt = json['updated_at'],
        places = Place.getPlaces(json['places']);

  static List<Situations> getSituations(List list) {
    return List<Situations>.generate(list.length, (idx) {
      return Situations.fromJson(list[idx]);
    });
  }
}

class Place {
  String name;
  double lng;
  double lat;

  Place({this.name,this.lng,this.lat});

  Place.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lng = json['lng'],
        lat = json['lat'];

  static List<Place> getPlaces(List list) {
    return List<Place>.generate(list.length, (idx) {
      return Place.fromJson(list[idx]);
    });
  }
}
