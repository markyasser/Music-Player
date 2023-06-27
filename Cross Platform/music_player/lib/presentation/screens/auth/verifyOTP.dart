import 'package:flutter/material.dart';
import 'package:music_player/presentation/widgets/auth/veridyOTP.dart';
import 'package:music_player/presentation/widgets/navbar.dart';

class VerifyOTP extends StatelessWidget {
  final String userId;
  const VerifyOTP({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NavBar()),
      body: VerifyOTPWidget(userId: userId),
    );
  }
}
