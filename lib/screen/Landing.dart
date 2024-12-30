import 'package:flutter/material.dart';
import '../components/Carousel.dart';
import '../models/Komik.dart';
import 'Detail.dart';

class Landing extends StatelessWidget {
  const Landing();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Komik>>(
        future: fetchKomik(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat gambar, Silakan muat ulang halaman.'));
          } else {
            final komikList = snapshot.data!;
            final limitedKomikList = komikList.take(5).toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  CarouselComponent(apiUrl: 'https://api.i-as.dev/api/komiku/popular'),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Terbaru',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: limitedKomikList.length,
                    itemBuilder: (context, index) {
                      final komik = limitedKomikList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(slug: komik.slug),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.network(
                                    komik.image,
                                    height: 120,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          komik.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          komik.desc,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.visibility, color: Colors.grey, size: 14),
                                            SizedBox(width: 5),
                                            Text(
                                              '${komik.view}',
                                              style: TextStyle(color: Colors.grey, fontSize: 14),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}