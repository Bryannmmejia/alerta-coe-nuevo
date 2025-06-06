
class ChatUsersModel {
  String? roomId;
  String? fromUser;
  String? toUser;
  String roomName;
  bool? status;
  List<dynamic>? people;
  int? createDate;
  String? lastMessage;
  String? time;
  String? id;
  dynamic toUserInfo;

  ChatUsersModel({
    required this.roomName,
    this.time,
    this.createDate,
    this.id,
    this.status,
    this.fromUser,
    this.lastMessage,
    this.people,
    this.roomId,
    this.toUser,
    this.toUserInfo,
  });

  factory ChatUsersModel.fromJson(Map<String, dynamic> json) {
    return ChatUsersModel(
      time: json["time"],
      createDate: json["createDate"],
      id: json["id"],
      status: json["status"],
      fromUser: json["fromUser"],
      lastMessage: json["lastMessage"],
      people: json["people"],
      roomId: json["roomId"],
      roomName: json["roomName"] ?? "",
      toUser: json["toUser"],
      toUserInfo: json["toUserInfo"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "time": time,
      "createDate": createDate,
      "id": id,
      "status": status,
      "fromUser": fromUser,
      "lastMessage": lastMessage,
      "people": people,
      "roomId": roomId,
      "roomName": roomName,
      "toUser": toUser,
      "toUserInfo": toUserInfo
    };
  }
}
