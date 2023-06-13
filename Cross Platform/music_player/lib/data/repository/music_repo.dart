import 'package:flutter/cupertino.dart';
import 'package:music_player/data/model/music_model.dart';
import 'package:music_player/data/web_services/music_webservices.dart';

class MusicRepository {
  final MusicWebService musicWebService;
  late Map<String, dynamic> user;
  MusicRepository(this.musicWebService);

  Future<List<MusicModel>?> getPosts() async {
    List<MusicModel>? musicList;
    await musicWebService.getPosts().then((value) {
      if (value.statusCode == 200) {
        musicList = value.data['posts'].map<MusicModel>((item) {
          return MusicModel.fromJson(item);
        }).toList();
      } else {
        debugPrint("get posts status code is ${value.statusCode}");
        musicList = [];
      }
    });
    return musicList;
  }
}
