import 'package:cloud_firestore/cloud_firestore.dart';

class UploadModel {
  final String id;
  final String userId;
  final String category;
  final String severity;
  final List<String> tags;
  final String notes;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String mediaUrl;
  final String mediaType; // 'image' or 'video'
  final Map<String, dynamic> deviceInfo;

  UploadModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.severity,
    required this.tags,
    required this.notes,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.mediaUrl,
    required this.mediaType,
    required this.deviceInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'severity': severity,
      'tags': tags,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'deviceInfo': deviceInfo,
    };
  }

  factory UploadModel.fromMap(Map<String, dynamic> map, String id) {
    return UploadModel(
      id: id,
      userId: map['userId'] ?? '',
      category: map['category'] ?? 'Other',
      severity: map['severity'] ?? 'Low',
      tags: List<String>.from(map['tags'] ?? []),
      notes: map['notes'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      mediaUrl: map['mediaUrl'] ?? '',
      mediaType: map['mediaType'] ?? 'image',
      deviceInfo: Map<String, dynamic>.from(map['deviceInfo'] ?? {}),
    );
  }
}
