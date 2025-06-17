import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/video_model.dart';

class VideoFeedViewModel extends ChangeNotifier {
  List<VideoModel> _videos = [];

  List<VideoModel> get videos => _videos;

  Future<void> fetchVideos() async {
    final snapshot = await FirebaseFirestore.instance.collection('videos').orderBy('createdAt', descending: true).get();
    _videos = snapshot.docs.map((doc) => VideoModel.fromFirestore(doc.data(), doc.id)).toList();
    notifyListeners();
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
