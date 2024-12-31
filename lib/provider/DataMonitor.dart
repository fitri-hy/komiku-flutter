import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DataMonitor {
  static const String _apiUrl = 'https://api.i-as.dev/api/komiku/latest';
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? _timer;
  String? _lastTitle;

  void startMonitoring() {
    _timer = Timer.periodic(Duration(minutes: 30), (timer) async {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestTitle = data['latest'][0]['title'];

        if (_lastTitle != latestTitle) {
          _lastTitle = latestTitle;
          _showNotification(latestTitle);
        }
      }
    });
  }

  void _showNotification(String title) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.iasdev.komiku',
      'Komiku Updates',
      channelDescription: 'Saluran notifikasi untuk pembaruan Komiku',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    _notificationsPlugin.show(
      0,
      'Komiku Update',
      title,
      platformChannelSpecifics,
    );
  }
}
