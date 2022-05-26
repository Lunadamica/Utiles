import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:solucionutiles/src/api/BBDD.dart';
import 'package:solucionutiles/src/utils/utils.dart';

class Sesion {
  String token;
  int segundosExpiracion;
  DateTime fecha;
  String usuario;

  final FlutterSecureStorage? secureStorage;

  Completer? _completer;

  Sesion({
    required this.token,
    required this.segundosExpiracion,
    required this.fecha,
    required this.usuario,
    this.secureStorage,
  });

  static Sesion fromJson(Map<String, dynamic> json) {
    final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    return Sesion(
        token: json['Token'],
        segundosExpiracion: json['SegundosExpiracion'],
        fecha: DateTime.parse(json['Fecha']),
        usuario: json['Usuario'],
        secureStorage: _secureStorage);
  }

  Map<String, dynamic> toJson() {
    return {
      "Token": this.token,
      "SegundosExpiracion": this.segundosExpiracion,
      "Fecha": this.fecha.toIso8601String(),
      "Usuario": this.usuario
    };
  }

  Future<void> saveSession() async {
    final data = jsonEncode(toJson());

    await secureStorage!.write(key: 'SESSION', value: data);
  }

  Future<void> closeSession() async {
    secureStorage!.delete(key: 'SESSION');
  }

  void _completo() {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete();
    }
  }

  Future<String?> get accessToken async {
    if (_completer != null) {
      await _completer!.future;
    }

    _completer =
        Completer(); //esto hace que solo se ejecute una vez en el caso de que se hagan varias llamadas.

    final data = await secureStorage!.read(key: 'SESSION');

    if (data != null) {
      fromJson(jsonDecode(data));

      final DateTime fechaActual = DateTime.now();
      final DateTime fechaSesion = this.fecha;

      final diff = fechaActual.difference(fechaSesion).inSeconds;

      //  Logs.log.i("Segundos sesion: ${this.segundosExpiracion - diff}");

      if (this.segundosExpiracion - diff > segundosMinimosConexion) {
        _completo();
        return this.token;
      } else {
        final _miBBDD = GetIt.instance<BBDD>();
        final response = await _miBBDD.refreshToken(tokenExpirado: this.token);
        if (response.data != null) {
          this.token = response.data!.token;
          this.segundosExpiracion = response.data!.segundosExpiracion;
          this.fecha = response.data!.fecha;
          this.usuario = response.data!.usuario;

          await this.saveSession();
          _completo();
          return response.data!.token;
        } else {
          _completo();
          return null;
        }
      }
    } else {
      _completo();
      return null;
    }
  }
}
