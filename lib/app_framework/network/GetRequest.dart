import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class GetRequest {
  
  Future<T> fetch<T>() async {
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
      return client;

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
    Response<T> r1 = await dio.get(url);
    return r1.data!;
  }
}