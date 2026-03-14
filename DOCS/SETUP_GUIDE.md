# Firebase Setup & Deployment Guide

Follow these steps to configure the backend for DataCaptureMVP.

## 1. Create Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add project** and name it `DataCaptureMVP`.
3. (Optional) Enable Google Analytics.

## 2. Enable Firebase Services

- **Authentication**: Enable `Anonymous` and `Email/Password` providers.
  - **Important**: You must manually add an admin user in the Firebase Console:
    1. Go to **Authentication** > **Users**.
    2. Click **Add user**.
    3. Enter an email (e.g., `admin@example.com`) and a strong password.
    4. Use these credentials to log in to the Web Admin Panel.
- **Firestore**: Create a database in `Production mode` or `Test mode`. Start with Test mode for initial development.
- **Storage**: Enable Firebase Storage to host images and videos.
- **Hosting**: Set up Firebase Hosting for the web admin panel.

## 3. Register Apps

### Android

1. Register your app with package name (e.g., `com.example.datacapture`).
2. Download `google-services.json` and place it in `android/app/`.

### iOS

1. Register your app with Bundle ID.
2. Download `GoogleService-Info.plist` and place it in `ios/Runner/`.

### Web (Admin Panel)

1. Add a Web App to your Firebase project.
2. Copy the `firebaseConfig` and use it to initialize Firebase in `lib/main.dart` or via `flutterfire configure`.

## 4. Environment Configuration

Install the FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## 5. Deployment

### Web Admin

```bash
flutter build web
firebase deploy --only hosting
```

### Mobile App

- **Android**: `flutter build apk --split-per-abi`
- **iOS**: `flutter build ios --release`
