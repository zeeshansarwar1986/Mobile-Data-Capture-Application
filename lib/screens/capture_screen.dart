import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../services/media_service.dart';
import '../services/location_service.dart';
import '../services/watermark_service.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _mediaFile;
  String _mediaType = 'image';
  String _category = 'Observation';
  String _severity = 'Low';
  final List<String> _tags = [];
  final TextEditingController _notesController = TextEditingController();
  Position? _currentPosition;
  bool _isLoading = false;
  String _loadingMessage = '';

  final List<String> _categories = ['Incident', 'Observation', 'Maintenance', 'Other'];
  final List<String> _severities = ['Low', 'Medium', 'High'];
  final List<String> _availableTags = ['Safety', 'Environment', 'Equipment', 'Personnel'];

  Future<void> _captureMedia(bool isVideo) async {
    final mediaService = context.read<MediaService>();
    final locationService = context.read<LocationService>();
    final watermarkService = context.read<WatermarkService>();

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Getting Location...';
    });

    try {
      // 1. Get Location First (Real-time)
      final position = await locationService.getCurrentLocation();
      _currentPosition = position;

      // 2. Capture Media
      setState(() => _loadingMessage = isVideo ? 'Recording Video...' : 'Taking Photo...');
      XFile? file;
      if (isVideo) {
        file = await mediaService.pickVideo(ImageSource.camera);
        _mediaType = 'video';
      } else {
        file = await mediaService.pickImage(ImageSource.camera);
        _mediaType = 'image';
      }

      if (file != null && position != null) {
        // 3. Apply Watermark
        setState(() => _loadingMessage = 'Applying Watermark...');
        File? watermarkedFile;
        if (isVideo) {
          watermarkedFile = await watermarkService.watermarkVideo(
            File(file.path),
            position.latitude,
            position.longitude,
          );
        } else {
          watermarkedFile = await watermarkService.watermarkImage(
            File(file.path),
            position.latitude,
            position.longitude,
          );
        }

        if (watermarkedFile != null) {
          setState(() {
            _mediaFile = XFile(watermarkedFile!.path);
          });
        } else {
          setState(() => _mediaFile = file); // Fallback to original
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });
    }
  }

  void _onNext() {
    if (_mediaFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture an image or video first.')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.push('/preview', extra: {
        'mediaFile': _mediaFile,
        'mediaType': _mediaType,
        'category': _category,
        'severity': _severity,
        'tags': _tags,
        'notes': _notesController.text,
        'location': _currentPosition,
        'timestamp': DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Data')),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(_loadingMessage),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_mediaFile != null)
                      SizedBox(
                        height: 200,
                        child: _mediaType == 'image'
                            ? Image.file(File(_mediaFile!.path), fit: BoxFit.cover)
                            : const Center(child: Icon(Icons.videocam, size: 100)),
                      )
                    else
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(child: Text('Capture photo or video to begin')),
                      ),
                    const SizedBox(height: 20),
                    // Centered Capture Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: FloatingActionButton(
                            onPressed: () => _captureMedia(false),
                            heroTag: 'photo',
                            backgroundColor: Colors.teal,
                            child: const Icon(Icons.camera_alt),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Transform.scale(
                          scale: 1.2,
                          child: FloatingActionButton(
                            onPressed: () => _captureMedia(true),
                            heroTag: 'video',
                            backgroundColor: Colors.redAccent,
                            child: const Icon(Icons.videocam),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _category = val!),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _severity,
                      decoration: const InputDecoration(labelText: 'Severity', border: OutlineInputBorder()),
                      items: _severities.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setState(() => _severity = val!),
                    ),
                    const SizedBox(height: 15),
                    const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: _availableTags.map((tag) {
                        return FilterChip(
                          label: Text(tag),
                          selected: _tags.contains(tag),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) _tags.add(tag);
                              else _tags.remove(tag);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _notesController,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _onNext,
                      icon: const Icon(Icons.preview),
                      label: const Text('PROCEED TO PREVIEW'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}
