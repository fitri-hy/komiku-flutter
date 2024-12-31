import 'dart:math';
import 'package:flutter/material.dart';
import '../components/Carousel.dart';
import '../models/Komik.dart';
import 'Detail.dart';

class Landing extends StatelessWidget {
  const Landing();

  Future<List<Komik>> fetchRandomKomik(List<Komik> komikList) async {
    List<Komik> shuffledList = List.from(komikList);
    shuffledList.shuffle(Random());
    return shuffledList.take(5).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Komik>>(
        future: fetchKomik(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gagal mendapatkan data!'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      fetchKomik();
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
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
                                  ClipRRect(
								    borderRadius: BorderRadius.circular(5),
								    child: Image.network(
								      komik.image,
								      height: 120,
								      width: 90,
								      fit: BoxFit.cover,
								      errorBuilder: (context, error, stackTrace) {
								        return Icon(
								          Icons.image_not_supported,
								          size: 120,
								          color: Colors.grey,
								        );
								      },
								    ),
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
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Populer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  FutureBuilder<List<Komik>>(
                    future: fetchRandomKomik(komikList),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Gagal mendapatkan data acak!'),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  fetchRandomKomik(komikList);
                                },
                                child: Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final randomKomikList = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: randomKomikList.length,
                          itemBuilder: (context, index) {
                            final komik = randomKomikList[index];
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
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Image.network(
                                            komik.image,
                                            height: 120,
                                            width: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.image_not_supported,
                                                size: 120,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
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
                        );
                      } else {
                        return Center(
                          child: Text('Tidak ada data acak!'),
                        );
                      }
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
