import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/preview_screen.dart';
import 'screens/success_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'services/firebase_service.dart';
import 'services/location_service.dart';
import 'services/media_service.dart';
import 'services/watermark_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyD9L7EkyHUdJv-Xuc7zPJ2znb6-VVCcaTM",
          authDomain: "datacapturemvp.firebaseapp.com",
          projectId: "datacapturemvp",
          storageBucket: "datacapturemvp.firebasestorage.app",
          messagingSenderId: "256763948890",
          appId: "1:256763948890:web:e481a4547ded1888de4d63",
          measurementId: "G-XT3974KB1G",
        ),
      );
    } else {
      // On Android/iOS, using the platform-specific configuration files (google-services.json)
      // is the most stable way to initialize Firebase.
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseService()),
        Provider(create: (_) => LocationService()),
        Provider(create: (_) => MediaService()),
        Provider(create: (_) => WatermarkService()),
      ],
      child: const DataCaptureApp(),
    ),
  );
}

class DataCaptureApp extends StatelessWidget {
  const DataCaptureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DataCaptureMVP',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Mobile Routes
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/capture',
      builder: (context, state) => const CaptureScreen(),
    ),
    GoRoute(
      path: '/preview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PreviewScreen(data: extra);
      },
    ),
    GoRoute(
      path: '/success/:id',
      builder: (context, state) => SuccessScreen(id: state.pathParameters['id']!),
    ),
    // Admin Routes
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
