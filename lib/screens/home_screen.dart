import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataCaptureMVP'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/admin'),
            icon: const Icon(Icons.admin_panel_settings),
            label: const Text('Admin'),
            style: TextButton.styleFrom(foregroundColor: Colors.teal),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.camera_enhance_rounded, size: 120, color: Colors.teal),
            const SizedBox(height: 10),
            const Text(
              'Capture Field Data',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                'Capture photos and videos with real-time GPS and timestamp watermarking.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Spacer(),
            // The "Middle" Capture Option
            Center(
              child: GestureDetector(
                onTap: () => context.push('/capture'),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('TAP TO START', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/admin'),
              child: const Text('Go to Admin Panel', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
