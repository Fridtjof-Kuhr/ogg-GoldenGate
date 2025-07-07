import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hive/hive.dart';

const _encryptionKeyName = 'hive_encryption_key';
final _secureStorage = FlutterSecureStorage();

Future<Uint8List> getEncryptionKey() async {
  String? encodedKey = await _secureStorage.read(key: _encryptionKeyName);
  if (encodedKey == null) {
    final key = Uint8List.fromList(Hive.generateSecureKey());
    await _secureStorage.write(
      key: _encryptionKeyName,
      value: base64UrlEncode(key),
    );
    return key;
  }
  return Uint8List.fromList(base64Url.decode(encodedKey));
}
