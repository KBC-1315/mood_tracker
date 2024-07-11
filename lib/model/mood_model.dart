class MoodModel {
  final String description;
  final bool replied;
  final String repliedto;
  final String creatorUid;
  final String creator;
  final int createdAt;
  final String postType;
  final String status;

  MoodModel(
      {required this.creator,
      required this.description,
      required this.replied,
      required this.repliedto,
      required this.creatorUid,
      required this.createdAt,
      required this.postType,
      required this.status});

  MoodModel.fromJson(Map<String, dynamic> json)
      : creator = json["creator"],
        description = json["description"],
        replied = json["replied"],
        repliedto = json["repliedto"],
        creatorUid = json["creatorUid"],
        createdAt = json["createdAt"],
        status = json["status"],
        postType = json["postType"];
  Map<String, dynamic> toJson() {
    return {
      "creator": creator,
      "description": description,
      "replied": replied,
      "repliedto": repliedto,
      "creatorUid": creatorUid,
      "createdAt": createdAt,
      "status": status,
      "postType": postType,
    };
  }
}
