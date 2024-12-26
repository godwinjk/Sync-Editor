import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convert password to bytes
  final hash = sha256.convert(bytes); // Generate hash using SHA-256
  return hash.toString(); // Convert hash to string
}
