import 'package:daily_salim_quote/utils/SalimQuoteJSON.dart';
import 'package:flutter/material.dart';

class AllQuotesPage extends StatefulWidget {
  const AllQuotesPage({Key? key, required List<Quote> this.quality})
      : super(key: key);

  final quality;

  @override
  _AllQuotesPageState createState() => _AllQuotesPageState();
}

class _AllQuotesPageState extends State<AllQuotesPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.quality.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("All Quotes"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: widget.quality.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(widget.quality[index].body),
          );
        },
      ),
    );
  }
}
