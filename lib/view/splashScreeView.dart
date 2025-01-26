import 'package:chatgpt/widgets/splashLoader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homePageView.dart';

/// A splash screen displayed briefly before navigating to the main home screen.
class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  /// Navigates to the home screen after a delay
  _moveToHomeScreen() async {
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MainPage(),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    _moveToHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0d0d0d),
      body: Center(
        child: SplashLoader(),
      ),
    );
  }
}

/// The main page displayed after the splash screen, showing the home page view.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return HomePageView();
          }),
    );
  }
}
