class PostModel {
  final UserModel user;
  final String contentAsHtml;
  final PostMeta meta;

  PostModel({this.user, this.contentAsHtml, this.meta});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        user: UserModel.fromJson(json['user']),
        contentAsHtml: json['contentAsHtml'],
        meta: PostMeta.fromJson(json['meta']));
  }
}

class UserModel {
  final String country;
  final String username;
  final int userlevel;
  final String url;
  final String avatar;
  final String backgroundImage;
  final String userRank;

  UserModel(
      {this.country,
      this.url,
      this.username,
      this.avatar,
      this.backgroundImage,
      this.userRank,
      this.userlevel});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      country: json['country'],
      username: json['username'],
      url: json['url'],
      avatar: json['avatar'],
      backgroundImage: json['backgroundImage'],
      userRank: json['userRank'],
      userlevel: json['userlevel'],
    );
  }
}

class PostMeta {
  final dynamic votes;

  PostMeta({ this.votes });

  factory PostMeta.fromJson(Map<String, dynamic> json) {
    return PostMeta(
      votes: json['Votes']
    );
  }
}