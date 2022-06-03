import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solucionutiles/src/modelos/authenticationResponse.dart';
import 'package:solucionutiles/src/modelos/sesion.dart';

class AutentificacionCliente {
  final FlutterSecureStorage _secureStorage;

  AutentificacionCliente(this._secureStorage);

  Future<String?> get accessToken async {
    final data = await _secureStorage.read(key: 'SESSION');
    if (data != null) {
      final sesion = Sesion.fromJson(jsonDecode(data));
      return sesion.token;
    }
    return null;
  }

  Future<void> saveSession(
      AuthenticationResponse authenticationResponse) async {
    final Sesion sesion = Sesion(
      token: authenticationResponse.token,
      usuario: authenticationResponse.usuario,
      segundosExpiracion: authenticationResponse.segundosExpiracion,
      fecha: DateTime.now(),
    );

    final data = jsonEncode(sesion.toJson());
    await _secureStorage.write(key: 'SESSION', value: data);
  }

  Future<void> signOut() async {
    await _secureStorage.deleteAll();
  }
}
