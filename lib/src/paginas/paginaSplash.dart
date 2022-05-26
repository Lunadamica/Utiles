import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/api/BBDD.dart';
import 'package:solucionutiles/src/datos/autentificacionCliente.dart';

import '../helpers/RespuestaHTTP.dart';
import '../modelos/sesion.dart';

class PaginaSplash extends StatefulWidget {
  PaginaSplash({Key? key}) : super(key: key);

  @override
  State<PaginaSplash> createState() => _PaginaSplashState();
}

class _PaginaSplashState extends State<PaginaSplash> {
  final _autentificacionCliente = GetIt.instance<AutentificacionCliente>();
  final BBDD _miBBDD = GetIt.instance<BBDD>();

  @override
  void initState() {
    super.initState();
    //Aseguramos que la vista ha sido renderizada
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    //Compruebo si tengo una sesion activa
    final token = await _autentificacionCliente.accessToken;

    //llamar al refreshToken pasandole el token
    if (token != null) {
      final RespuestaHTTP<Sesion> miRespuesta =
          await _miBBDD.refreshToken(tokenExpirado: token);

      if (miRespuesta.data != null) {
        Sesion miSesion;

        if (!GetIt.instance.isRegistered<Sesion>()) {
          //hacemos de la sesion que sea singleton
          GetIt.instance.registerSingleton<Sesion>(miRespuesta.data!);
        }

        miSesion = GetIt.instance<Sesion>();
        miSesion.token = miRespuesta.data!.token;
        miSesion.saveSession();
      } else {
        Navigator.pushReplacementNamed(context, 'login');
        return;
      }
    } else {
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }

    //Si la sesión es valida navegamos a home
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
