import 'package:daily_salim_quote/screens/AllQuotes.dart';
import 'package:daily_salim_quote/utils/SalimQuoteJSON.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Salim Quote',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: "Anakotmai",
      ),
      home: MyHomePage(title: 'Daily Salim Quote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final random = Random();
  final _salimAPIUrl = "https://watasalim.vercel.app/api/quotes";
  final _salimRepoSauce = "https://github.com/narze/awesome-salim-quotes";
  final _stupidWhistleLocation =
      "assets/images/the_whistle_that_make_our_country_catastrophic_till_today.jpg";
  final _heaven = "https://www.youtube.com/watch?v=j8PxqgliIno";

  List<Quote> quotes = [];
  String currentQuote = "";
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    getSalimQuote();
    getPkgVersion();
  }

  Future<void> getSalimQuote() async {
    if (quotes.length > 0) return;
    Uri _salimUri = Uri.parse(_salimAPIUrl);
    var response = await http.read(_salimUri);
    quotes = salimQuoteFromJson(response).quotes;
    randomText();
  }

  Future<void> getPkgVersion() async {
    PackageInfo pkgInfo = await PackageInfo.fromPlatform();
    appVersion = pkgInfo.version;
  }

  void randomText() {
    currentQuote = quotes[random.nextInt(quotes.length)].body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily Salim Quote",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if(random.nextInt(100)<3)
                launch(_heaven);
              setState(() {
                randomText();
              });
            },
            icon: Icon(Icons.replay),
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getSalimQuote(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "$currentQuote",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(color: Colors.blue[100]),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: currentQuote));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("ก็อฟฟี่成功!!!"),
                ),
              );
            },
            icon: Icon(Icons.copy),
            label: Text("ก็อฟฟฟ"),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "เมนูของพวกชังชาติ",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
                leading: Icon(Icons.all_inbox),
                title: Text("Show all Quotes"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return AllQuotesPage(quality: quotes);
                      },
                    ),
                  );
                }),
            ListTile(
                leading: Icon(Icons.info),
                title: Text("About App"),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationVersion: "เวอร์ชั่น " + appVersion,
                    applicationIcon:
                        Image.asset(_stupidWhistleLocation, height: 80),
                    children: [
                      InkWell(
                          child: Text(
                            "Quote's Sauce",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            launch(_salimRepoSauce);
                          }),
                      SizedBox(height: 10),
                      Text(
                        "Made possible with",
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlutterLogo(
                            style: FlutterLogoStyle.horizontal, size: 50),
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
