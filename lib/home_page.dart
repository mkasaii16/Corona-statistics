import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:wave_drawer/wave_drawer.dart';
import 'package:loading_indicator/loading_indicator.dart';

Map iranum;
List countryname;
String country;
final List<Widget> images = [
  Container(
    color: Colors.blueGrey,
  ),
  Container(
    color: Colors.black,
  ),
  Container(
    color: Colors.red[900],
  ),
  Container(
    color: Colors.pink[800],
  ),
  Container(
    color: Colors.amber,
  ),
  Container(
    color: Colors.red[400],
  ),
  Container(
    color: Colors.brown,
  ),
  Container(
    color: Colors.blue,
  ),
];

Future countrylist() async {
  Dio dio = new Dio();
  var countryall =
  await dio.get('https://coronavirus-19-api.herokuapp.com/countries/');
  countryname = List<dynamic>.from(countryall.data);
  return countryname;
}

Future geting() async {
  if (country == null) {
    country = 'iran';
  }

  Dio dio = new Dio();

  var response = await dio
      .get('https://coronavirus-19-api.herokuapp.com/countries/$country');
  iranum = Map<String, dynamic>.from(response.data);
  return iranum;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // controller.countrylist();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
              child: Text('  کرونا ایران وجهان',
                  textScaleFactor: 1.0,
                  style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                const url = 'https://covid19.who.int/region/emro/country/ir';
                launchURL(url);
              },
              child: Text(' who.int منبع',
                  textScaleFactor: 1.0,
                  style: new TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                     )),
            ),
          ],
        ),
        drawer: WaveDrawer(
          backgroundColor: Colors.red,
          boundaryColor: Colors.redAccent[400],
          boundaryWidth: 8.0,
          child: FutureBuilder(
              future: countrylist(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: countryname.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.center,
                        width: 60,
                        padding: EdgeInsets.all(4),
                        child: Column(children: [
                          TextButton(
                              onPressed: () {
                                country = countryname[index]['country'];
                                Get.offAll(MyHomePage());
                              },
                              child: Text(countryname[index]['country'],
                                  textScaleFactor: 1.0,
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ))),
                          Divider(
                            color: Color(0xaa100003),
                            thickness: 2,
                          ),
                        ]),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Container(
                  width: 60,
                  height: 60,
                  child: LoadingIndicator(
                    indicatorType: Indicator.pacman,
                    color: Colors.red,
                  ),
                );
              }),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/logo.jpg"), fit: BoxFit.cover)),
          child: Center(
            child: FutureBuilder(
              future: geting(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String fotemroz = iranum['todayDeaths'].toString();
                  if (iranum['todayDeaths'].toString() != '0') {
                    fotemroz = fotemroz + ' تعداد فوتی امروز';
                  } else {
                    fotemroz = ' تعداد فوتی اعلام نشده';
                  }

                  String tedademroz = iranum['todayCases'].toString();
                  if (iranum['todayCases'].toString() != '0') {
                    tedademroz = tedademroz + ' تعداد مبتلا امروز';
                  } else {
                    tedademroz = ' تعداد مبتلا اعلام نشده';
                  }

                  String bohrani = iranum['critical'].toString();
                  bohrani = bohrani + ' تعداد وخیم امروز';

                  String faalemroz = iranum['active'].toString();
                  faalemroz = faalemroz + ' تعداد مبتلا فعال';

                  String fotkol = iranum['deaths'].toString();
                  fotkol = fotkol + ' تعداد فوتی کل';

                  String tedadkol = iranum['cases'].toString();
                  tedadkol = tedadkol + ' تعداد مبتلا کل';

                  String behbod = iranum['recovered'].toString();
                  behbod = behbod + ' تعداد بهبودی کل';
                  String namecountry = iranum['country'].toString();
                  List<String> titles = [
                    namecountry,
                    bohrani,
                    fotemroz,
                    tedademroz,
                    faalemroz,
                    fotkol,
                    tedadkol,
                    behbod,
                  ];
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: VerticalCardPager(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            titles: titles,
                            images: images,
                            onPageChanged: (page) {},
                            align: ALIGN.CENTER,
                            onSelectedItem: (index) {},
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return LoadingIndicator(
                  indicatorType: Indicator.ballRotate,
                  color: Colors.red[900],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
