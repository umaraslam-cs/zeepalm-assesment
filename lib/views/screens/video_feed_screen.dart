import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';
import '../../viewmodels/video_feed_viewmodel.dart';
import '../widgets/video_card.dart';

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch videos after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VideoFeedViewModel>().fetchVideos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AppRoutes.videoUpload);
          if (result == true && mounted) {
            // Refresh videos after successful upload
            await context.read<VideoFeedViewModel>().fetchVideos();
          }
        },
        tooltip: 'Upload Video',
        child: const Icon(Icons.upload),
      ),
      appBar: AppBar(
        title: const Text('Video Feed'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = kIsWeb && constraints.maxWidth > 800;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWide ? 600 : double.infinity,
              ),
              child: Consumer<VideoFeedViewModel>(
                builder: (context, viewModel, _) {
                  if (viewModel.isLoading && viewModel.videos.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.videos.isEmpty) {
                    return const Center(
                      child: Text('No videos available. Upload one!'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => viewModel.fetchVideos(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: viewModel.videos.length,
                      itemBuilder: (context, index) {
                        final video = viewModel.videos[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: VideoCard(video: video),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }
}
