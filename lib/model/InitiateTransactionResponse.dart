import 'dart:convert';

class InitiateTransactionResponse {
  Head? head;
  InitiateTransactionResponseBody? body;
  int? status;
  String? code;
  List<String>? messages;

  InitiateTransactionResponse({
    this.head,
    this.body,
    this.status,
    this.code,
    this.messages,
  });

  factory InitiateTransactionResponse.fromRawJson(String str) =>
      InitiateTransactionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InitiateTransactionResponse.fromJson(Map<String, dynamic> json) =>
      InitiateTransactionResponse(
        head: json["head"] == null ? null : Head.fromJson(json["head"]),
        body: json["body"] == null ? null : InitiateTransactionResponseBody.fromJson(json["body"]),
        status: json["status"],
        code: json["code"],
        messages: json["messages"] == null
            ? []
            : List<String>.from(json["messages"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "head": head?.toJson(),
        "body": body?.toJson(),
        "status": status,
        "code": code,
        "messages":
            messages == null ? [] : List<dynamic>.from(messages!.map((x) => x)),
      };
}

class InitiateTransactionResponseBody {
  int? trxStatusId;
  String? trxStatus;
  String? trxId;
  String? trxToken;
  bool? authenticated;
  int? timestamp;
  bool? isTokenExpired;
  Order? order;

  InitiateTransactionResponseBody({
    this.trxStatusId,
    this.trxStatus,
    this.trxId,
    this.trxToken,
    this.authenticated,
    this.timestamp,
    this.isTokenExpired,
    this.order,
  });

  factory InitiateTransactionResponseBody.fromRawJson(String str) => InitiateTransactionResponseBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InitiateTransactionResponseBody.fromJson(Map<String, dynamic> json) => InitiateTransactionResponseBody(
        trxStatusId: json["trxStatusId"],
        trxStatus: json["trxStatus"],
        trxId: json["trxId"],
        trxToken: json["trxToken"],
        authenticated: json["authenticated"],
        timestamp: json["timestamp"],
        isTokenExpired: json["isTokenExpired"],
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "trxStatusId": trxStatusId,
        "trxStatus": trxStatus,
        "trxId": trxId,
        "trxToken": trxToken,
        "authenticated": authenticated,
        "timestamp": timestamp,
        "isTokenExpired": isTokenExpired,
        "order": order?.toJson(),
      };
}

class Order {
  String? appId;
  String? orderId;
  Amount? amount;
  String? description;
  String? callBackUrl;
  DateTime? creationDate;
  OrderDetails? orderDetails;

  Order({
    this.appId,
    this.orderId,
    this.amount,
    this.description,
    this.callBackUrl,
    this.creationDate,
    this.orderDetails,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        appId: json["appId"],
        orderId: json["orderId"],
        amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
        description: json["description"],
        callBackUrl: json["callBackUrl"],
        creationDate: json["creationDate"] == null
            ? null
            : DateTime.parse(json["creationDate"]),
        orderDetails: json["orderDetails"] == null
            ? null
            : OrderDetails.fromJson(json["orderDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "orderId": orderId,
        "amount": amount?.toJson(),
        "description": description,
        "callBackUrl": callBackUrl,
        "creationDate": creationDate?.toIso8601String(),
        "orderDetails": orderDetails?.toJson(),
      };
}

class Amount {
  int? value;
  String? currency;

  Amount({
    this.value,
    this.currency,
  });

  factory Amount.fromRawJson(String str) => Amount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
        value: json["value"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "currency": currency,
      };
}

class OrderDetails {
  OrderDetails();

  factory OrderDetails.fromRawJson(String str) =>
      OrderDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails();

  Map<String, dynamic> toJson() => {};
}

class Head {
  String? signature;
  String? requestTimestamp;

  Head({
    this.signature,
    this.requestTimestamp,
  });

  factory Head.fromRawJson(String str) => Head.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        signature: json["signature"],
        requestTimestamp: json["requestTimestamp"],
      );

  Map<String, dynamic> toJson() => {
        "signature": signature,
        "requestTimestamp": requestTimestamp,
      };
}
