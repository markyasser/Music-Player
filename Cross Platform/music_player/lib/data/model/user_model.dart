import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? email;
  String? userId;
  String? username;
  List<dynamic>? likedPosts;
  String? token;

  User({
    this.email,
    this.userId,
    this.username,
    this.token,
    this.likedPosts,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    username = json['username'];
    token = json['token'];
    likedPosts = json['likedPosts'];
  }
}

class UserData {
  static User? user;
  static bool isLoggedIn = false;
  static initUser(Map<String, dynamic> json) {
    SharedPreferences.getInstance()
        .then((value) => value.setString('token', UserData.user!.token!));
    UserData.isLoggedIn = true;
    UserData.user = User.fromJson(json);
  }

  static logout() {
    UserData.user = null;
    UserData.isLoggedIn = false;
    SharedPreferences.getInstance()
        .then((value) => value.setString('token', ''));
    debugPrint('user logged out');
  }
}
