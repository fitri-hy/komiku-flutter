import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';

class Chapter extends StatelessWidget {
  final String slug;
  final String title;

  Chapter({required this.slug, required this.title});

  Future<List<Map<String, dynamic>>> fetchChapterDetails() async {
    try {
      final response = await http.get(Uri.parse('https://api.i-as.dev/api/komiku/chapter/$slug')).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['chapter']);
      } else {
        throw Exception('Failed to load chapter details');
      }
    } catch (e) {
      throw Exception('Request timed out or failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchChapterDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gagal mendapatkan data!'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      fetchChapterDetails();
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else {
            final chapterData = snapshot.data!;
            return ListView.builder(
              itemCount: chapterData.length,
              itemBuilder: (context, index) {
                var chapter = chapterData[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.network(
                          chapter['image'] ?? '',
                          fit: BoxFit.contain,
                          height: null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
