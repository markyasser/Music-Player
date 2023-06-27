import 'package:flutter/material.dart';
import 'package:music_player/presentation/widgets/auth/veridyOTP.dart';
import 'package:music_player/presentation/widgets/navbar.dart';

class VerifyOTP extends StatelessWidget {
  final String userId;
  final String email;
  const VerifyOTP({super.key, required this.userId, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NavBar()),
      body: VerifyOTPWidget(userId: userId, email: email),
    );
  }
}
