import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ogg_config.dart';
import 'operation_utils.dart';

extension OggService on OggConfig {
  Future<String> getUnitNames(String unitType) async {
    String service = (unitType == 'distpath') ? 'distsrvr' : 'adminsrvr';
    String path = (unitType == 'distpath') ? 'sources' : '${unitType}s';
    String url = "${buildUrl(
      protocol: protocol,
      server: server,
      port: port,
      deployment: deployment,
      service: service,
    )}/$path";

    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(getHeaders());
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['response']?['items'] is List) {
        List<dynamic> items = jsonResponse['response']['items'];

        List<String> names = items
            .where((item) =>
                item is Map<String, dynamic> && item.containsKey('name'))
            .map((item) => item['name'].toString())
            .toList();

        for (var name in names) {
          // Replace this with your generic OggUnit logic, e.g., new OggUnit(this, unitType, name).getStatus();
          print("Found $unitType: $name");
        }

        return names.isNotEmpty ? names.join(", ") : "No $unitType(s) found";
      } else {
        return "Invalid response format";
      }
    } else {
      return "Request failed with status: ${response.statusCode}, ${response.reasonPhrase}";
    }
  }

  Future<String> getStatusFor(String unitType, String name) async {
    final String service = (unitType == 'distpath') ? 'distsrvr' : 'adminsrvr';
    final String path =
        (unitType == 'distpath') ? 'sources/$name' : '${unitType}s/$name';
    final String base = buildUrl(
      protocol: protocol,
      server: server,
      port: port,
      deployment: deployment,
      service: service,
    );

    final Uri url = Uri.parse(
      (unitType == 'distpath') ? base.replaceAll('/$path', '') : '$base/$path',
    );

    final request = http.Request('GET', url);
    request.headers.addAll(getHeaders());
    final response = await request.send();

    if (response.statusCode != 200) return response.statusCode.toString();

    final jsonData = jsonDecode(await response.stream.bytesToString());
    if (unitType == 'distpath') {
      return jsonData['response']['items'][0]['status'].toString();
    } else {
      return jsonData['response']['status'].toString();
    }
  }

  Future<String> getLagFor(String unitType, String name) async {
    final String base = buildUrl(
      protocol: protocol,
      server: server,
      port: port,
      deployment: deployment,
      service: (unitType == 'distpath') ? 'distsrvr' : 'adminsrvr',
    );
    final String path = (unitType == 'distpath')
        ? 'sources/$name/info'
        : '${unitType}s/$name/command';

    final Uri url = Uri.parse('$base/$path');
    final request =
        http.Request((unitType == 'distpath') ? 'GET' : 'POST', url);
    request.headers.addAll(getHeaders());

    if (unitType != 'distpath') {
      request.body = json.encode({"command": "GETLAG", "isReported": true});
    }

    final response = await request.send();
    if (response.statusCode != 200) return response.statusCode.toString();

    final jsonData = jsonDecode(await response.stream.bytesToString());

    if (unitType == 'distpath') {
      return jsonData['response']['lag'].toString();
    } else {
      final reply = jsonData['response']['replyData']['lagResult'];
      final lagValue = (unitType == 'extract')
          ? reply['lastRecordLag']
          : reply['lowWatermarkLag'];
      return lagValue?.toString() ?? 'n/a';
    }
  }

  Future<String> getThroughputFor(String unitType, String name) async {
    final String base = buildUrl(
      protocol: protocol,
      server: server,
      port: port,
      deployment: deployment,
      service: (unitType == 'distpath') ? 'distsrvr' : 'adminsrvr',
    );

    if (unitType == 'distpath') {
      final Uri url = Uri.parse('$base/sources/$name/stats');
      final request = http.Request('GET', url);
      request.headers.addAll(getHeaders());
      final response = await request.send();

      if (response.statusCode != 200) return response.statusCode.toString();
      final jsonData = jsonDecode(await response.stream.bytesToString());

      final hourly = jsonData['response']['tableStatsHourly'];
      double total = 0;
      for (final item in hourly) {
        total += item['lcrSent'];
      }

      return (total / 60).toStringAsFixed(2);
    } else {
      final Uri url = Uri.parse('$base/${unitType}s/$name/command');
      final request = http.Request('POST', url);
      request.headers.addAll(getHeaders());
      request.body = json.encode({
        "command": "STATS",
        "arguments": "reportrate min total totalsonly *.*"
      });

      final response = await request.send();
      if (response.statusCode != 200) return response.statusCode.toString();

      final jsonData = jsonDecode(await response.stream.bytesToString());
      final output = jsonData.toString(); // Raw string for parsing

      // Assuming you have a helper like before
      final ops = OperationUtils.calculateTotalOperations(output);
      return ops.toString();
    }
  }
}
