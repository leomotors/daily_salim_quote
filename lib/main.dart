import 'package:daily_salim_quote/utils/SalimQuoteJSON.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<Quote> quotes = [];
  String currentQuote = "";

  @override
  void initState() {
    super.initState();
    getSalimQuote();
  }

  Future<void> getSalimQuote() async {
    if (quotes.length > 0) return;
    Uri _salimUri = Uri.parse(_salimAPIUrl);
    var response = await http.read(_salimUri);
    quotes = salimQuoteFromJson(response).quotes;
  }

  void randomText() {
    currentQuote = quotes[random.nextInt(quotes.length)].body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Salim Quote"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                randomText();
              });
            },
            icon: Icon(Icons.replay),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getSalimQuote(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text(
                "$currentQuote",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "เมนูของพวกชังชาติ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
