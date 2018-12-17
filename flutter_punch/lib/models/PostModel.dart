class PostModel {
  final String url;
  final String icon;
  final String title;
  final bool isSticky;
  final int threadagedays;
  final int viewedcount;
  final int postcount;
  final UserModel user;

  PostModel(
      {this.url,
      this.icon,
      this.title,
      this.isSticky,
      this.viewedcount,
      this.threadagedays,
      this.postcount,
      this.user});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        url: json['url'],
        icon: json['icon'],
        title: json['title'],
        isSticky: json['isSticky'],
        viewedcount: json['viewedcount'],
        threadagedays: json['threadagedays'],
        postcount: json['postcount'],
        user: UserModel.fromJson(json['user']));
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
