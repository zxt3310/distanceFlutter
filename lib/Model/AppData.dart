import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//唯一标识符
import 'package:uuid/uuid.dart';

class AppStateProvider with ChangeNotifier {
  String localLang;
  Place myLocate;
  ContentData content;
  String uuid;
  Situations curSitu = Situations();

  changeContent(ContentData data) {
    content = data;
    notifyListeners();
  }

  changeLang(String local) => localLang = local;
  changeLocal(Place locate) => myLocate = locate;
  changeSitu(Situations cur){
    curSitu = cur;
    notifyListeners();
  }

  List<Place> getAllPlaces(){
    List<Place> places = List();
    for (Situations situ in content.situations) {
      for (Place place in situ.places) {
        places.add(place);
      }
    }
    return places;
  }
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
  String type = '';
  String typeColor = '#FFFFFF';
  String title ='';
  String level = '';
  String levelColor = '#FFFFFF';
  String startTime = '';
  String endTime = '';
  String detail = '';
  int distance = 0;
  String url = '';
  String source = '';
  String createAt = '';
  String updateAt = '';
  List<Place> places = List();

  Situations();

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

  Place({this.name, this.lng, this.lat});

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

class User {
  String uuid;

  factory User() => _getInstance();
  static User get instance => _getInstance();
  static User _instance;
  User._internal();
  static User _getInstance() {
    if (_instance == null) {
      _instance = User._internal();
    }
    return _instance;
  }

  Future getUUID() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    uuid = shared.get('UUID');
    if (uuid == null) {
      uuid = Uuid().v1();
      shared.setString('UUID', uuid);
    }
    print(uuid);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    hexColor = hexColor.replaceAll('0X', '');
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
