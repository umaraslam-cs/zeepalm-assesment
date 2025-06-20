import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class VideoUploadViewModel extends ChangeNotifier {
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String? _error;

  double get uploadProgress => _uploadProgress;
  bool get isUploading => _isUploading;
  String? get error => _error;

  Future<File?> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> uploadVideo(String videoUrl, String caption) async {
    if (_isUploading) return; // Prevent multiple uploads

    _isUploading = true;
    _uploadProgress = 0.0;
    _error = null;
    notifyListeners();

    try {
      // Check if video with same URL already exists
      final existingVideos =
          await FirebaseFirestore.instance.collection('videos').where('url', isEqualTo: videoUrl).get();

      if (existingVideos.docs.isNotEmpty) {
        _error = 'This video has already been uploaded';
        _isUploading = false;
        notifyListeners();
        return;
      }

      // Add new video with server timestamp
      final docRef = await FirebaseFirestore.instance.collection('videos').add({
        'url': videoUrl,
        'caption': caption,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': FirebaseFirestore.instance.collection('users').doc().id, // Add user reference if needed
      });

      // Wait for the document to be created
      await docRef.get();

      _isUploading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isUploading = false;
      notifyListeners();
    }
  }
}
