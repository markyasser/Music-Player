import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? email;
  String? userId;
  String? username;
  String? profilePicture;
  List<dynamic>? likedPosts;
  List<dynamic>? playlists;
  String? token;

  User({
    this.email,
    this.userId,
    this.username,
    this.token,
    this.likedPosts,
    this.playlists,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    username = json['username'];
    profilePicture = json['profile'];
    token = json['token'];
    likedPosts = json['likedPosts'];
    playlists = json['playlists'];
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
    // debugPrint('user logged out');
  }
}
