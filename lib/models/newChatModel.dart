class NewChatModel {
  final String username;
  final String time;
  final String? picture;
  final String fullName;
  final bool isOnline;
  final String socketId;
  final String userType;

  NewChatModel({
    required this.fullName,
    this.picture,
    required this.time,
    required this.userType,
    required this.username,
    required this.isOnline,
    required this.socketId,
  });

  factory NewChatModel.fromJson(Map<String, dynamic> json) {
    return NewChatModel(
      picture: json["picture"],
      fullName: json["fullName"],
      time: json["time"],
      username: json["username"],
      isOnline: json["isOnline"],
      userType: json["userType"],
      socketId: json["socketId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "picture": picture,
      "fullName": fullName,
      "time": time,
      "username": username,
      "isOnline": isOnline,
      "userType": userType,
      "socketId": socketId,
    };
  }
}
