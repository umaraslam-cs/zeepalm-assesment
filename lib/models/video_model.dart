class VideoModel {
  final String id;
  final String url;
  final String caption;
  bool isLiked;
  bool isSaved;

  VideoModel({
    required this.id,
    required this.url,
    required this.caption,
    this.isLiked = false,
    this.isSaved = false,
  });

  factory VideoModel.fromFirestore(Map<String, dynamic> data, String id) {
    return VideoModel(
      id: id,
      url: data['url'] ?? '',
      caption: data['caption'] ?? '',
      // isLiked and isSaved are local UI state, not from Firestore
    );
  }
}
