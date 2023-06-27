import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_player/constants/strings.dart';
import 'package:music_player/data/model/user_model.dart';

class AuthWebService {
  late Dio dio;

  AuthWebService() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30));
    dio = Dio(options);
  }

  Future signup(String password, String username, String email) async {
    try {
      var res = await dio.put('auth/signup', data: {
        'email': email,
        'name': username,
        'password': password,
      });
      return res;
    } catch (e) {
      debugPrint("from signup $e");
      return e;
    }
  }

  Future verifyOTP(String userId, String otp) async {
    try {
      var res = await dio.post('auth/verifyOTP', data: {
        'userId': userId,
        'otp': otp,
      });
      return res;
    } catch (e) {
      debugPrint("from signup $e");
      return e;
    }
  }

  Future resendOTPverification(String userId, String email) async {
    try {
      var res = await dio.post('auth/resendOTPVerification', data: {
        'userId': userId,
        'email': email,
      });
      return res;
    } catch (e) {
      debugPrint("from signup $e");
      return e;
    }
  }

  Future login(String password, String email) async {
    try {
      var res = await dio.post('auth/login', data: {
        'name': email,
        'password': password,
      });
      return res;
    } catch (e) {
      debugPrint("from login $e");
      return e;
    }
  }

  Future getUser(token) async {
    try {
      var res = await dio.get('auth/user',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return res;
    } catch (e) {
      debugPrint("from login $e");
      return e;
    }
  }

  Future<dynamic> updateImage(String filepath) async {
    try {
      FormData formData = FormData.fromMap(
          {"image": await MultipartFile.fromFile(filepath, filename: 'image')});
      Response response = await dio.patch(
        'update_student_image/${UserData.user!.userId}',
        data: formData,
      );
      debugPrint(
          "update picture status code ${response.statusCode.toString()}, new image link : ${response.data['image']}");

      return response.data;
    } catch (e) {
      return e;
    }
  }
}
