import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:core';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class OperationUtils {
  static int calculateTotalOperations(String output) {
    // Regular expression patterns for inserts, updates, and deletes
    RegExp insertPattern = RegExp(r'Total inserts/minute\s+(\d+\.\d+)');
    RegExp updatePattern = RegExp(r'Total updates/minute\s+(\d+\.\d+)');
    RegExp deletePattern = RegExp(r'Total deletes/minute\s+(\d+\.\d+)');

    // Extract the values for inserts, updates, and deletes using regex
    double inserts = _extractValue(insertPattern, output);
    double updates = _extractValue(updatePattern, output);
    double deletes = _extractValue(deletePattern, output);
    print("DML I : $inserts $updates $deletes");
    // Calculate the total operations
    return (inserts + updates + deletes).toInt();
  }

// Helper function to extract a numeric value using regex
  static double _extractValue(RegExp pattern, String output) {
    Match? match = pattern.firstMatch(output);
    if (match != null) {
      return double.parse(match.group(1) ?? '0');
    }
    return 0.0;
  }
}