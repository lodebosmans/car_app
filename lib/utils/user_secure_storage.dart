import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsersecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUserName = 'userName';

  static Future setUserName(String userName) async =>
      await _storage.write(key: _keyUserName, value: userName);

  static Future<String?> getUserName() async =>
      await _storage.read(key: _keyUserName);
}
