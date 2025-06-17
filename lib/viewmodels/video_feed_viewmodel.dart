import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/video_model.dart';

class VideoFeedViewModel extends ChangeNotifier {
  List<VideoModel> _videos = [];
  bool _isLoading = false;

  List<VideoModel> get videos => _videos;
  bool get isLoading => _isLoading;

  Future<void> fetchVideos() async {
    if (_isLoading) return; // Prevent multiple simultaneous fetches

    _isLoading = true;
    notifyListeners();

    try {
      // Clear existing videos
      _videos.clear();

      // Fetch videos with proper ordering
      final snapshot =
          await FirebaseFirestore.instance.collection('videos').orderBy('createdAt', descending: true).get();

      // Convert to VideoModel objects
      _videos = snapshot.docs.map((doc) {
        final data = doc.data();
        return VideoModel.fromFirestore(data, doc.id);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching videos: $e');
    }
  }

  void toggleLike(String id) {
    final video = _videos.firstWhere((v) => v.id == id);
    video.isLiked = !video.isLiked;
    notifyListeners();
  }

  void toggleSave(String id) {
    final video = _videos.firstWhere((v) => v.id == id);
    video.isSaved = !video.isSaved;
    notifyListeners();
  }

  Future<void> downloadVideo(String url) async {
    // TODO: Implement download logic
    // For now, just simulate a download
    await Future.delayed(const Duration(seconds: 1));
  }
}
