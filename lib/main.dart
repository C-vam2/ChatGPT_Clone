import 'package:chatgpt/database/database.dart';
import 'package:chatgpt/providers/chatProvider.dart';
import 'package:chatgpt/providers/imageProvider.dart';

import 'package:chatgpt/providers/suggestionProvider.dart';
import 'package:chatgpt/view/homePageView.dart';
import 'package:chatgpt/view/signInView.dart';
import 'package:chatgpt/view/signUpView.dart';
import 'package:chatgpt/view/splashScreeView.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.black),
  );
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await MongoDB.connect();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('model') == null) {
    prefs.setString('model', 'gpt-4o-mini');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SuggestionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectImageProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white, primary: Colors.white),
          useMaterial3: true,
        ),
        home: SplashScreenView(),
      ),
    );
  }
}
