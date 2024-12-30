import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchChapterDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi Kesalahan, Silakan Muat Ulang Halaman.'));
            // return Center(child: Text('Error: ${snapshot.error}'));
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
