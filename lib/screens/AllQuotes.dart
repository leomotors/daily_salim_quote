import 'package:daily_salim_quote/utils/SalimQuoteJSON.dart';
import 'package:flutter/material.dart';

class AllQuotesPage extends StatefulWidget {
  const AllQuotesPage({Key? key, required List<Quote> quality})
      : super(key: key);

  List<Quote> get quality => quality;

  @override
  _AllQuotesPageState createState() => _AllQuotesPageState();
}

class _AllQuotesPageState extends State<AllQuotesPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListView.builder(
        itemCount: widget.quality.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text(widget.quality[index].body));
        },
      ),
    ]);
  }
}
