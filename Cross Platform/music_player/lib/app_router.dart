import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/constants/strings.dart';
import 'package:music_player/data/model/user_model.dart';
import 'package:music_player/presentation/screens/auth/login.dart';
import 'package:music_player/presentation/screens/auth/signup.dart';
import 'package:music_player/presentation/screens/home.dart';

class AppRouter {
  // platform
  bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
  // declare repository and cubit objects

  AppRouter() {
    // initialise repository and cubit objects
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute(
            builder: (_) => UserData.isLoggedIn ? const Home() : const Login());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const Login());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignUp());

      default:
        return null;
    }
  }
}
