import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/video_upload_viewmodel.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _selectedFile;
  final _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VideoUploadViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: viewModel.isUploading
                  ? null
                  : () async {
                      final file = await viewModel.pickVideo();
                      if (file != null) {
                        setState(() {
                          _selectedFile = file;
                        });
                      }
                    },
              child: Text(_selectedFile == null ? 'Select Video' : 'Change Video'),
            ),
            if (_selectedFile != null) ...[
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
              ElevatedButton(
                onPressed: viewModel.isUploading
                    ? null
                    : () async {
                        if (_selectedFile != null && _captionController.text.isNotEmpty) {
                          await viewModel.uploadVideo(_selectedFile!, _captionController.text);
                          if (viewModel.error == null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Upload complete!')),
                              );
                              setState(() {
                                _selectedFile = null;
                                _captionController.clear();
                              });
                            }
                          }
                        }
                      },
                child: const Text('Upload'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
