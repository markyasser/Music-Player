import 'package:flutter/cupertino.dart';
import 'package:music_player/data/model/user_model.dart';
import 'package:music_player/data/web_services/auth_webservices.dart';

class AuthRepository {
  final AuthWebService authWebService;
  late Map<String, dynamic> user;
  AuthRepository(this.authWebService);

  Future<String?> signup(String password, String username, String email) async {
    String? message;
    await authWebService.signup(password, username, email).then((value) {
      if (value.statusCode == 200) {
        message = value.data['message'];
        UserData.initUser(value.data);
      } else {
        debugPrint("sign up status code is ${value.statusCode}");
        message = value.data['message'];
      }
    });
    return message;
  }

  Future<String?> login(String password, String email) async {
    String? message;
    await authWebService.login(password, email).then((value) {
      if (value.statusCode == 200) {
        message = value.data['message'];
        UserData.initUser(value.data);
      } else {
        debugPrint("login status code is ${value.statusCode}");
        message = value.data['message'];
      }
    });
    return message;
  }

  Future<dynamic> updateImage(String val) async {
    final newVal = await authWebService.updateImage(val);
    debugPrint(newVal['image']);
    return newVal['image'];
  }
}
