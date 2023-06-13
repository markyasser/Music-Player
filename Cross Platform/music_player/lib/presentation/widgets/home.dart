import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/business_logic/music/music_cubit.dart';
import 'package:music_player/data/model/music_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MusicCubit>(context).getPosts();
  }

  Widget card(MusicModel item) {
    return Card(
      child: Column(
        children: [
          Image.network(item.imageUrl!),
          Text(item.musicTitle!),
        ],
      ),
    );
  }

  Widget homeBody() {
    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: state.musicList.map((item) => card(item)).toList(),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return homeBody();
  }
}
