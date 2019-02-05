class ForumsModel {
  final String id;
  final String icon;
  final String title;
  final String subtitle;
  final int viewers;
  final int threadCount;
  final int postCount;

  ForumsModel({
    this.id,
    this.icon, 
    this.title,
    this.subtitle,
    this.viewers,
    this.threadCount,
    this.postCount
  });

  factory ForumsModel.fromJson(Map<String, dynamic> json) {
    return ForumsModel(
      id: json['id'],
      icon: json['icon'],
      title: json['title'],
      subtitle: json['subtitle'],
      viewers: json['viewers'],
      threadCount: json['threadCount'],
      postCount: json['threadCount']
    );
  }
}