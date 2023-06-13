import 'package:flutter/material.dart';
import 'package:music_player/presentation/widgets/auth/login.dart';
import 'package:music_player/presentation/widgets/navbar.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NavBar()),
      body: const LoginWidget(),
    );
  }
}
