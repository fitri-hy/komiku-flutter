import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Detail.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  int _currentPage = 1;
  List<dynamic> _results = [];
  bool _isLoading = false;
  bool _hasMore = true;

  String selectedOrderBy = 'modified';
  String selectedType = 'manga';
  List<dynamic> orderByOptions = [];
  List<dynamic> typeOptions = [];

  @override
  void initState() {
    super.initState();
    fetchFilters();
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

  Future<void> _search() async {
    final query = _queryController.text;

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Query tidak boleh kosong!')),
      );
      return;
    }

    if (!_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.i-as.dev/api/komiku/search?page=$_currentPage&q=$query',
        ),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _results = data['search'] ?? [];
          _hasMore = data['search'] != null && data['search'].isNotEmpty;
          _currentPage++;
        });
      } else {
        throw Exception('Gagal mendapatkan data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi Kesalahan, Silakan Muat Ulang Halaman.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMore() {
    if (_hasMore) {
      _search();
    }
  }

  void _navigateToDetail(String slug) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(slug: slug),
      ),
    );
  }

  Widget _buildResultItem(Map<String, dynamic> item) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GestureDetector(
        onTap: () => _navigateToDetail(item['slug']),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: item['image'] != null && item['image']!.isNotEmpty
                  ? Image.network(
                      item['image'],
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
                    )
                  : Icon(Icons.image_not_supported, size: 50),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      item['desc'] ?? 'No Description',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.category, size: 14),
                        SizedBox(width: 5),
                        Text(
                          item['type'] ?? '0',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    _search();
                  }
                : null,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          TextButton(
            onPressed: _hasMore ? _loadMore : null,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencarian'),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      labelText: 'Ingin cari apa?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: _search,
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _results.isEmpty
                  ? Center(child: Text('Tidak ada hasil'))
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: _results.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _results.length) {
                            return _buildPagination();
                          }
                          return _buildResultItem(Map<String, dynamic>.from(_results[index]));
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
