import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider/ThemeProvider.dart';
import 'Detail.dart';

class GenreDetail extends StatefulWidget {
  final String title;
  final String slug;

  GenreDetail({required this.title, required this.slug});

  @override
  _GenreDetailState createState() => _GenreDetailState();
}

class _GenreDetailState extends State<GenreDetail> {
  List<dynamic> genreDetails = [];
  bool isLoading = true;

  int currentPage = 1;
  String selectedOrderBy = 'modified';
  String selectedType = 'manga';

  List<dynamic> orderByOptions = [];
  List<dynamic> typeOptions = [];

  @override
  void initState() {
    super.initState();
    fetchFilters();
    fetchGenreDetail();
  }

  Future<void> fetchFilters() async {
    try {
      final orderByResponse = {
        "type": [
          {"title": "Update", "slug": "modified"},
          {"title": "Judul Baru", "slug": "date"},
          {"title": "Peringkat", "slug": "meta_value_num"},
          {"title": "Acak", "slug": "rand"}
        ]
      };

      final typeResponse = {
        "type": [
          {"title": "Manga", "slug": "manga"},
          {"title": "Manhua", "slug": "manhua"},
          {"title": "Manhwa", "slug": "manhwa"}
        ]
      };

      setState(() {
        orderByOptions = orderByResponse['type'] as List<Map<String, String>>;
        typeOptions = typeResponse['type'] as List<Map<String, String>>;
      });
    } catch (e) {
      print('Error fetching filters: $e');
    }
  }

  Future<void> fetchGenreDetail() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'https://api.i-as.dev/api/komiku/genre/${widget.slug}?page=$currentPage&orderby=$selectedOrderBy&type=$selectedType');
    try {
      final response = await http
          .get(url)
          .timeout(Duration(seconds: 10)); // Tambahkan timeout

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          genreDetails = jsonData['genreDetail'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching genre details: $e');
    }
  }

  void navigateToChapter(String slug) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(slug: slug),
      ),
    );
  }

  void _loadMore() {
    if (currentPage > 0) {
      setState(() {
        currentPage++;
      });
      fetchGenreDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: themeProvider.isDarkMode ? Colors.white : Colors.indigo))
          : genreDetails.isEmpty
              ? Center(child: Text('Terjadi Kesalahan, Silakan Muat Ulang Halaman.'))
              : Column(
                  children: [
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Order By',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              isExpanded: true,
                              value: selectedOrderBy,
                              onChanged: (value) {
                                setState(() {
                                  selectedOrderBy = value!;
                                  currentPage = 1;
                                });
                                fetchGenreDetail();
                              },
                              items: orderByOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option['slug'],
                                  child: Text(option['title']),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Type',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              isExpanded: true,
                              value: selectedType,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                  currentPage = 1;
                                });
                                fetchGenreDetail();
                              },
                              items: typeOptions.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option['slug'],
                                  child: Text(option['title']),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: genreDetails.isEmpty
                          ? Center(child: Text('Terjadi Kesalahan, Silakan Muat Ulang Halaman.'))
                          : ListView.builder(
                              padding: EdgeInsets.all(16.0),
                              itemCount: genreDetails.length + 1,
                              itemBuilder: (context, index) {
                                if (index == genreDetails.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: currentPage > 1
                                              ? () {
                                                  setState(() {
                                                    currentPage--;
                                                  });
                                                  fetchGenreDetail();
                                                }
                                              : null,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_back,
                                                color: themeProvider.isDarkMode ? Colors.white : Colors.indigo,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        TextButton(
                                          onPressed: () {
                                            _loadMore();
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_forward,
                                                color: themeProvider.isDarkMode ? Colors.white : Colors.indigo,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                final genre = genreDetails[index];
                                return GestureDetector(
                                  onTap: () {
                                    navigateToChapter(genre['slug']);
                                  },
                                  child: Card(
                                    elevation: 1,
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Image.network(
                                              genre['image'],
                                              height: 120,
                                              width: 90,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Center(child: CircularProgressIndicator());
                                              },
                                              errorBuilder: (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(Icons.error, color: Colors.red),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  genre['title'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  genre['desc'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8.0),
                                                 Row(
												    children: [
													  Icon(Icons.visibility, color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54, size: 14),
													  SizedBox(width: 5),
													  Text(
													    '${genre['view']}',
													    style: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14),
													  ),
												    ],
												  )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
