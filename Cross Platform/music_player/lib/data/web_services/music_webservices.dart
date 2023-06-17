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
