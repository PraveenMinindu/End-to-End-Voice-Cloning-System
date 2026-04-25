import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/clone_job_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // Required for Firebase and async operations before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CloneJobProvider(),
      child: const VoiceCloneApp(),
    ),
  );
}

class VoiceCloneApp extends StatelessWidget {
  const VoiceCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceClone AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
      ),
      home: const HomeScreen(),
    );
  }
}
