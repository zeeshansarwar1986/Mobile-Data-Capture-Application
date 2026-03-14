import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/upload_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  // Auth: Anonymous sign in
  Future<User?> signInAnonymously() async {
    try {
      if (_auth.currentUser != null) return _auth.currentUser;
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      debugPrint('Firebase Auth Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Auth: Email/Password for Admin
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Firebase Login Error: $e');
      rethrow;
    }
  }

  // Storage: Upload file
  Future<String?> uploadMedia(File file, String fileName) async {
    try {
      if (!await file.exists()) throw 'File does not exist: ${file.path}';
      Reference ref = _storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Firebase Storage Error: $e');
      rethrow;
    }
  }

  // Storage: Upload bytes (for web)
  Future<String?> uploadMediaBytes(Uint8List bytes, String fileName) async {
    try {
      Reference ref = _storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = ref.putData(bytes);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Firebase Storage Error: $e');
      rethrow;
    }
  }

  // Firestore: Save metadata
  Future<bool> saveUploadMetadata(UploadModel upload) async {
    try {
      await _db.collection('uploads').doc(upload.id).set(upload.toMap());
      return true;
    } catch (e) {
      print('Firestore Save Error: $e');
      return false;
    }
  }

  // Firestore: Get uploads for Admin
  Stream<List<UploadModel>> getUploads() {
    return _db
        .collection('uploads')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UploadModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
