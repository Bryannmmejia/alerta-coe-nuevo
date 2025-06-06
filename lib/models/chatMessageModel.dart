class ChatMessageModel {
  String? time;
  String message;
  dynamic room;
  bool? received;
  bool? seen;
  int? seenDate;
  String? id;
  String msgType;
  dynamic fileData;
  int? serialNumber;
  String? messageId;
  int? createDate;
  String? type;

  ChatMessageModel({
    required this.message,
    this.createDate,
    this.id,
    this.fileData,
    this.messageId,
    required this.msgType,
    this.received,
    this.room,
    this.seen,
    this.seenDate,
    this.serialNumber,
    this.type,
    this.time,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      time: json["time"],
      message: json["message"] ?? "",
      room: json["room"],
      received: json["received"],
      seen: json["seen"],
      seenDate: json["seenDate"],
      id: json["id"],
      msgType: json["msgType"] ?? "",
      fileData: json["fileData"],
      serialNumber: json["serialNumber"],
      messageId: json["messageId"],
      createDate: json["createDate"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "msgType": msgType,
      "time": time,
      "createDate": createDate,
      "id": id,
      "fileData": fileData,
      "messageId": messageId,
      "received": received,
      "room": room,
      "seen": seen,
      "seenDate": seenDate,
      "serialNumber": serialNumber,
      "type": type
    };
  }
}
