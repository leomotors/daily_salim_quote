// 🎯 Dart imports:
import "dart:convert";
import "dart:math";

// 🐦 Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// 📦 Package imports:
import "package:http/http.dart" as http;
import "package:package_info/package_info.dart";
import "package:url_launcher/url_launcher.dart";

// 🌎 Project imports:
import "package:daily_salim_quote/all_quotes.dart";
import "package:daily_salim_quote/model.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Daily Salim Quote",
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: "Anakotmai",
      ),
      home: const MyHomePage(title: "Daily Salim Quote"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final random = Random();
  final _salimAPIUrl = "https://watasalim.vercel.app/api/quotes";
  final _salimRepoSauce = "https://github.com/narze/awesome-salim-quotes";
  final _stupidWhistleLocation =
      "assets/images/the_whistle_that_make_our_country_catastrophic_till_today.jpg";
  final _heaven = "https://www.youtube.com/watch?v=j8PxqgliIno";
  final _chanceToHeaven = 3;

  List<Quote> quotes = [];
  String currentQuote = "กำลังโหลด รอแป๊ปนึง น ะ จ๊ ะ";
  int currentQuoteID = -1;
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    getSalimQuote();
    getPkgVersion();
  }

  Future<void> getSalimQuote() async {
    if (quotes.isNotEmpty) return;
    Uri salimUri = Uri.parse(_salimAPIUrl);
    var response = await http.get(salimUri);
    quotes = salimQuoteFromJson(utf8.decode(response.bodyBytes)).quotes;
    setState(() {
      randomText();
    });
  }

  Future<void> getPkgVersion() async {
    PackageInfo pkgInfo = await PackageInfo.fromPlatform();
    appVersion = pkgInfo.version;
  }

  void randomText() {
    currentQuoteID = random.nextInt(quotes.length);
    currentQuote = quotes[currentQuoteID].body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Salim Quote",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (random.nextInt(100) < _chanceToHeaven) {
                launchUrl(Uri.parse(_heaven));
              }
              setState(() {
                randomText();
              });
            },
            icon: const Icon(Icons.replay),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentQuote,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Text(
            "Quote #${currentQuoteID + 1}",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: currentQuote));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("คัดลอกสำเร็จ!!!"),
                ),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text("ก็อฟฟฟ"),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffff7f00),
              ),
              child: Text(
                "เมนูของพวกชังชาติ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.all_inbox),
              title: const Text("แสดงคำพูดทั้งหมด"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return AllQuotesPage(quality: quotes);
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("เกี่ยวกับแอป"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationVersion: "เวอร์ชั่น $appVersion",
                  applicationIcon:
                      Image.asset(_stupidWhistleLocation, height: 80),
                  children: [
                    InkWell(
                      child: const Text(
                        "ที่มา (Sauce) ของคำพูด",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        launchUrl(Uri.parse(_salimRepoSauce));
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "แอปนี้สร้างโดย",
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FlutterLogo(
                        style: FlutterLogoStyle.horizontal,
                        size: 50,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
