import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
}
