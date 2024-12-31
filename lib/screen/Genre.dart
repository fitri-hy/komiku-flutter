import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/GenreModel.dart';
import 'GenreDetail.dart';

class Genre extends StatefulWidget {
  const Genre();

  @override
  _GenreState createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  late List<GenreModel> genres;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    try {
      final response = await http.get(Uri.parse('https://api.i-as.dev/api/komiku/genre')).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          genres = (jsonData['genre'] as List)
              .map((genre) => GenreModel.fromJson(genre))
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to load genres');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToGenreDetail(String title, String slug) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenreDetail(title: title, slug: slug),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.indigo))
        : genres.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('Gagal mendapatkan data!')),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchGenres,
                    child: Text('Coba Lagi'),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => navigateToGenreDetail(genres[index].title, genres[index].slug),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: ListTile(
                            leading: Icon(Icons.category, color: Colors.indigo, size: 30),
                            title: Text(
                              genres[index].title,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.arrow_right, color: Colors.indigo),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
