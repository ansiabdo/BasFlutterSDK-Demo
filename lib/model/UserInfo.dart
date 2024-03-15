import 'dart:convert';

class UserInfo {
  String? code;
  UserData? data;
  dynamic head;
  dynamic messages;
  int? status;

  UserInfo({
    this.code,
    this.data,
    this.head,
    this.messages,
    this.status,
  });

  factory UserInfo.fromRawJson(String str) =>
      UserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        code: json["code"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
        head: json["head"],
        messages: json["messages"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data?.toJson(),
        "head": head,
        "messages": messages,
        "status": status,
      };
}

class UserData {
  String? name;
  String? openId;
  String? phone;
  String? userName;

  UserData({
    this.name,
    this.openId,
    this.phone,
    this.userName,
  });

  factory UserData.fromRawJson(String str) => UserData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        openId: json["open_id"],
        phone: json["phone"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "open_id": openId,
        "phone": phone,
        "user_name": userName,
      };
}
