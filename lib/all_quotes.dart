// 🐦 Flutter imports:
import "package:flutter/material.dart";

// 🌎 Project imports:
import "package:daily_salim_quote/model.dart";

class AllQuotesPage extends StatefulWidget {
  const AllQuotesPage({super.key, required this.quality});

  final List<Quote> quality;

  @override
  State<AllQuotesPage> createState() => _AllQuotesPageState();
}

class _AllQuotesPageState extends State<AllQuotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Quotes"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.quality.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("#${index + 1} ${widget.quality[index].body}"),
          );
        },
      ),
    );
  }
}
