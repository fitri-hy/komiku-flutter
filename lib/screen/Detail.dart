import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Chapter.dart';
import '../main.dart';

class Detail extends StatelessWidget {
  final String slug;

  Detail({required this.slug});

  Future<Map<String, dynamic>> fetchDetails() async {
    final response = await http.get(
      Uri.parse('https://api.i-as.dev/api/komiku/detail/$slug'),
      headers: {
        'Content-Type': 'application/json',
      }).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: fetchDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              final chapterData = snapshot.data!;
              String title = chapterData['title'] ?? 'N/A';
              return Text(title);
            }
          },
        ),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi Kesalahan, Silakan Muat Ulang Halaman.'));
          } else {
            final chapterData = snapshot.data!;
            String title = chapterData['title'] ?? 'N/A';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: Image.network(
                          chapterData['image'] ?? '',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 50);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(chapterData['desc'] ?? 'N/A', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 16.0),
                    Text('Synopsis:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Text(chapterData['synopsis'] ?? 'N/A', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 16.0),
                    Text('Author: ${chapterData['author'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
                    Text('Status: ${chapterData['status'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 16.0),
                    Text('Chapters:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: chapterData['chapters']?.length ?? 0,
                      itemBuilder: (context, index) {
                        var chapter = chapterData['chapters'][index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ListTile(
                            title: Text(chapter['title'] ?? 'N/A', style: TextStyle(fontSize: 14)),
                            subtitle: Row(
                              children: [
                                Icon(Icons.remove_red_eye, size: 14, color: Colors.grey),
                                SizedBox(width: 5),
                                Text('Views: ${chapter['views'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
                                SizedBox(width: 16),
                                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                SizedBox(width: 5), 
                                Text('Date: ${chapter['date'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chapter(slug: chapter['slug'] ?? 'default-slug', title: title),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
