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

  @override
  void initState() {
    super.initState();
    getSalimQuote();
  }

  Future<void> getSalimQuote() async {
    Uri _salimUri = Uri.parse(_salimAPIUrl);
    var response = await http.read(_salimUri);
    quotes = salimQuoteFromJson(response).quotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Salim Quote"),
      ),
      body: FutureBuilder(
        future: getSalimQuote(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${quotes[random.nextInt(quotes.length)]}");
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
