import 'dart:convert';
import 'package:distance_flutter/webView/web.dart';
import 'package:flutter/material.dart';
import 'package:distance_flutter/network/net.dart';
import 'package:location/location.dart';
import 'package:distance_flutter/Model/AppData.dart';
import 'package:provider/provider.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  Future future;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getFutrueWidget());
  }

  @override
  void initState() {
    super.initState();
    future = requestNews();
  }

  _getLocation() async {
    LocationData currentLocation;
    Location location = new Location();
// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      Place locate = Place(
          name: 'me',
          lat: currentLocation.latitude,
          lng: currentLocation.longitude);
      AppStateProvider appStateProvider =
          Provider.of<AppStateProvider>(context);
      appStateProvider.myLocate = locate;
      //appStateProvider.changeLocal(locate);
      print('經度:${currentLocation.latitude}  緯度:${currentLocation.longitude}');
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        //error = 'Permission denied';
      }
      currentLocation = null;
    }
  }

  //异步渲染

  Future requestNews() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    if (permission != PermissionStatus.granted) {
      return Future.value('refuse');
    }
    await _getLocation();

    NetManager manager = NetManager.instance;
    AppStateProvider appStateProvider = Provider.of<AppStateProvider>(context);
    return manager.dio.get(
        '/api/?do=list2&lng=${appStateProvider.myLocate.lng}&lat=${appStateProvider.myLocate.lat}&uid=${User.instance.uuid}');
  }

  Widget _getFutrueWidget() {
    return FutureBuilder(
      future: future, //requestNews(),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Response response = snapshot.data;

          if (response == null) {
            return Container(child: Center(child: Text('网络连接错误')));
          }
          Map res = json.decode(response.data);
          if (res['err'] != 0) {
            return Container(child: Center(child: Text(res['errmsg'])));
          }

          ContentData content = ContentData.fromJson(res['data']);
          AppStateProvider appStateProvider =
              Provider.of<AppStateProvider>(context);
          appStateProvider.content = content;

          return _getUI();
        } else {
          return Container(child: Center(child: Text('loading......')));
        }
      },
    );
  }

  Widget _getUI() {
    return Consumer<AppStateProvider>(builder: (ctx, state, child) {
      News news = state.content.news.first;
      List situations = state.content.situations;
      return Container(
          child: ListView.builder(
              itemBuilder: (BuildContext ctx, idx) {
                if (idx == 0) {
                  return GestureDetector(
                      child: (news == null || news.imageSrc == null)
                          ? SizedBox(height: 0)
                          : Image.network(news.imageSrc),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WebPage(url: news.url)));
                      });
                } else {
                  Situations situation = situations[idx - 1];
                  return Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Column(children: [
                            Text('${situation.distance}',
                                style: TextStyle(
                                    fontSize: sizeofFont(situation.distance))),
                            Text('公里')
                          ]),
                          Expanded(
                              child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text.rich(TextSpan(
                                                text: '${situation.title}   ',
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          '#${situation.type}',
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              situation
                                                                  .typeColor)))
                                                ])),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 2, 5, 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: HexColor(
                                                      situation.levelColor)),
                                              child: Text(situation.level,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            )
                                          ]),
                                      Text(situation.detail,
                                          style: TextStyle(fontSize: 16),
                                          maxLines: 3),
                                      Row(
                                          children:
                                              _placesList(situation.places))
                                    ],
                                  )))
                        ],
                      ));
                }
              },
              itemCount: situations.length + 1));
    });
  }

  double sizeofFont(int distance) {
    int len = distance.toString().length;
    return (40 - (len - 1) * 7).toDouble();
  }
}

List<Widget> _placesList(List<Place> places) {
  return List<Widget>.generate(places.length, (idx) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 2, 5, 2),
        child: Text('${places[idx].name}'));
  });
}
