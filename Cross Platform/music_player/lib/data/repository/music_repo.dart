import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  Future<List<MusicModel>?> getLikedPosts() async {
    List<MusicModel>? musicList;
    await musicWebService.getLikedPosts().then((value) {
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

  Future<List<MusicModel>?> getPlaylistMusic(String playlistId) async {
    List<MusicModel>? musicList;
    await musicWebService.getPlaylistMusic(playlistId).then((value) {
      if (value.statusCode == 200) {
        musicList = value.data['items'].map<MusicModel>((item) {
          return MusicModel.fromJson(item);
        }).toList();
      } else {
        debugPrint("get posts status code is ${value.statusCode}");
        musicList = [];
      }
    });
    return musicList;
  }

  Future<List<dynamic>?> getPlaylist() async {
    List<dynamic> playlists = [];
    await musicWebService.getPlaylist().then((value) {
      if (value.statusCode == 200) {
        playlists = value.data['playlists'].map<dynamic>((item) {
          return {
            "name": item['name'],
            "id": item['_id'],
            "number": item['items'].length,
          };
        }).toList();
      } else {
        debugPrint("get playlists status code is ${value.statusCode}");
        playlists = [];
      }
    });
    return playlists;
  }

  Future<List<MusicModel>?> like(String postId) async {
    List<MusicModel>? musicList;
    await musicWebService.like(postId).then((value) {
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

  Future<String?> addToPlayList(String playlistName, String musicId) async {
    await musicWebService.addToPlayList(playlistName, musicId).then((value) {
      if (value.statusCode == 200) {
        return value.data['message'];
      } else {
        debugPrint("get posts status code is ${value.statusCode}");
        return '';
      }
    });
    return '';
  }

  Future<String> upload(
      String title, String creator, Uint8List img, Uint8List audio) async {
    String msg = '';
    await musicWebService.uploadMusic(title, creator, img, audio).then((value) {
      if (value.statusCode == 201) {
        msg = value.data['message'];
      }
      debugPrint("get posts status code is ${value.statusCode}");
      msg = value.data['message'];
    });
    return msg;
  }

  Future<List<MusicModel>?> delete(String postId) async {
    List<MusicModel>? musicList;
    await musicWebService.delete(postId).then((value) {
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
