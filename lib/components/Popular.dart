import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Popular {
  final String title;
  final String slug;
  final String desc;
  final String view;
  final String image;

  Popular({required this.title, required this.slug, required this.desc, required this.view, required this.image});

  factory Popular.fromJson(Map<String, dynamic> json) {
    return Popular(
      title: json['title'],
      slug: json['slug'],
      desc: json['desc'],
      view: json['view'],
      image: json['image'],
    );
  }
}

class PopularPage extends StatefulWidget {
  @override
  _PopularPageState createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  late Future<List<Popular>> futurePopular;

  @override
  void initState() {
    super.initState();
    futurePopular = fetchPopular();
  }

  Future<List<Popular>> fetchPopular() async {
    final String apiUrl = 'https://api.i-as.dev/api/komiku/popular';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      }).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Popular> popularList = (jsonData['popular'] as List)
        .map((item) => Popular.fromJson(item))
        .toList();
      return popularList;
    } else {
      throw Exception('Failed to load popular data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Komiku'),
      ),
      body: FutureBuilder<List<Popular>>(
        future: futurePopular,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi Kesalahan, Silakan Muat Ulang Halaman.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          }

          final popularList = snapshot.data!;

          return ListView.builder(
            itemCount: popularList.length,
            itemBuilder: (context, index) {
              final popular = popularList[index];
              return ListTile(
                leading: Image.network(popular.image),
                title: Text(popular.title),
                subtitle: Text(popular.desc),
                trailing: Text(popular.view),
                onTap: () {
                  // Aksi ketika item ditekan
                },
              );
            },
          );
        },
      ),
    );
  }
}