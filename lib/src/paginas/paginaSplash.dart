import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/api/BBDD.dart';
import 'package:solucionutiles/src/datos/autentificacionCliente.dart';
import 'package:solucionutiles/src/utils/responsive.dart';

import '../helpers/RespuestaHTTP.dart';
import '../modelos/sesion.dart';

//Ventana de carga
class PaginaSplash extends StatefulWidget {
  const PaginaSplash({Key? key}) : super(key: key);

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

    //Si tenemos un token llamamos al refreshToken para refrescarlo
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
        //Si no tenemos la sesion iniciada navegamos al login
        Navigator.pushReplacementNamed(context, 'login');
        return;
      }
    } else {
      //Si no tenemos un token navegamos al login
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }

    //Si la sesión es valida navegamos a home
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: const CircularProgressIndicator(),
          height: responsive.hp(7),
          width: responsive.hp(7),
        ),
      ),
    );
  }
}
