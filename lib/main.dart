
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:distance_flutter/MainView/map.dart';
import 'package:distance_flutter/MainView/focus.dart';
import 'package:distance_flutter/MainView/distance.dart';
import 'package:distance_flutter/Model/AppData.dart';
import 'package:provider/provider.dart';

String focusUrl = 'https://distance.xiaomap.cn/api/?do=follow';
String aboutUrl = 'https://distance.xiaomap.cn/api/?do=about';

const List barList = ["距离", "地图", "关注", "关于"];
const List iconListUnselect = [
  Icon(Icons.my_location),
  Icon(Icons.map),
  Icon(Icons.star),
  Icon(Icons.supervised_user_circle)
];

const List iconListSelect = [
  Icon(Icons.bluetooth),
  Icon(Icons.blur_linear),
  Icon(Icons.bookmark),
  Icon(Icons.call_missed_outgoing)
];

void main() {
  //在加载app前 载入所有插件
  WidgetsFlutterBinding.ensureInitialized();

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      //statusBarColor: Colors.green,
      );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  realRunApp();
}

void realRunApp() async {
  await User.instance.getUUID();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppStateProvider appStateProvider = AppStateProvider();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => appStateProvider,
        child: MaterialApp(
            title: 'Voice Demo',
            localeResolutionCallback: (devicelocal, suportlocal) {
              appStateProvider.changeLang(devicelocal.toString());
              return devicelocal;
            },
            theme: ThemeData(primarySwatch: Colors.blue),
            home: MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BottomNavigationBarItem> items;
  int curidx = 0;
  PageController controller;

  @override
  void initState() {
    controller = PageController();
    items = List.generate(barList.length, (idx) {
      return BottomNavigationBarItem(
          title: Text('${barList[idx]}'), icon: iconListUnselect[idx]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    AppStateProvider state = Provider.of<AppStateProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('距離'),
      ),
      body: IndexedStack(
        index: curidx,
        children: <Widget>[
          MainPage(),
          DisMapWidget(),
          WebPage(url: focusUrl),
          WebPage(url: aboutUrl)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: items,
          unselectedItemColor: Colors.black,
          iconSize: 20,
          currentIndex: curidx,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (idx) {
            curidx = idx;
            setState(() {});
          }),
    );
  }
}
