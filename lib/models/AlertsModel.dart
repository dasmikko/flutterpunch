class AlertsModel {
  final List<SingleAlertModel> alerts;
  final int count;

  AlertsModel({
    this.alerts,
    this.count
  });

  factory AlertsModel.fromJson(Map<String, dynamic> json) {
    var alertList = json['Alerts'] as List;

    List<SingleAlertModel> alerts = alertList.map((i)=> SingleAlertModel.fromJson(i)).toList();

    return AlertsModel(
      alerts: alerts,
      count: json['Count']
    );
  }
}


class SingleAlertModel {
  final int alertId;
  final int alertType;
  final int created;
  final int updated;
  bool seen;
  final ForumObject forum;
  final UserObject user;
  final PostObject post;
  final ThreadObject thread;
  final String dataText;
  final double dataNumber;
  final String icon;

  SingleAlertModel({
    this.alertId,
    this.alertType,
    this.created,
    this.forum,
    this.seen,
    this.updated,
    this.user,
    this.dataText,
    this.icon,
    this.dataNumber,
    this.post,
    this.thread
  });

  factory SingleAlertModel.fromJson(Map<String, dynamic> json) {
    return SingleAlertModel(
      alertId: json['AlertId'],
      alertType: json['AlertType'],
      created: json['Created'],
      forum: ForumObject.fromJson(json['Forum']),
      user: UserObject.fromJson(json['User']),
      thread: ThreadObject.fromJson(json['Thread']),
      dataText: json['DataText'],
      dataNumber: json['DataNumber'],
      icon: json['Icon'],
      post: PostObject.fromJson(json['Post']),
      seen: json['Seen']
    );
  }
}

class ForumObject {
  final String url;
  final String name;

  ForumObject({
    this.name,
    this.url
  });

  factory ForumObject.fromJson(Map<String, dynamic> json) {
    return ForumObject(
      url: json['Url'],
      name: json['Name'],      
    );
  }
}

class UserObject {
  final String userid;
  final String username;

  UserObject({
    this.userid,
    this.username
  });

  factory UserObject.fromJson(Map<String, dynamic> json) {
    return UserObject(
      userid: json['UserId'],
      username: json['Username'],      
    );
  }
}

class ThreadObject {
  final String threadid;
  final String name;
  final int postcount;

  ThreadObject({
    this.threadid,
    this.name,
    this.postcount
  });

  factory ThreadObject.fromJson(Map<String, dynamic> json) {
    return ThreadObject(
      threadid: json['ThreadId'],
      name: json['Name'], 
      postcount: json['PostCount']     
    );
  }
}

class PostObject {
  final String postid;
  final int postnumber;

  PostObject({
    this.postid,
    this.postnumber
  });

  factory PostObject.fromJson(Map<String, dynamic> json) {
    return PostObject(
      postid: json['PostId'],
      postnumber: json['PostNumber']  
    );
  }
}