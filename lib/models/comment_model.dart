class CommentModel {
  late String comment;
  late String uId;
  late String name;
  late String image;
  late int milSecEpoch;
  CommentModel({
    required this.comment,
    required this.uId,
    required this.name,
    required this.image,
    required this.milSecEpoch,
  });
  CommentModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    uId = json['uId'];
    name = json['name'];
    image = json['userImage'];
    milSecEpoch = json['milSecEpoch'];
  }
  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'uId': uId,
      'name': name,
      'userImage': image,
      'milSecEpoch': milSecEpoch,
    };
  }
}
