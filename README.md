# DataCaptureMVP - Mobile Data Capture Application

A Flutter-based mobile application for capturing photos and videos with GPS location tagging, categorization, and metadata management. Designed for field data collection, incident reporting, and observation tracking.

## 🎯 Features

- 📸 **Media Capture**: Take photos and videos with camera or select from gallery
- 📍 **GPS Location**: Automatic location tagging with coordinates
- 🏷️ **Categorization**: Organize captures by Category and Severity
- 🔖 **Tags & Notes**: Add custom tags and detailed notes
- ⏰ **Timestamps**: Automatic date and time recording
- 👤 **User Authentication**: Anonymous login for users, Email/Password for admin
- 📊 **Admin Dashboard**: View, filter, and manage all uploads
- 🗺️ **Map Integration**: View capture locations on Google Maps
- ⬇️ **Media Download**: Download captured media files

## 📱 Screenshots

| Home Screen | Capture Screen | Admin Dashboard |
|:---:|:---:|:---:|
| ![Home](DOCS/ASSETS/screenshot_home.png) | ![Capture](DOCS/ASSETS/screenshot_capture.png) | ![Admin](DOCS/ASSETS/screenshot_admin.png) |

## 🛠️ Technology Stack

- **Framework**: Flutter
- **Backend**: Firebase
  - Authentication (Anonymous + Email/Password)
  - Firestore (Database)
  - Storage (Media files)
- **Packages**:
  - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
  - `image_picker` - Camera and gallery access
  - `geolocator` - GPS location services
  - `provider` - State management
  - `go_router` - Navigation
  - `watermark_kit` - Image watermarking
  - `intl` - Date formatting
  - `uuid` - Unique ID generation

## 📋 Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase account
- Android device or emulator

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/DataCaptureMVP.git
cd DataCaptureMVP
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project: `DataCaptureMVP`
3. Enable Authentication (Anonymous + Email/Password)
4. Create Firestore Database
5. Enable Firebase Storage

#### Configure Android App

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`
3. Update `android/app/build.gradle` with your package name

#### Firebase Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /uploads/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. Update Firebase Configuration

Edit `lib/main.dart` and update Firebase options if needed (for web):

```dart
FirebaseOptions(
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID",
)
```

### 5. Run the App

```bash
flutter run
```

## 📦 Build APK

### Debug APK

```bash
flutter build apk --debug
```

### Release APK

```bash
flutter build apk --release
```

APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## 🔧 Configuration

### Admin Credentials

Create an admin user in Firebase Authentication:

- Email: `admin@datacapture.com`
- Password: `admin123` (change this!)

### Permissions (AndroidManifest.xml)

The following permissions are required:

- `INTERNET` - Network access
- `ACCESS_FINE_LOCATION` - GPS location
- `ACCESS_COARSE_LOCATION` - Network-based location
- `CAMERA` - Camera access
- `READ_EXTERNAL_STORAGE` - Gallery access
- `WRITE_EXTERNAL_STORAGE` - File storage

## 📖 Usage

### Mobile App (Regular Users)

1. Open the app
2. Tap camera button to capture media
3. Fill in the form:
   - Category: Incident, Observation, Maintenance, Other
   - Severity: Low, Medium, High
   - Tags: Custom keywords
   - Notes: Additional description
4. Tap "Confirm & Upload"
5. View success confirmation

### Admin Panel

1. Navigate to Admin Login
2. Enter admin credentials
3. View all uploads with filters
4. Click on any upload to view details
5. Use "View on Map" or "Download Media" options

## 🐛 Known Issues

### Firebase Storage Error

**Error**: `[firebase_storage/object-not-found]`

**Cause**: Firebase Storage requires Blaze Plan (Pay-as-you-go)

**Solutions**:

1. Upgrade to Blaze Plan (free tier: 5GB storage)
2. Modify Storage Rules for testing
3. Implement alternative storage (Local/ImgBB/Supabase)

See `DOCS/alternative_storage_plan.md` for details.

## 📁 Project Structure

```
DataCaptureMVP/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── upload_model.dart     # Data model
│   ├── screens/
│   │   ├── capture_screen.dart   # Media capture
│   │   ├── preview_screen.dart   # Upload preview
│   │   ├── success_screen.dart   # Success message
│   │   ├── admin_login_screen.dart
│   │   └── admin_dashboard_screen.dart
│   └── services/
│       ├── firebase_service.dart # Firebase operations
│       ├── media_service.dart    # Camera/Gallery
│       ├── location_service.dart # GPS
│       └── watermark_service.dart
├── android/
│   └── app/
│       ├── google-services.json  # Firebase config
│       └── src/main/AndroidManifest.xml
├── assets/
│   └── logo.png                  # App icon
└── pubspec.yaml                  # Dependencies
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Zeeshan**

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and users

## 📞 Support

For issues and questions:

- Create an issue on GitHub
- Email: [your-email@example.com]

---

**Note**: This is an MVP (Minimum Viable Product). For production use, implement proper security rules, error handling, and user authentication.
