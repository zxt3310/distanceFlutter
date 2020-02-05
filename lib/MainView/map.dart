import 'package:distance_flutter/Model/AppData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class DisMapWidget extends StatefulWidget {
  DisMapWidget({Key key}) : super(key: key);

  @override
  _DisMapWidgetState createState() => _DisMapWidgetState();
}

class _DisMapWidgetState extends State<DisMapWidget> {
  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      FlutterMap(
        options: new MapOptions(
            center: LatLng(30.5669771700, 114.3017346200),
            zoom: 5,
            onTap: (e) {
              setState(() {
                isShow = true;
              });
            }),
        layers: [
          new TileLayerOptions(
              urlTemplate:
                  "https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scl=1&style=8rd&x={x}&y={y}&z={z}"),
          new MarkerLayerOptions(markers: getMarks()),
        ],
      ),
      Offstage(
        offstage: isShow,
        child: Align(
            alignment: Alignment(0, -0.8),
            child: Consumer<AppStateProvider>(builder: (ctx, state, child) {
              Situations situation = state.curSitu;
              return Container(
                  width: 370,
                  height: 105,
                  color: Colors.white,
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(TextSpan(
                                            text: '${situation.title}   ',
                                            children: [
                                              TextSpan(
                                                  text: '#${situation.type}',
                                                  style: TextStyle(
                                                      color: HexColor(
                                                          situation.typeColor)))
                                            ])),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 2, 5, 2),
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
                                      maxLines: 2),
                                ],
                              )))
                    ],
                  ));
            })),
      )
    ]));
  }

  double sizeofFont(int distance) {
    int len = distance.toString().length;
    return (40 - (len - 1) * 7).toDouble();
  }

  List<Marker> getMarks() {
    AppStateProvider state = Provider.of<AppStateProvider>(context);
    if(state.content == null) return List();
    List situations = state.content.situations;
    return List.generate(situations.length, (idx) {
      Situations situation = situations[idx];
      Place place = situation.places[0];
      return new Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(place.lat, place.lng),
        builder: (ctx) => Container(
            child: IconButton(
                icon: Icon(Icons.location_on, color: Colors.red),
                onPressed: () {
                  setState(() {
                    isShow = false;
                    state.changeSitu(situation);
                  });
                })),
      );
    });
  }
}
