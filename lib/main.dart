import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes/app_routes.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/signup_viewmodel.dart';
import 'viewmodels/video_feed_viewmodel.dart';
import 'viewmodels/video_upload_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyBgOHARjKzbWpMf3YirCGAn3bgmhSspPas",
            authDomain: "zeepalm-assesment-44128.firebaseapp.com",
            projectId: "zeepalm-assesment-44128",
            storageBucket: "zeepalm-assesment-44128.firebasestorage.app",
            messagingSenderId: "964216613153",
            appId: "1:964216613153:web:f2fa7644c20a2e235f7660",
            measurementId: "G-HE6KWTX2J6", // optional for Analytics
          )
        : null,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => VideoFeedViewModel()),
        ChangeNotifierProvider(create: (_) => VideoUploadViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<bool> checkSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_logged_in') ?? false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return MaterialApp(
            title: 'ZeePalm',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: snapshot.data == true ? AppRoutes.videoFeed : AppRoutes.login,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        });
  }
}
