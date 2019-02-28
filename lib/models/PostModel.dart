class PostModel {
  final String type;
  final UserModel user;
  final String contentAsHtml;
  final PostMeta meta;
  final int postId;
  final bool canVote;
  final bool canReply;
  final bool isOwnPost;

  PostModel(
      {this.user,
      this.contentAsHtml,
      this.meta,
      this.postId,
      this.canVote,
      this.canReply,
      this.isOwnPost,
      this.type});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'post') {
      return PostModel(
          type: json['type'],
          postId: json['postid'],
          canReply: json['canreply'],
          canVote: json['canvote'],
          isOwnPost: json['isownpost'],
          user: UserModel.fromJson(json['user']),
          contentAsHtml: json['contentAsHtml'],
          meta: PostMeta.fromJson(json['meta']));
    } else {
      return PostModel(type: json['type']);
    }
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

  PostMeta({this.votes});

  factory PostMeta.fromJson(Map<String, dynamic> json) {
    return PostMeta(votes: json['Votes']);
  }
}
