import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/video_model.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/video_feed_viewmodel.dart';

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<VideoFeedViewModel>(context, listen: false).fetchVideos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.videoUpload);
        },
        tooltip: 'Upload Video',
        child: const Icon(Icons.upload),
      ),
      appBar: AppBar(title: const Text('Video Feed')),
      body: Consumer<VideoFeedViewModel>(
        builder: (context, viewModel, _) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: viewModel.videos.length,
            itemBuilder: (context, index) {
              final video = viewModel.videos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: VideoCard(video: video),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final VideoModel video;
  const VideoCard({required this.video, super.key});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VideoFeedViewModel>(context, listen: false);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.isInitialized ? _controller.value.aspectRatio : 16 / 9,
              child: _controller.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: VideoPlayer(_controller),
                        ),
                        if (!_controller.value.isPlaying)
                          IconButton(
                            icon: const Icon(Icons.play_circle_fill, size: 56, color: Colors.white70),
                            onPressed: () => setState(() => _controller.play()),
                          ),
                        if (_controller.value.isPlaying)
                          GestureDetector(
                            onTap: () => setState(() => _controller.pause()),
                            child: Container(color: Colors.transparent),
                          ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 16),
            Text(widget.video.caption, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    widget.video.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: widget.video.isLiked ? Colors.red : Colors.grey,
                  ),
                  tooltip: 'Like',
                  onPressed: () => viewModel.toggleLike(widget.video.id),
                ),
                IconButton(
                  icon: Icon(
                    widget.video.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: widget.video.isSaved ? Colors.blue : Colors.grey,
                  ),
                  tooltip: 'Save',
                  onPressed: () => viewModel.toggleSave(widget.video.id),
                ),
                IconButton(
                  icon: _isDownloading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  tooltip: 'Download',
                  onPressed: _isDownloading
                      ? null
                      : () async {
                          setState(() => _isDownloading = true);
                          await viewModel.downloadVideo(widget.video.url);
                          setState(() => _isDownloading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Download complete!')),
                          );
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
