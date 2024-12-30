import 'dart:convert';
import 'package:http/http.dart' as http;

class Komik {
  final String title;
  final String slug;
  final String desc;
  final String view;
  final String image;

  Komik({required this.title, required this.slug, required this.desc, required this.view, required this.image});

  factory Komik.fromJson(Map<String, dynamic> json) {
    return Komik(
      title: json['title'],
      slug: json['slug'],
      desc: json['desc'],
      view: json['view'],
      image: json['image'],
    );
  }
}

Future<List<Komik>> fetchKomik() async {
  final response = await http.get(Uri.parse('https://api.i-as.dev/api/komiku/latest'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['latest'];
    return jsonData.map((json) => Komik.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load komik');
  }
}