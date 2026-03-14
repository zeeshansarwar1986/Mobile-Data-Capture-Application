import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../services/firebase_service.dart';
import '../models/upload_model.dart';
import 'package:uuid/uuid.dart';

class PreviewScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PreviewScreen({super.key, required this.data});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isUploading = false;

  Future<void> _upload() async {
    setState(() => _isUploading = true);
    final firebaseService = context.read<FirebaseService>();
    final XFile mediaFile = widget.data['mediaFile'];
    final Position? location = widget.data['location'];
    final String mediaType = widget.data['mediaType'];

    try {
      // 1. Sign in anonymously if not already
      final user = await firebaseService.signInAnonymously();
      if (user == null) throw 'Authentication failed';

      // 2. Upload Media to Storage
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${mediaFile.name}';
      final mediaUrl = await firebaseService.uploadMedia(File(mediaFile.path), fileName);
      if (mediaUrl == null) throw 'Media upload failed';

      // 3. Save Metadata to Firestore
      final uploadId = const Uuid().v4();
      final upload = UploadModel(
        id: uploadId,
        userId: user.uid,
        category: widget.data['category'],
        severity: widget.data['severity'],
        tags: widget.data['tags'],
        notes: widget.data['notes'],
        latitude: location?.latitude ?? 0.0,
        longitude: location?.longitude ?? 0.0,
        timestamp: widget.data['timestamp'],
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        deviceInfo: {'platform': Platform.operatingSystem}, // Simple info
      );

      final success = await firebaseService.saveUploadMetadata(upload);
      if (success) {
        context.pushReplacement('/success/$uploadId');
      } else {
        throw 'Failed to save metadata';
      }
    } catch (e) {
      final user = firebaseService.currentUser;
      final debugInfo = "User: ${user?.uid ?? 'Not Logged In'}, Error: $e";
      debugPrint("Upload Error Detailed: $debugInfo");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload Error: $debugInfo'),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final XFile mediaFile = widget.data['mediaFile'];
    final Position? location = widget.data['location'];

    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: _isUploading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Uploading data to Firebase...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 250,
                      child: widget.data['mediaType'] == 'image'
                          ? Image.file(File(mediaFile.path))
                          : const Icon(Icons.videocam, size: 150),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Category'),
                    subtitle: Text(widget.data['category']),
                  ),
                  ListTile(
                    title: const Text('Severity'),
                    subtitle: Text(widget.data['severity']),
                  ),
                  ListTile(
                    title: const Text('Tags'),
                    subtitle: Text(widget.data['tags'].join(', ')),
                  ),
                  ListTile(
                    title: const Text('Notes'),
                    subtitle: Text(widget.data['notes'].isEmpty ? 'N/A' : widget.data['notes']),
                  ),
                  ListTile(
                    title: const Text('Location'),
                    subtitle: Text(location != null
                        ? 'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}'
                        : 'No GPS data'),
                    trailing: const Icon(Icons.location_on, color: Colors.teal),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _upload,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirm & Upload'),
                  ),
                ],
              ),
            ),
    );
  }
}
