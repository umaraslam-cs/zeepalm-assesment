import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/video_model.dart';
import '../../viewmodels/video_feed_viewmodel.dart';

class VideoCard extends StatefulWidget {
  final VideoModel video;
  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  final bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.url)
      ..initialize().then((_) {
        if (mounted) {
          _controller.setLooping(true);
          _controller.setVolume(1.0);
          setState(() {});
        }
      });

    // Add this listener to detect play/pause changes
    _controller.addListener(() {
      if (mounted) {
        setState(() {}); // triggers UI update for icon change
      }

      if (_controller.value.hasError) {
        debugPrint("Video error: ${_controller.value.errorDescription}");
      }
    });
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
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
                            icon: const Icon(
                              Icons.play_circle_fill,
                              size: 56,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              _controller.play();
                              setState(() {});
                            },
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
            Text(widget.video.caption, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: 'Like',
                  icon: Icon(
                    widget.video.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: widget.video.isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => viewModel.toggleLike(widget.video.id),
                ),
                IconButton(
                  tooltip: 'Save',
                  icon: Icon(
                    widget.video.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: widget.video.isSaved ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => viewModel.toggleSave(widget.video.id),
                ),
                IconButton(tooltip: 'Download', icon: const Icon(Icons.download), onPressed: null),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
