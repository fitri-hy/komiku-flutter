# Komiku Flutter

Komiku - Read Indonesian comics is a platform for reading various popular and newest comics in Indonesian, providing various genres and interesting stories for comic lovers. 

## Development Tools

- Flutter 3.27.1
- Tools • Dart 3.6.0 • DevTools 2.40.2

## Run Program

- `git clone https://github.com/fitri-hy/komiku-flutter.git`
- `cd komiku-flutter`
- `flutter pub get`
- `flutter run`

## Generates Keystore

```
keytool -genkeypair -v -keystore komiku-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -storepass 123456 -keypass 123456 -alias komiku
```

## Build & Release

```
flutter build apk --release
flutter build appbundle
```
<div style="display: flex; flex-wrap: wrap;">
  <img src="./assets/ss/1.png" alt="ss1" width="200"/>
  <img src="./assets/ss/2.png" alt="ss2" width="200"/>
  <img src="./assets/ss/3.png" alt="ss3" width="200"/>
  <img src="./assets/ss/4.png" alt="ss4" width="200"/>
  <img src="./assets/ss/5.png" alt="ss4" width="200"/>
  <img src="./assets/ss/6.png" alt="ss4" width="200"/>
  <img src="./assets/ss/7.png" alt="ss4" width="200"/>
  <img src="./assets/ss/8.png" alt="ss4" width="200"/>
</div>
