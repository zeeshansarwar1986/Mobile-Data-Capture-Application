# 🛠️ ٹولز گائیڈ — Tools Introduction & Editing Guide

یہ دستاویز DataCaptureMVP میں استعمال ہونے والے تمام ٹولز/پیکیجز اور سروسز کا تفصیلی تعارف اور ان میں تبدیلی کرنے کا طریقہ بیان کرتی ہے۔

This document provides a detailed introduction to all tools/packages and services used in DataCaptureMVP, along with editing/customization instructions.

---

## 1. 🔥 Firebase Core (`firebase_core: ^3.10.1`)

### تعارف / Introduction
Firebase Core فائربیس کا بنیادی پیکیج ہے جو تمام Firebase سروسز کو شروع (initialize) کرنے کے لیے ضروری ہے۔  
Firebase Core is the foundational package required to initialize all Firebase services.

### فائل / File: `lib/main.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit

#### Firebase Configuration تبدیل کرنا
`lib/main.dart` میں Firebase options تبدیل کریں:
```dart
// لائن 23-30 میں اپنی Firebase config ڈالیں
FirebaseOptions(
  apiKey: "YOUR_NEW_API_KEY",           // ← اپنی API Key
  authDomain: "YOUR_PROJECT.firebaseapp.com",  // ← Auth Domain
  projectId: "YOUR_PROJECT_ID",         // ← Project ID
  storageBucket: "YOUR_BUCKET.firebasestorage.app",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID",
)
```

#### Google Services JSON تبدیل کرنا
اینڈرائیڈ کے لیے: `android/app/google-services.json` فائل کو نئی فائل سے بدلیں

---

## 2. 🔐 Firebase Auth (`firebase_auth: ^5.4.1`)

### تعارف / Introduction
صارفین کی توثیق (Authentication) کے لیے استعمال ہوتا ہے۔ دو طریقے:
- **Anonymous Login** — عام صارفین بغیر اکاؤنٹ کے لاگ ان کر سکتے ہیں
- **Email/Password** — ایڈمن لاگ ان کے لیے

Two methods: Anonymous login for regular users, Email/Password for admin users.

### فائلز / Files
- `lib/services/firebase_service.dart` — Authentication logic
- `lib/screens/admin_login_screen.dart` — Admin login UI
- `lib/screens/preview_screen.dart` — Anonymous sign-in on upload

### ایڈٹ کرنے کا طریقہ / How to Edit

#### نیا ایڈمن یوزر بنانا
Firebase Console > Authentication > Users > Add User

#### لاگ ان طریقہ تبدیل کرنا
`lib/services/firebase_service.dart` میں:
```dart
// Anonymous login کو disable کرنا:
// signInAnonymously() فنکشن کو تبدیل کریں

// Google Sign-In شامل کرنا:
// google_sign_in پیکیج شامل کریں pubspec.yaml میں
// نیا فنکشن بنائیں:
Future<User?> signInWithGoogle() async {
  // Google sign-in logic
}
```

#### ایڈمن لاگ ان UI تبدیل کرنا
`lib/screens/admin_login_screen.dart` میں:
- فیلڈز شامل/ہٹائیں (`_emailController`, `_passwordController`)
- بٹن کا ڈیزائن تبدیل کریں

---

## 3. 💾 Cloud Firestore (`cloud_firestore: ^5.6.1`)

### تعارف / Introduction
NoSQL ڈیٹا بیس جو اپلوڈ کا میٹا ڈیٹا محفوظ کرتا ہے (زمرہ، شدت، ٹیگز، نوٹس، GPS مقام، ٹائم اسٹیمپ وغیرہ)۔  
NoSQL database storing upload metadata (category, severity, tags, notes, GPS, timestamp, etc.).

### فائلز / Files
- `lib/services/firebase_service.dart` — Save/fetch operations
- `lib/models/upload_model.dart` — Data model

### ایڈٹ کرنے کا طریقہ / How to Edit

#### نئی فیلڈ شامل کرنا (مثلاً "Priority")
1. **ماڈل** `lib/models/upload_model.dart` میں:
```dart
class UploadModel {
  // ... موجودہ فیلڈز
  final String priority;  // ← نئی فیلڈ

  // Constructor میں شامل کریں:
  required this.priority,

  // toMap() میں شامل کریں:
  'priority': priority,

  // fromMap() میں شامل کریں:
  priority: map['priority'] ?? 'Normal',
}
```

2. **کیپچر سکرین** `lib/screens/capture_screen.dart` میں UI شامل کریں
3. **پریویو سکرین** `lib/screens/preview_screen.dart` میں ڈسپلے کریں

#### کلیکشن کا نام تبدیل کرنا
`firebase_service.dart` میں `'uploads'` کو اپنی مرضی کا نام دیں:
```dart
await _db.collection('YOUR_COLLECTION_NAME').doc(upload.id).set(upload.toMap());
```

---

## 4. 📦 Firebase Storage (`firebase_storage: ^12.4.10`)

### تعارف / Introduction
فوٹوز اور ویڈیوز کلاؤڈ پر محفوظ کرنے کے لیے۔ فائلز Firebase Storage میں اپلوڈ ہوتی ہیں اور ڈاؤنلوڈ URL ملتا ہے۔  
Cloud storage for photos and videos. Files are uploaded and a download URL is generated.

### فائل / File: `lib/services/firebase_service.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit

#### اسٹوریج پاتھ تبدیل کرنا
```dart
// موجودہ: 'uploads/$fileName'
// تبدیل کریں:
Reference ref = _storage.ref().child('YOUR_FOLDER/$fileName');
```

#### فائل سائز لمٹ شامل کرنا
`firebase_service.dart` میں `uploadMedia` فنکشن میں:
```dart
Future<String?> uploadMedia(File file, String fileName) async {
  // فائل سائز چیک  (مثلاً 10MB)
  final fileSize = await file.length();
  if (fileSize > 10 * 1024 * 1024) {
    throw 'فائل بہت بڑی ہے (10MB سے زیادہ)';
  }
  // ... باقی کوڈ
}
```

---

## 5. 📸 Image Picker (`image_picker: ^1.1.2`)

### تعارف / Introduction
کیمرہ اور گیلری سے فوٹو اور ویڈیو لینے کے لیے۔  
Access camera and gallery for taking photos and videos.

### فائلز / Files
- `lib/services/media_service.dart` — Camera/gallery logic
- `lib/screens/capture_screen.dart` — UI triggers

### ایڈٹ کرنے کا طریقہ / How to Edit

#### تصویر کی کوالٹی تبدیل کرنا
`lib/services/media_service.dart` میں:
```dart
Future<XFile?> pickImage(ImageSource source) async {
  return await _picker.pickImage(
    source: source,
    imageQuality: 100,     // ← 80 سے 100 تبدیل (زیادہ کوالٹی)
    maxWidth: 1920,        // ← زیادہ سے زیادہ چوڑائی شامل کریں
    maxHeight: 1080,       // ← زیادہ سے زیادہ اونچائی شامل کریں
  );
}
```

#### ویڈیو کی مدت تبدیل کرنا
```dart
Future<XFile?> pickVideo(ImageSource source) async {
  return await _picker.pickVideo(
    source: source,
    maxDuration: const Duration(seconds: 60),  // ← 30 سے 60 سیکنڈ
  );
}
```

#### گیلری سے بھی اجازت دینا
`capture_screen.dart` میں نیا بٹن شامل کریں:
```dart
FloatingActionButton(
  onPressed: () async {
    final file = await mediaService.pickImage(ImageSource.gallery);
    // ...
  },
  child: const Icon(Icons.photo_library),
),
```

---

## 6. 📍 Geolocator (`geolocator: ^13.0.2`)

### تعارف / Introduction
GPS لوکیشن حاصل کرنے کے لیے۔ عرض البلد (Latitude) اور طول البلد (Longitude) ریکارڈ کرتا ہے۔  
Gets GPS location coordinates (latitude and longitude) from the device.

### فائل / File: `lib/services/location_service.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit

#### لوکیشن کی درستگی تبدیل کرنا
```dart
return await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.best,  // ← high سے best تبدیل
);
```

#### مسلسل لوکیشن ٹریکنگ شامل کرنا
```dart
// نیا فنکشن شامل کریں:
Stream<Position> getLocationStream() {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // ہر 10 میٹر پر اپڈیٹ
    ),
  );
}
```

#### ٹائم آؤٹ شامل کرنا
```dart
return await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
  timeLimit: const Duration(seconds: 15),  // ← 15 سیکنڈ ٹائم آؤٹ
);
```

---

## 7. 🔖 Watermark Kit (`watermark_kit: ^2.2.0`) + Image (`image: ^4.3.0`)

### تعارف / Introduction
تصاویر اور ویڈیوز پر GPS اور ٹائم اسٹیمپ واٹر مارک لگانے کے لیے۔ تصاویر کے لیے `image` پیکیج اور ویڈیوز کے لیے `watermark_kit` استعمال ہوتا ہے۔  
Adds GPS + timestamp watermarks on photos (using `image` package) and videos (using `watermark_kit`).

### فائل / File: `lib/services/watermark_service.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit

#### واٹر مارک ٹیکسٹ تبدیل کرنا
```dart
// تصاویر کے لیے (لائن 18):
final text = 'مقام: $lat, $lng\nوقت: $timestamp';  // ← اردو ٹیکسٹ

// ویڈیوز کے لیے (لائن 44):
final text = 'Location: $lat, $lng | Time: $timestamp | Company: XYZ';
```

#### واٹر مارک کی پوزیشن تبدیل کرنا (تصاویر)
```dart
img.drawString(
  image,
  text,
  font: img.arial24,
  x: 20,                    // ← بائیں سے فاصلہ
  y: 20,                    // ← اوپر سے فاصلہ (نیچے سے اوپر منتقل)
  color: img.ColorRgb8(255, 255, 0),  // ← رنگ: پیلا
);
```

#### واٹر مارک کی پوزیشن تبدیل کرنا (ویڈیوز)
```dart
final task = await _watermarker.composeVideo(
  inputVideoPath: videoFile.path,
  text: text,
  anchor: 'topRight',        // ← bottomLeft سے topRight میں تبدیل
  margin: 30.0,              // ← مارجن بڑھائیں
  widthPercent: 0.5,         // ← واٹر مارک کی چوڑائی
  opacity: 0.7,              // ← شفافیت (0.9 سے 0.7)
);
```

---

## 8. 🧭 GoRouter (`go_router: ^14.6.3`)

### تعارف / Introduction
ایپ میں نیویگیشن/راؤٹنگ کے لیے۔ ہر سکرین کا الگ URL/path ہوتا ہے۔  
Declarative routing for navigation. Each screen has its own URL path.

### فائل / File: `lib/main.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit

#### نئی سکرین/راؤٹ شامل کرنا
```dart
// main.dart میں routes لسٹ میں شامل کریں:
GoRoute(
  path: '/settings',
  builder: (context, state) => const SettingsScreen(),
),
```

#### سکرین پر جانا (کسی بھی سکرین سے)
```dart
context.push('/settings');  // نئی سکرین پر جائیں
context.go('/');            // ہوم پر واپس (ہسٹری صاف)
```

---

## 9. 🔄 Provider (`provider: ^6.1.2`)

### تعارف / Introduction
اسٹیٹ مینجمنٹ کے لیے۔ سروسز (Firebase, Location, Media, Watermark) کو پوری ایپ میں فراہم کرتا ہے۔  
State management that provides services throughout the entire app.

### فائل / File: `lib/main.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit

#### نئی سروس شامل کرنا
```dart
// main.dart میں MultiProvider میں شامل کریں:
MultiProvider(
  providers: [
    Provider(create: (_) => FirebaseService()),
    Provider(create: (_) => LocationService()),
    Provider(create: (_) => MediaService()),
    Provider(create: (_) => WatermarkService()),
    Provider(create: (_) => YourNewService()),  // ← نئی سروس
  ],
  child: const DataCaptureApp(),
),
```

#### سروس استعمال کرنا (کسی بھی سکرین میں)
```dart
final myService = context.read<YourNewService>();
// یا real-time اپڈیٹس کے لیے:
final myService = context.watch<YourNewService>();
```

---

## 10. 🌐 URL Launcher (`url_launcher: ^6.3.1`)

### تعارف / Introduction
بیرونی URLs کھولنے کے لیے — Google Maps لنکس اور میڈیا ڈاؤنلوڈ لنکس۔  
Opens external URLs — Google Maps links and media download links.

### فائل / File: `lib/screens/admin_dashboard_screen.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit

#### نقشے کا لنک تبدیل کرنا
```dart
void _openInMaps(double lat, double lng) async {
  // Google Maps کی بجائے OpenStreetMap استعمال کریں:
  final url = 'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng&zoom=15';
  await launchUrl(Uri.parse(url));
}
```

---

## 11. 🗺️ Google Maps Flutter (`google_maps_flutter: ^2.10.0`)

### تعارف / Introduction
ایپ کے اندر نقشہ دکھانے کے لیے (فی الحال unused لیکن pubspec.yaml میں شامل ہے)۔  
In-app map display (currently in pubspec.yaml but can be implemented).

### ایڈٹ کرنے کا طریقہ / How to Edit

#### نقشہ سکرین بنانا
```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 15,
  ),
  markers: {
    Marker(markerId: const MarkerId('capture'), position: LatLng(lat, lng)),
  },
),
```

---

## 12. 📅 Intl (`intl: ^0.19.0`)

### تعارف / Introduction
تاریخ اور وقت کی فارمیٹنگ کے لیے۔  
Date and time formatting.

### فائل / File: `lib/services/watermark_service.dart`, `lib/screens/admin_dashboard_screen.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit
```dart
// فارمیٹ تبدیل کریں / Change format:
DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());  // 15/03/2026 02:30 AM
DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());  // Sunday, March 15, 2026
```

---

## 13. 📁 Path Provider (`path_provider: ^2.1.5`)

### تعارف / Introduction
عارضی (temporary) اور مستقل (persistent) فائل پاتھ حاصل کرنے کے لیے۔  
Get temporary and persistent file paths for saving files.

### فائل / File: `lib/services/watermark_service.dart`

### ایڈٹ کرنے کا طریقہ / How to Edit
```dart
// عارضی ڈائریکٹری:
final tempDir = await getTemporaryDirectory();

// مستقل ڈائریکٹری:
final appDir = await getApplicationDocumentsDirectory();
```

---

## 📝 تبدیلیاں / Changes Log

| # | تبدیلی / Change | فائل / File | تفصیل / Details |
|---|---|---|---|
| 1 | نئی دستاویزات بنائی گئیں | `DOCS/PROJECT_DESCRIPTION.md` | مکمل اردو/انگریزی پروجیکٹ کی تفصیل |
| 2 | ٹولز گائیڈ بنائی گئی | `DOCS/TOOLS_GUIDE.md` | تمام ٹولز کا تعارف اور ایڈٹنگ گائیڈ |
| 3 | ویب پریویو | `DOCS/ASSETS/` | لوکل ہوسٹ پر ویو |

---

> **نوٹ / Note**: کسی بھی پیکیج کو اپڈیٹ کرنے کے بعد `flutter pub get` ضرور چلائیں۔  
> After updating any package, always run `flutter pub get`.
