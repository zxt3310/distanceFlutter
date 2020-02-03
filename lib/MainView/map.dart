import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

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
            center: LatLng(39.9165, 116.48729),
            zoom: 12,
            onTap: (e) {
              setState(() {
                isShow = true;
              });
            }),
        layers: [
          new TileLayerOptions(
              urlTemplate:
                  "https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scl=1&style=8rd&x={x}&y={y}&z={z}"),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(39.9165, 116.48729),
                builder: (ctx) => Container(
                    child: IconButton(
                        icon: Icon(Icons.location_on, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            isShow = false;
                          });
                        })),
              ),
            ],
          ),
        ],
      ),
      Offstage(
        offstage: isShow,
        child: Align(
          alignment: Alignment(0, -0.8),
          child: Container(
              width: 350,
              height: 100,
              color: Colors.white,
              child:
                  Center(child: Text('疫情信息', style: TextStyle(fontSize: 20)))),
        ),
      )
    ]));
  }
}
