import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/datos/autentificacionCliente.dart';
import 'package:solucionutiles/src/helpers/Http.dart';

import '../api/BBDD.dart';

abstract class Dependencia {
  static void inicializar() {
    const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    GetIt.instance.registerSingleton<FlutterSecureStorage>(_secureStorage);

    // String sUrl = "http://10.0.2.2:8091/Service1.svc";
    String sUrl = "http://199.5.84.237:8092/Service1.svc/";
    //String sUrl = "http://199.5.84.237:8090/Service1.svc/";
    //String sUrl = "http://80.26.155.246:8090/Service1.svc";
    final Dio _dio = Dio(BaseOptions(baseUrl: sUrl));

    Http http = Http(
      dio: _dio,
    );

    final BBDD miBBDD = BBDD(http);

    final autentificacionCliente = AutentificacionCliente(_secureStorage);

    //final UsuarioAPI usuarioAPI = UsuarioAPI(http, authenticationCliente);

    GetIt.instance.registerSingleton<BBDD>(miBBDD);

    GetIt.instance
        .registerSingleton<AutentificacionCliente>(autentificacionCliente);
    //GetIt.instance.registerSingleton<UsuarioAPI>(usuarioAPI);
  }
}
