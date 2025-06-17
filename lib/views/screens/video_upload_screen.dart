import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/video_upload_viewmodel.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final _captionController = TextEditingController();
  final _videoLinkController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    _videoLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VideoUploadViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = kIsWeb && constraints.maxWidth > 600;
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 400 : double.infinity,
                ),
                child: Card(
                  elevation: isWide ? 8 : 0,
                  shape: isWide ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)) : null,
                  child: Padding(
                    padding: EdgeInsets.all(isWide ? 32 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _videoLinkController,
                          decoration: const InputDecoration(labelText: 'Video Link'),
                          enabled: !viewModel.isUploading,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _captionController,
                          decoration: const InputDecoration(labelText: 'Caption'),
                          enabled: !viewModel.isUploading,
                        ),
                        const SizedBox(height: 16),
                        if (viewModel.isUploading) LinearProgressIndicator(value: viewModel.uploadProgress),
                        if (viewModel.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(viewModel.error!, style: const TextStyle(color: Colors.red)),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: viewModel.isUploading
                              ? null
                              : () async {
                                  if (_videoLinkController.text.isNotEmpty && _captionController.text.isNotEmpty) {
                                    await viewModel.uploadVideo(_videoLinkController.text, _captionController.text);
                                    if (viewModel.error == null) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Upload complete!')),
                                        );
                                        Navigator.pop(context, true);
                                      }
                                    }
                                  }
                                },
                          child: const Text('Upload'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
