import 'dart:convert';
import 'dart:math';

import 'package:bas_sdk/bas_sdk.dart';
import 'package:bas_sdk_flutter_demo/model/UserInfo.dart';
import 'package:bas_sdk_flutter_demo/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Common.dart';
import 'UIData.dart';
import 'model/InitiateTransactionResponse.dart';
import 'model/OrderCheckOut.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bas SDK Flutter Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RestClient restClient = RestClient(
    httpClient: http.Client(),
  );
  BasSDK bas = BasSDK();

  String _authCode = '';
  String? _orderId;
  InitiateTransactionResponse _transaction = InitiateTransactionResponse();
  InitiateTransactionResponse _status = InitiateTransactionResponse();
  UserInfo _userInfo = UserInfo();
  String trxToken = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FilledButton(
                    onPressed: onLogin, child: const Text("BasGate Auth")),
                const SizedBox(
                  width: 16,
                ),
                FilledButton(
                  onPressed: onPayment,
                  child: const Text("BasGate Payment"),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: onStatus, child: const Text("BasGate Status")),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "AuthId : $_authCode",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "User Info : ${_userInfo.toRawJson()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Transaction Data : ${_transaction.toRawJson()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Order Status : ${_status.toRawJson()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ]));
  }

  onLogin() async {
    if (kDebugMode) {
      print("Login");
    }
    try {
      BasSDK bas = BasSDK();
      var data = await bas.fetchAuthCode(clientId: UIData.BASClientId);
      LOGW(data.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BasSDK Auth Data :${data.toString()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (data != null) {
        setState(() {
          _authCode = 'AuthId :${data.data!.authId!}';
        });
        LOGW("BasAuthCode Ready");
        var userInfo = await restClient.getUserInfo(authId: data.data!.authId!);

        setState(() {
          _userInfo = userInfo;
        });
        LOGW('BasSDK UserInfo Data');
        LOGW(userInfo.toRawJson());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('BasSDK UserInfo Data :${userInfo.toRawJson()}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        LOGW('ERROR BasSDK Data is null : $data');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ERROR BasSDK Data is null :${data.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      LOGW('ERROR BasSDK : $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR BasSDK :${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  onPayment() async {
    LOGW("onPayment");
    try {
      var order = OrderCheckOut(
          orderDetails: [
            OrderDetail(
              product: 'Product',
              type: 'Type',
              price: 1000,
              qty: 1,
              subTotalPrice: 1000,
            ),
          ],
          paymentProvider: 'BAS_GATE',
          customerInfo: _userInfo.data,
          amount: OrderAmount(currency: 'YER', value: 1000),
          orderId: getOrderId());
      LOGW("Order : ${order.toRawJson()}");

      var initTrans = await restClient.getPayment(order: order);
      LOGW("initTrans : $initTrans");
      LOGW("json.encode(initTrans) : ${json.encode(initTrans)}");

      trxToken = initTrans.trxToken!;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BasSDK initTrans Data :${initTrans.toRawJson()}'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _transaction = initTrans;
        });
      }

      var data = await bas.payment(
          amount: initTrans.order!.amount!.value.toString(),
          orderId: getOrderId(),
          trxToken: trxToken,
          appId: UIData.BASAPPId);
      LOGW("bas.payment : $data");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('BasSDK payment Data :$data'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on Exception catch (e) {
      LOGW('ERROR onPayment : $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR onPayment :${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  onStatus() async {
    LOGW("onStatus");

    try {
      var orderStatus = await restClient.getStatus(orderId: getOrderId());
      LOGW(orderStatus.toRawJson());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('BasSDK orderStatus Data :${orderStatus.toRawJson()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      setState(() {
        _status = orderStatus;
      });
    } on Exception catch (e) {
      LOGW('ERROR onStatus : $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR onStatus :${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  getOrderId() {
    if (_orderId != null && _orderId!.isNotEmpty && _orderId!.length > 1) {
      return _orderId;
    }
    var random = Random();
    _orderId = '1111${random.nextInt(1000000)}';
    return _orderId;
  }
}
