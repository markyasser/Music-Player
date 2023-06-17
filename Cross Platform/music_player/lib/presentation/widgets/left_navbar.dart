import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/business_logic/music/music_cubit.dart';

class LeftNavBar extends StatefulWidget {
  const LeftNavBar({super.key});

  @override
  State<LeftNavBar> createState() => _LeftNavBarState();
}

class _LeftNavBarState extends State<LeftNavBar> {
  Widget item(text, icon, onTap) {
    return InkWell(
        onTap: () {
          if (text == 'Home') {
            BlocProvider.of<MusicCubit>(context).getPosts();
          } else if (text == 'Liked') {
            BlocProvider.of<MusicCubit>(context).getLikedPosts();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(
                '     $text',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        item('Home', Icons.home,
            () => BlocProvider.of<MusicCubit>(context).getPosts()),
        item('Liked', Icons.favorite,
            () => BlocProvider.of<MusicCubit>(context).getLikedPosts()),
      ],
    );
  }
}
