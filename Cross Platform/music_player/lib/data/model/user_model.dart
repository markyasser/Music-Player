import 'package:flutter/cupertino.dart';

class User {
  String? email;
  String? userId;
  String? username;
  String? imageUrl;
  String? token;

  User({
    this.email,
    this.userId,
    this.username,
    this.token,
    this.imageUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    username = json['name'];
    imageUrl = json['image'] ?? '';
    token = json['token'];
  }
}

class UserData {
  static User? user;
  static bool isLoggedIn = false;
  static initUser(Map<String, dynamic> json) {
    UserData.isLoggedIn = true;
    UserData.user = User.fromJson(json);
  }

  static logout() {
    UserData.user = null;
    UserData.isLoggedIn = false;
    // SharedPreferences.getInstance()
    //     .then((value) => value.setString('token', ''));
    debugPrint('user logged out');
  }
}
