import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:core';
import 'operation_utils.dart';

part 'ogg_config.g.dart';

String buildUrl({
  required String protocol,
  required String server,
  required String port,
  required String deployment,
  String service = 'adminsrvr',
}) {
  if (deployment.isNotEmpty) {
    return '$protocol://$server:$port/services/$deployment/$service/v2';
  } else {
    if (service == 'distsrvr') {
      port = (int.parse(port) + 1).toString();
    }
    return '$protocol://$server:$port/services/v2';
  }
}

@HiveType(typeId: 0)
class OggConfig extends HiveObject {
  @HiveField(0)
  String server;
  @HiveField(1)
  String deployment;
  @HiveField(2)
  String protocol;
  @HiveField(3)
  String port;
  @HiveField(4)
  String username;
  @HiveField(5)
  String password;
  @HiveField(6)
  bool active;

  OggConfig({
    required this.server,
    required this.deployment,
    required this.protocol,
    required this.port,
    required this.username,
    required this.password,
    required this.active,
  });

  Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization":
          "Basic ${base64Encode(utf8.encode('$username:$password'))}",
    };
  }
}
