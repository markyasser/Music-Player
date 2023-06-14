import 'package:flutter/material.dart';
import 'package:music_player/presentation/widgets/navbar.dart';
import 'package:music_player/presentation/widgets/upload.dart';

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NavBar()),
      body: UploadWidget(),
    );
  }
}
