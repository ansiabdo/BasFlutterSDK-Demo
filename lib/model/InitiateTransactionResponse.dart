import 'dart:convert';

class InitiateTransactionResponse {
  int? actionId;
  bool? authenticated;
  bool? isTokenExpired;
  Order? order;
  int? timestamp;
  String? trxId;
  String? trxStatus;
  int? trxStatusId;
  String? trxToken;

  InitiateTransactionResponse({
    this.actionId,
    this.authenticated,
    this.isTokenExpired,
    this.order,
    this.timestamp,
    this.trxId,
    this.trxStatus,
    this.trxStatusId,
    this.trxToken,
  });

  factory InitiateTransactionResponse.fromRawJson(String str) => InitiateTransactionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InitiateTransactionResponse.fromJson(Map<String, dynamic> json) => InitiateTransactionResponse(
    actionId: json["actionId"],
    authenticated: json["authenticated"],
    isTokenExpired: json["isTokenExpired"],
    order: json["order"] == null ? null : Order.fromJson(json["order"]),
    timestamp: json["timestamp"],
    trxId: json["trxId"],
    trxStatus: json["trxStatus"],
    trxStatusId: json["trxStatusId"],
    trxToken: json["trxToken"],
  );

  Map<String, dynamic> toJson() => {
    "actionId": actionId,
    "authenticated": authenticated,
    "isTokenExpired": isTokenExpired,
    "order": order?.toJson(),
    "timestamp": timestamp,
    "trxId": trxId,
    "trxStatus": trxStatus,
    "trxStatusId": trxStatusId,
    "trxToken": trxToken,
  };
}

class Order {
  Amount? amount;
  String? appId;
  String? callBackUrl;
  DateTime? creationDate;
  String? description;
  OrderDetails? orderDetails;
  String? orderId;
  String? orderType;

  Order({
    this.amount,
    this.appId,
    this.callBackUrl,
    this.creationDate,
    this.description,
    this.orderDetails,
    this.orderId,
    this.orderType,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
    appId: json["appId"],
    callBackUrl: json["callBackUrl"],
    creationDate: json["creationDate"] == null ? null : DateTime.parse(json["creationDate"]),
    description: json["description"],
    orderDetails: json["orderDetails"] == null ? null : OrderDetails.fromJson(json["orderDetails"]),
    orderId: json["orderId"],
    orderType: json["orderType"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount?.toJson(),
    "appId": appId,
    "callBackUrl": callBackUrl,
    "creationDate": creationDate?.toIso8601String(),
    "description": description,
    "orderDetails": orderDetails?.toJson(),
    "orderId": orderId,
    "orderType": orderType,
  };
}

class Amount {
  String? currency;
  int? value;

  Amount({
    this.currency,
    this.value,
  });

  factory Amount.fromRawJson(String str) => Amount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
    currency: json["currency"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "value": value,
  };
}

class OrderDetails {
  String? currency;
  String? id;
  List<List<List<List<dynamic>>>>? products;
  int? totalPrice;

  OrderDetails({
    this.currency,
    this.id,
    this.products,
    this.totalPrice,
  });

  factory OrderDetails.fromRawJson(String str) => OrderDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    currency: json["Currency"],
    id: json["Id"],
    products: json["Products"] == null ? [] : List<List<List<List<dynamic>>>>.from(json["Products"]!.map((x) => List<List<List<dynamic>>>.from(x.map((x) => List<List<dynamic>>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))))),
    totalPrice: json["TotalPrice"],
  );

  Map<String, dynamic> toJson() => {
    "Currency": currency,
    "Id": id,
    "Products": products == null ? [] : List<dynamic>.from(products!.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))))),
    "TotalPrice": totalPrice,
  };
}
