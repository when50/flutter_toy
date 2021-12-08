import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

  void _incrementCounter() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print("${appName}\n${packageName}\n${version}\n${buildNumber}");

      ByteData data = await rootBundle.load('assets/files/your-public-cert.pem');
      List<int> pubCert = data.buffer.asInt8List();
      data = await rootBundle.load('assets/files/your-private-key.pem');
      List<int> privKey = data.buffer.asInt8List();
      var dio = Dio();
      dio.options.headers = {
        "appid": "102",
        "version": "${version}",
        "User-Agent": "dnovel/1.1.8 (iPhone; iOS 14.5; Scale/3.00)",
        "auid": "5f379c99fe0f48042f81800c8ed86412",
        "session_eid": "5A2BEA99-9A8D-4B3C-96E1-3ABF52AE7053_0",
        "terminal": "iPhone",
      };
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        SecurityContext sc = SecurityContext();
        sc.useCertificateChainBytes(pubCert);
        sc.usePrivateKeyBytes(privKey, password: "client19@dyreader.cn");
        HttpClient httpClient = HttpClient(context: sc);
        httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {

          return true;
        };
        // httpClient.findProxy = (url) {
        //   return HttpClient.findProxyFromEnvironment(url, environment: {
        //     "http_proxy": "127.0.0.1:8888",
        //     "https_proxy": "127.0.0.1:8888",
        //     "HTTP_PROXY": "127.0.0.1:8888",
        //     "HTTPS_PROXY": "127.0.0.1:8888",
        //   });
        // };
        return httpClient;
      };

      var genCode = "c2bcafb9fa261f1321c2ce592bc8541a";
      var parameter = "_r1787546220age2-1auid5f379c99fe0f48042f81800c8ed86412chlappStorecityCN_1_5_1gender20idfa00000000-0000-0000-0000-000000000000isFromCache0orig_idfa00000000-0000-0000-0000-000000000000pl2ts1637655408807uid0ver1.1.8$genCode";
      var r = new Random().nextInt(0xFFFFFFFF);
      parameter = parameter.replaceAll(new RegExp(r"_r\d+"), "_r$r");

      var date = new DateTime.now().millisecondsSinceEpoch;
      parameter = parameter.replaceAll(new RegExp(r"ts\d+"), "ts$date");

      var content = new Utf8Encoder().convert(parameter);
      var digest = md5.convert(content).toString();
      print(digest);
      var url = "https://api.dyreader.cn/v1/init?_r=1787546220&age2=-1&auid=5f379c99fe0f48042f81800c8ed86412&chl=appStore&city=CN_1_5_1&gender2=0&idfa=00000000-0000-0000-0000-000000000000&isFromCache=0&orig_idfa=00000000-0000-0000-0000-000000000000&pl=2&sig=9f0cd9c2eb0c92769fcba30329497c6d&ts=1637572041002&uid=0&ver=1.1.8";
      url = url.replaceAll(new RegExp(r"_r[^&]*"), "_r=$r");
      url = url.replaceAll(new RegExp(r"ts[^&]*"), "ts=$date");
      url = url.replaceAll(new RegExp(r"sig[^&]*"), "sig=$digest");
      print(parameter);
      print(url);
      var response = await dio.get(url);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
