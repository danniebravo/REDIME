import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Deterministic password hashing used by the local SQLite auth flow.
///
/// This is a client-only demo project that stores credentials locally, so a
/// straight sha256 of (password + static pepper) is acceptable. For a real
/// backend migrate to bcrypt/argon2 server-side.
class PasswordHasher {
  PasswordHasher._();

  static const _pepper = 'redime.mde.2026';

  static String hash(String plain) {
    final bytes = utf8.encode('$_pepper::$plain');
    return sha256.convert(bytes).toString();
  }

  static bool verify(String plain, String hashed) => hash(plain) == hashed;
}
