class ThreadModel {
  final String url;
  final String lastUnreadUrl;
  final String icon;
  final String title;
  final bool isSticky;
  final int threadagedays;
  final int viewedcount;
  final int postcount;
  final ThreadCreatorModel creator;
  final int pageNumber;
  final int unreadPostsCount;

  ThreadModel({
    this.url,
    this.icon, 
    this.title,
    this.isSticky,
    this.viewedcount,
    this.threadagedays,
    this.postcount,
    this.creator,
    this.pageNumber,
    this.unreadPostsCount,
    this.lastUnreadUrl
  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    return ThreadModel(
      url: json['url'],
      icon: json['icon'],
      title: json['title'],
      isSticky: json['isSticky'],
      viewedcount: json['viewedcount'],
      threadagedays: json['threadagedays'],
      postcount: json['postcount'],
      creator: ThreadCreatorModel.fromJson(json['creator']),
      unreadPostsCount: json['unreadPostsCount'],
      lastUnreadUrl: json['lastUnreadUrl']
    );
  }
}

class ThreadCreatorModel {
  final String id;
  final String username;
  final String url;

  ThreadCreatorModel({this.id, this.url, this.username});

  factory ThreadCreatorModel.fromJson(Map<String, dynamic> json) {
    return ThreadCreatorModel(
      id: json['id'],
      username: json['username'],
      url: json['url'],
    );
  }
}