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

## AdMob Settings

- **Application ID** in `android/app/src/main/AndroidManifest.xml` 

```
<meta-data
  android:name="com.google.android.gms.ads.APPLICATION_ID"
  android:value="ca-app-pub-xxxxxxxxxxxxxxxxxxxx" />
```

- **Banner Unit ID** in `lib/provider/AdMobConfig.dart`

```
class AdMobConfig {
  static const String adBannerUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxxxxxx';
}
```

<img src="./assets/ss/ss.png" alt="ss"/>