import 'dart:convert';

class UserInfo {
  String? code;
  Data? data;
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
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data {
  String? name;
  String? openId;
  String? phone;
  String? userName;

  Data({
    this.name,
    this.openId,
    this.phone,
    this.userName,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
