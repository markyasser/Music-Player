class MusicModel {
  String? id;
  String? creatorId;
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
    this.creatorId,
    this.likes,
    this.isLiked,
  });

  MusicModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    musicUrl = json['musicUrl'];
    imageUrl = json['imageUrl'];
    musicTitle = json['title'];
    creatorId = json['creatorId'];
    musicSinger = json['content'];
    likes = json['likes'];
    isLiked = json['isLiked'];
  }
}
