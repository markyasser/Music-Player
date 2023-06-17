import 'package:flutter/material.dart';
import 'package:music_player/presentation/widgets/home.dart';
import 'package:music_player/presentation/widgets/navbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NavBar()),
      body: const HomeWidget(),
    );
  }
}
