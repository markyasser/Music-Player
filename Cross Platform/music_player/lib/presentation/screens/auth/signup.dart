import 'package:flutter/material.dart';
import 'package:music_player/presentation/widgets/auth/signup.dart';
import 'package:music_player/presentation/widgets/navbar.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NavBar()),
      body: const SignUpWidget(),
    );
  }
}
