import 'dart:convert';

import 'package:bas_sdk_flutter_demo/model/UserInfo.dart';

class OrderCheckOut {
  List<OrderDetail>? orderDetails;
  String? paymentProvider;
  String? orderId;
  UserData? customerInfo;
  OrderAmount? amount;

  OrderCheckOut({
    this.orderDetails,
    this.paymentProvider,
    this.customerInfo,
    this.orderId,
    this.amount,
  });

  factory OrderCheckOut.fromRawJson(String str) =>
      OrderCheckOut.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCheckOut.fromJson(Map<String, dynamic> json) => OrderCheckOut(
        orderDetails: json["orderDetails"] == null
            ? []
            : List<OrderDetail>.from(
                json["orderDetails"]!.map((x) => OrderDetail.fromJson(x))),
        paymentProvider: json["paymentProvider"],
        customerInfo: json["customerInfo"] == null
            ? null
            : UserData.fromJson(json["customerInfo"]),
        orderId: json["orderId"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "orderDetails": orderDetails == null
            ? []
            : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
        "paymentProvider": paymentProvider,
        "customerInfo": customerInfo?.toJson(),
        "orderId": orderId,
        "amount": amount?.toJson(),
      };
}

class OrderDetail {
  String? product;
  String? type;
  int? price;
  int? qty;
  int? subTotalPrice;

  OrderDetail({
    this.product,
    this.type,
    this.price,
    this.qty,
    this.subTotalPrice,
  });

  factory OrderDetail.fromRawJson(String str) =>
      OrderDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        product: json["Product"],
        type: json["Type"],
        price: json["Price"],
        qty: json["Qty"],
        subTotalPrice: json["SubTotalPrice"],
      );

  Map<String, dynamic> toJson() => {
        "Product": product,
        "Type": type,
        "Price": price,
        "Qty": qty,
        "SubTotalPrice": subTotalPrice,
      };
}

class OrderAmount {
  String? currency;
  double? value;

  OrderAmount({
    this.currency,
    this.value,
  });

  factory OrderAmount.fromRawJson(String str) => OrderAmount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderAmount.fromJson(Map<String, dynamic> json) => OrderAmount(
        currency: json["currency"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "value": value,
      };
}
