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
  bool loading = false;
  bool isLoggined = false;
  bool isPaid = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ListView(children: [
          loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FilledButton(
                          onPressed: onLogin,
                          child: const Text("BasGate Auth")),
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
              "User Info : ${isLoggined ? _userInfo.toRawJson() : 'Not Loggined'}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Transaction Data : ${isPaid ? _transaction.toRawJson() : 'Not Paid'}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Order Status : ${isChecked ? _status.toRawJson() : 'Not Checked'}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ]));
  }

  onLogin() async {
    if (kDebugMode) {
      print("Login");
    }
    if (isLoggined) {
      showMsg('Already Login', Colors.orangeAccent);
      return;
    }
    try {
      setLoading(true);
      BasSDK bas = BasSDK();
      var data = await bas.fetchAuthCode(clientId: UIData.BASClientId);
      showMsg('BasSDK Auth Data :${data.toString()}', Colors.green);
      if (data != null) {
        setState(() {
          _authCode = data.data!.authId!;
        });
        showMsg("BasAuthCode Ready", Colors.green);
        var userInfo = await restClient.getUserInfo(authId: data.data!.authId!);

        setState(() {
          _userInfo = userInfo;
        });
        showMsg('BasSDK UserInfo Data :${userInfo.toRawJson()}', Colors.green);
      } else {
        showMsg('ERROR BasSDK Data is null :${data.toString()}', Colors.red);
      }
      isLoggined = true;
      setLoading(false);
    } catch (e) {
      setLoading(false);
      showMsg('ERROR BasSDK :${e.toString()}', Colors.red);
    }
  }

  onPayment() async {
    LOGW("onPayment");
    try {
      if (isPaid) {
        showMsg('Already Paid', Colors.orangeAccent);
        return;
      }
      setLoading(true);
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
      trxToken = initTrans.trxToken!;
      showMsg('BasSDK initTrans Data :${initTrans.toRawJson()}', Colors.green);
      if (mounted) {
        setState(() {
          _transaction = initTrans;
        });
      }

      var data = await bas.payment(
          amount: initTrans.order!.amount!.value.toString(),
          orderId: getOrderId(),
          trxToken: trxToken,
          appId: UIData.BASAPPId);
      showMsg('BasSDK payment Data :$data', Colors.green);

      isPaid = true;
      setLoading(false);
    } on Exception catch (e) {
      setLoading(false);
      showMsg('ERROR onPayment :${e.toString()}', Colors.red);
    }
  }

  onStatus() async {
    LOGW("onStatus");

    try {
      setLoading(false);
      var orderStatus = await restClient.getStatus(orderId: getOrderId());
      showMsg(
          'BasSDK orderStatus Data :${orderStatus.toRawJson()}', Colors.green);
      if (mounted) {
        setState(() {
          _status = orderStatus;
          isChecked = true;
        });
      }
      setLoading(false);
    } on Exception catch (e) {
      setLoading(false);
      showMsg('ERROR onStatus :${e.toString()}', Colors.red);
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

  showMsg(String msg, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: color,
        ),
      );
    }
    LOGW(msg);
  }

  setLoading(bool status) {
    if (mounted) {
      setState(() {
        loading = status;
      });
    }
  }
}
