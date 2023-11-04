// * Thanks to https://app.quicktype.io/
// * To parse this JSON data, do
// *   final salimQuote = salimQuoteFromJson(jsonString);

// 🎯 Dart imports:
import "dart:convert";

SalimQuote salimQuoteFromJson(String str) =>
    SalimQuote.fromJson(json.decode(str));

String salimQuoteToJson(SalimQuote data) => json.encode(data.toJson());

class SalimQuote {
  SalimQuote({
    required this.quotes,
  });

  List<Quote> quotes;

  factory SalimQuote.fromJson(Map<String, dynamic> json) => SalimQuote(
        quotes: List<Quote>.from(json["quotes"].map((x) => Quote.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "quotes": List<dynamic>.from(quotes.map((x) => x.toJson())),
      };
}

class Quote {
  Quote({
    required this.id,
    required this.body,
    required this.url,
  });

  int id;
  String body;
  String url;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json["id"],
        body: json["body"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "url": url,
      };
}
