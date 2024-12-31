import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class Info extends StatelessWidget {
  const Info();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Komiku - Baca komik bahasa Indonesia adalah platform untuk membaca berbagai komik populer dan terbaru dalam bahasa Indonesia, menyediakan berbagai genre dan cerita menarik untuk para pecinta komik.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      final String appLink = 'https://play.google.com/store/apps/details?id=com.iasdev.komiku';
                      Clipboard.setData(ClipboardData(text: appLink));
                      final snackBar = SnackBar(
                        content: Text('Tautan aplikasi telah disalin!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    icon: Icon(Icons.content_copy),
                    label: Text('Bagikan Aplikasi'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Pengembang',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/developer.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fitri HY',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Fullstack Developer',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.apartment, size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      'I-As.Dev',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Image.asset('assets/wa.png', width: 25, height: 25),
                            onPressed: () {
                              final phoneNumber = '6281525977595';
                              final whatsappUrl = 'https://wa.me/$phoneNumber';
                              launchURL(whatsappUrl);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Hai, aku Fitri Herma Yanti (Fitri HY). Aku sangat antusias dalam pengembangan aplikasi dan web. Jika kamu memiliki proyek atau ide yang ingin dikembangkan, jangan ragu untuk berdiskusi denganku. Aku dan Tim siap membantu dan berbagi pengalaman dalam membangun solusi yang efektif dan berkualitas!',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 15),
                      _buildReference('Situs', 'https://i-as.dev'),
                      _buildReference('Dukungan & Kontak', 'mailto:noreply.orzpartners@gmail.com'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildReference(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        children: [
          Icon(Icons.link),
          Expanded(
            child: GestureDetector(
              onTap: () {
                launchURL(url);
              },
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
