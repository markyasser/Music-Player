class MusicModel {
  String? id;
  String? musicUrl;
  String? imageUrl;
  String? musicTitle;
  String? musicSinger;
  int? likes;
  bool? isLiked;

  MusicModel({
    this.id,
    this.musicUrl,
    this.imageUrl,
    this.musicTitle,
    this.musicSinger,
    this.likes,
    this.isLiked,
  });

  MusicModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    musicUrl = json['musicUrl'];
    imageUrl = json['imageUrl'];
    musicTitle = json['title'];
    // musicSinger = json['token'];
    likes = json['likes'];
    isLiked = json['isLiked'];
  }
}
