import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/constants/strings.dart';
import 'package:music_player/data/model/user_model.dart';

class MusicWebService {
  late Dio dio;

  MusicWebService() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30));
    dio = Dio(options);
  }

  Future getPosts() async {
    try {
      var res = await dio.get('feed/posts',
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from get posts $e");
      return e;
    }
  }

  Future getLikedPosts() async {
    try {
      var res = await dio.get('feed/get_liked',
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from get posts $e");
      return e;
    }
  }

  Future getPlaylistMusic(String playlistId) async {
    try {
      var res = await dio.get('feed/playlist/$playlistId',
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from get playlist music $e");
      return e;
    }
  }

  Future getPlaylist() async {
    try {
      var res = await dio.get('feed/playlists',
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from get playlists $e");
      return e;
    }
  }

  Future like(String postId) async {
    try {
      var res = await dio.post('feed/like/$postId',
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from like post $postId $e");
      return e;
    }
  }

  Future addToPlayList(String playlistName, String musicId) async {
    try {
      var res = await dio.post('feed/addToplaylist',
          data: {'name': playlistName, 'postId': musicId},
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from add to playlist $e");
      return e;
    }
  }

  Future delete(String postId) async {
    try {
      var res = await dio.delete('feed/post/$postId',
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from delete post $postId $e");
      return e;
    }
  }

  Future uploadMusic(
      String title, String creator, Uint8List img, Uint8List audio) async {
    try {
      FormData body = FormData.fromMap({
        'title': title,
        'content': creator,
        "image": MultipartFile.fromBytes(img, filename: 'image'),
        "audio": MultipartFile.fromBytes(audio, filename: 'audio')
      });
      var res = await dio.post('feed/post',
          data: body,
          options: Options(headers: {
            'Authorization': 'Bearer ${UserData.user!.token}',
          }));
      return res;
    } catch (e) {
      debugPrint("from like post  $e");
      return e;
    }
  }
}
