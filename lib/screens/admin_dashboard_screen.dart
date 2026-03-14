import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../services/firebase_service.dart';
import '../models/upload_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _categoryFilter = 'All';
  String _severityFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final firebaseService = context.watch<FirebaseService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await firebaseService.signOut();
              if (mounted) {
                // Using go for GoRouter, but adding a fallback just in case
                context.go('/');
                // Fallback for safety
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
                });
              }
            },
            icon: const Icon(Icons.logout), // Changed to logout icon for clarity
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: StreamBuilder<List<UploadModel>>(
              stream: firebaseService.getUploads(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No uploads found.'));
                }

                var uploads = snapshot.data!;
                if (_categoryFilter != 'All') {
                  uploads = uploads.where((u) => u.category == _categoryFilter).toList();
                }
                if (_severityFilter != 'All') {
                  uploads = uploads.where((u) => u.severity == _severityFilter).toList();
                }

                return ListView.builder(
                  itemCount: uploads.length,
                  itemBuilder: (context, index) {
                    final upload = uploads[index];
                    return _buildUploadCard(upload);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _categoryFilter,
              items: ['All', 'Incident', 'Observation', 'Maintenance', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _categoryFilter = val!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _severityFilter,
              items: ['All', 'Low', 'Medium', 'High']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _severityFilter = val!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(UploadModel upload) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ExpansionTile(
        leading: upload.mediaType == 'image'
            ? Image.network(upload.mediaUrl, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.videocam),
        title: Text('${upload.category} - ${upload.severity}'),
        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(upload.timestamp)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tags: ${upload.tags.join(", ")}'),
                Text('Notes: ${upload.notes}'),
                Text('Location: ${upload.latitude}, ${upload.longitude}'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => _openInMaps(upload.latitude, upload.longitude),
                      icon: const Icon(Icons.map),
                      label: const Text('View on Map'),
                    ),
                    TextButton.icon(
                      onPressed: () => _downloadMedia(upload.mediaUrl),
                      icon: const Icon(Icons.download),
                      label: const Text('Download Media'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openInMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _downloadMedia(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
