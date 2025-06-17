import 'package:flutter/material.dart';

import '../views/screens/login_screen.dart';
import '../views/screens/signup_screen.dart';
import '../views/screens/video_feed_screen.dart';
import '../views/screens/video_upload_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String videoFeed = '/video-feed';
  static const String videoUpload = '/video-upload';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case videoFeed:
        return MaterialPageRoute(builder: (_) => VideoFeedScreen());
      case videoUpload:
        return MaterialPageRoute(builder: (_) => VideoUploadScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
