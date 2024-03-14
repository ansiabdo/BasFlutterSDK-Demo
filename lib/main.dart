import 'package:bas_sdk/bas_sdk.dart';
import 'package:bas_sdk_flutter_demo/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Common.dart';
import 'UIData.dart';

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
  int _counter = 0;
  final RestClient restClient = RestClient(
    httpClient: http.Client(),
  );
  BasSDK bas = BasSDK();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: onLogin,
                          child: const Text("BasGate Auth")),
                    ],
                  ),
                  Column(
                    children: [
                      FilledButton(
                        onPressed: onPayment,
                        child: const Text("BasGate Payment"),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: onLogin,
                          child: const Text("BasGate Status")),
                    ],
                  ),
                ],
              ),
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onLogin() async {
    if (kDebugMode) {
      print("Login");
    }
    try {
      BasSDK bas = BasSDK();
      var data = await bas.fetchAuthCode(clientId: UIData.YKBClientId);
      LOGW(data);
      if (data != null) {
        LOGW("BasAuthCode Ready");
        await restClient.getUserInfo(authId: data.data!.authId!);
      } else {
        LOGW('ERROR BasSDK Data is null : ' + data.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR BasSDK Data is null :${data.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      LOGW('ERROR BasSDK : ' + e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR BasSDK :${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  onPayment() async {
    if (kDebugMode) {
      print("onPayment");
    }

    var data = await bas.payment(
        amount: '1000', orderId: '10001', trxToken: '', appId: UIData.YKBAPPId);
  }
}
