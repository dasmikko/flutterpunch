class PostModel {
  final UserModel user;
  final List<PostContentModel> content;
  final String contentAsHtml;

  PostModel({this.user, this.content, this.contentAsHtml});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    var contentList = json['contentParsed'] as List;

    List<PostContentModel> content =
        contentList.map((i) => PostContentModel.fromJson(i)).toList();

    return PostModel(user: UserModel.fromJson(json['user']), content: content, contentAsHtml: json['contentAsHtml']);
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

class PostContentModel {
  final String type;
  final String text;
  final PostContentAttributesModel attributes;
  final dynamic options;

  PostContentModel({this.type, this.text, this.attributes, this.options});

  factory PostContentModel.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'text') {
      return PostContentModel(
          type: json['type'],
          options: PostContentTextOptionsModel.fromJson(json['options']));
    } else if (json['type'] == 'postquote') {
      return PostContentModel(
          type: json['type'],
          options: PostContentPostquoteOptionsModel.fromJson(json['options']));
    } else if (json['type'] == 'hotlink') {
      return PostContentModel(
          type: json['type'],
          options: PostContentHotlinkOptionsModel.fromJson(json['options']));
    } else {
      return PostContentModel(
        type: json['type'],
        /*attributes: PostContentAttributesModel.fromJson(json['attributes'])*/
      );
    }
  }
}

/*
Text options
*/
class PostContentTextOptionsModel {
  final String text;
  final PostContentAttributesModel attributes;
  final List<PostContentTextChildModel> children;
  final dynamic mention;

  PostContentTextOptionsModel(
      {this.text, this.attributes, this.children, this.mention});

  factory PostContentTextOptionsModel.fromJson(Map<String, dynamic> json) {
    var childrenL = json['children'] as List;
    List<PostContentTextChildModel> childrenList =
        childrenL.map((i) => PostContentTextChildModel.fromJson(i)).toList();

    var mention;
    if (json['mention'] != null) mention = json['mention'];

    return PostContentTextOptionsModel(
        text: json['text'],
        attributes: PostContentAttributesModel.fromJson(json['attributes']),
        children: childrenList,
        mention: mention);
  }
}

/**
 * Post quote options
 */
class PostContentPostquoteOptionsModel {
  final String text;
  final String username;

  PostContentPostquoteOptionsModel({this.text, this.username});

  factory PostContentPostquoteOptionsModel.fromJson(Map<String, dynamic> json) {
    return PostContentPostquoteOptionsModel(
        text: json['text'], username: json['username']);
  }
}

/**
 * hotlink options
 */
class PostContentHotlinkOptionsModel {
  final String url;
  final String force;
  final String contentType;

  PostContentHotlinkOptionsModel({this.url, this.force, this.contentType});

  factory PostContentHotlinkOptionsModel.fromJson(Map<String, dynamic> json) {
    return PostContentHotlinkOptionsModel(
        url: json['url'], 
        force: json['force'], 
        contentType: json['contentType']);
  }
}

/*
 Text child element
*/
class PostContentTextChildModel {
  final String text;
  final PostContentAttributesModel attributes;
  final dynamic mention;

  PostContentTextChildModel({this.text, this.attributes, this.mention});

  factory PostContentTextChildModel.fromJson(Map<String, dynamic> json) {

    var mention;
    if (json['mention'] != null) mention = json['mention'];

    return PostContentTextChildModel(
        text: json['text'],
        attributes:
            PostContentAttributesModel.fromJson(json['options']['attributes']),
        mention: mention);
  }
}

class PostContentAttributesModel {
  final bool italic;
  final bool bold;
  final bool strikethrough;
  final String list;
  final bool isEmote;
  final bool isMention;

  PostContentAttributesModel(
      {this.bold,
      this.italic,
      this.list,
      this.strikethrough,
      this.isEmote,
      this.isMention});

  factory PostContentAttributesModel.fromJson(Map<String, dynamic> json) {
    return PostContentAttributesModel(
        italic: json['italic'],
        bold: json['bold'],
        list: json['list'],
        strikethrough: json['strikethrough'],
        isEmote: json['isEmote'],
        isMention: json['isMention']);
  }
}
