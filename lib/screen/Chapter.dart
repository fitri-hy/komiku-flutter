import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../main.dart';
import '../provider/AdMobConfig.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Chapter extends StatefulWidget {
  final String slug;
  final String title;

  Chapter({required this.slug, required this.title});

  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;
  late Future<List<Map<String, dynamic>>> _chapterData;

  @override
  void initState() {
    super.initState();
    _chapterData = fetchChapterDetails();
    _initializeBannerAd();
  }

  void _initializeBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdMobConfig.adBannerUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Failed to load banner ad: ${error.message}');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchChapterDetails() async {
    try {
      final response = await http.get(Uri.parse('https://api.i-as.dev/api/komiku/chapter/${widget.slug}')).timeout(Duration(seconds: 10));

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
        title: Text(widget.title),
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _chapterData,
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
                            setState(() {
                              _chapterData = fetchChapterDetails();
                            });
                          },
                          child: Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data chapter'));
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
                            chapter['image'] != null && chapter['image'].isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      // Open the image in zoomable view
                                      showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          child: PhotoView(
                                            imageProvider: NetworkImage(chapter['image']),
                                            minScale: PhotoViewComputedScale.contained,
                                            maxScale: PhotoViewComputedScale.covered,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(chapter['image'], fit: BoxFit.contain),
                                  )
                                : Placeholder(fallbackHeight: 100, fallbackWidth: double.infinity),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (_isBannerAdLoaded)
            Container(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }
}
