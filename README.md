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
keytool -genkeypair -v -keystore komiku-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -storepass 220898 -keypass 220898 -alias komiku
```

## Changing Package Name

```
flutter pub global activate rename
flutter pub global run rename --bundleId com.example.newname
```

## Build & Release

```
flutter build apk --release
flutter build appbundle
```
<div style="display: flex; flex-wrap: wrap;">
  <img src="./assets/1" alt="ss1" width="200"/>
  <img src="./assets/2" alt="ss2" width="200"/>
  <img src="./assets/3" alt="ss3" width="200"/>
  <img src="./assets/4" alt="ss4" width="200"/>
  <img src="./assets/5" alt="ss4" width="200"/>
  <img src="./assets/6" alt="ss4" width="200"/>
  <img src="./assets/7" alt="ss4" width="200"/>
</div>
