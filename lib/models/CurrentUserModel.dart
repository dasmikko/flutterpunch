class CurrentUserModel {
  final String username;
  final String avatar;
  final int level;
  final String backgroundImage; 

  CurrentUserModel({
    this.username,
    this.avatar,
    this.level,
    this.backgroundImage
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    print(json);
    // Parse forums too
   return CurrentUserModel(
      username: json['username'],
      avatar: json['avatar'],
      level: json['level'],
      backgroundImage: json['backgroundImage']
    );
  }
}