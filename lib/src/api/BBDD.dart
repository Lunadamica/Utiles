import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/modelos/almacen.dart';
import 'package:solucionutiles/src/modelos/maquina.dart';
import 'package:solucionutiles/src/modelos/zona.dart';

import '../helpers/Http.dart';
import '../helpers/RespuestaHTTP.dart';
import '../modelos/cliche.dart';
import '../modelos/utilMaquina.dart';
import '../modelos/inventario.dart';
import '../modelos/sesion.dart';
import '../modelos/troquel.dart';
import '../modelos/usuario.dart';
import '../utils/utils.dart';

class BBDD {
  final Http _http;

  BBDD(this._http);

  Future<RespuestaHTTP<Sesion>> login({String? usuario, String? clave}) {
    String? _sUsuarioKey = encryptar(usuario!);
    String? _sClaveKey = encryptar(clave!);

    return _http.respuesta<Sesion>(
        "/login/usuario/$_sUsuarioKey/pass/$_sClaveKey",
        metodo: "GET",
        cadenaResultado: "LoginResult", parser: (datos) {
      Sesion miSesion = Sesion.fromJson(datos.first);
      return miSesion;
    });
  }

  Future<RespuestaHTTP<Sesion>> refreshToken({required String tokenExpirado}) {
    return _http.respuesta<Sesion>("/RefreshToken/Token/$tokenExpirado",
        metodo: "GET", cadenaResultado: "RefreshTokenResult", parser: (datos) {
      return Sesion.fromJson(datos.first);
    });
  }

  Future<RespuestaHTTP<String>> dameRutaFichero(
      {required String tipo, required String codigo}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;

    codigo = encryptar(codigo);
    tipo = encryptar(tipo);

    return _http.respuesta<String>(
        "/DameRutaFichero/token/$token/Tipo/$tipo/Codigo/$codigo",
        metodo: "GET",
        cadenaResultado: "DameRutaFicheroResult");
  }

  Future<RespuestaHTTP<Usuario>> dameInformacionUsuario() async {
    final Sesion miSesion = GetIt.instance<Sesion>();

    final token = await miSesion.accessToken;

    String sCodigoAPP = "4";
    sCodigoAPP = encryptar(sCodigoAPP);

    return _http.respuesta<Usuario>(
        "/DameDatosUsuario/Token/$token/CodigoAPP/$sCodigoAPP",
        metodo: "GET",
        cadenaResultado: "DameDatosUsuarioResult", parser: (datos) {
      return Usuario.fromJson(datos.first);
    });
  }

  Future<RespuestaHTTP<List<Cliche>>> dameCliches(
      {String? codigoCliche}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Cliche> misCliches = <Cliche>[];

    codigoCliche = encryptar(codigoCliche!);

    return _http.respuesta<List<Cliche>>(
        "/DameCliches/Token/$token/CodigoCliche/$codigoCliche",
        metodo: "GET",
        cadenaResultado: "DameClichesResult", parser: (datos) {
      List<dynamic> cliches = datos;

      for (var i = 0; i < cliches.length; i++) {
        misCliches.add(Cliche.fromJson(cliches[i] as Map<String, dynamic>));
      }

      return misCliches;
    });
  }

  Future<RespuestaHTTP<List<Troquel>>> dameTroqueles(
      {String? codigoTroquel}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Troquel> misTroqueles = <Troquel>[];

    codigoTroquel = encryptar(codigoTroquel!);

    return _http.respuesta<List<Troquel>>(
        "/DameTroqueles/Token/$token/CodigoTroquel/$codigoTroquel",
        metodo: "GET",
        cadenaResultado: "DameTroquelesResult", parser: (datos) {
      List<dynamic> troqueles = datos;

      for (var i = 0; i < troqueles.length; i++) {
        misTroqueles
            .add(Troquel.fromJson(troqueles[i] as Map<String, dynamic>));
      }

      return misTroqueles;
    });
  }

  Future<RespuestaHTTP<List<UtilMaquina>>> dameUtilesMaquina(
      {String? codigoMaquina, String? tipo}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<UtilMaquina> misDatosPtes = <UtilMaquina>[];

    codigoMaquina = encryptar(codigoMaquina!);
    tipo = encryptar(tipo!);

    return _http.respuesta<List<UtilMaquina>>(
        "/DameUtilesMaquina/Token/$token/CodigoMaquina/$codigoMaquina/Tipo/$tipo",
        metodo: "GET",
        cadenaResultado: "DameUtilesMaquinaResult", parser: (datos) {
      List<dynamic> datosPtes = datos;

      for (var i = 0; i < datosPtes.length; i++) {
        misDatosPtes
            .add(UtilMaquina.fromJson(datosPtes[i] as Map<String, dynamic>));
      }

      return misDatosPtes;
    });
  }

  Future<RespuestaHTTP<List<Almacen>>> dameAlmacenesUtiles(
      {String? tipo}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Almacen> misAlmacenes = <Almacen>[];

    tipo = encryptar(tipo!);

    return _http.respuesta<List<Almacen>>(
        "/DameAlmacenesUtilesAPP/Token/$token/Tipo/$tipo",
        metodo: "GET",
        cadenaResultado: "DameAlmacenesUtilesAPPResult", parser: (datos) {
      List<dynamic> almacenes = datos;

      for (var i = 0; i < almacenes.length; i++) {
        misAlmacenes
            .add(Almacen.fromJson(almacenes[i] as Map<String, dynamic>));
      }

      return misAlmacenes;
    });
  }

  Future<RespuestaHTTP<List<Zona>>> dameZonasUtiles(
      {String? tipo, String? codigoAlmacen, String? ancho}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Zona> misZonas = <Zona>[];

    codigoAlmacen = encryptar(codigoAlmacen!);
    ancho = encryptar(ancho!);
    tipo = encryptar(tipo!);

    return _http.respuesta<List<Zona>>(
        "/DameZonasUtilesAPP/Token/$token/Tipo/$tipo/CodigoAlmacen/$codigoAlmacen/AnchoMinimo/$ancho",
        metodo: "GET",
        cadenaResultado: "DameZonasUtilesAPPResult", parser: (datos) {
      List<dynamic> zonas = datos;

      for (var i = 0; i < zonas.length; i++) {
        misZonas.add(Zona.fromJson(zonas[i] as Map<String, dynamic>));
      }

      return misZonas;
    });
  }

  Future<RespuestaHTTP<List<Maquina>>> dameMaquinas() async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Maquina> misMaquinas = <Maquina>[];

    return _http.respuesta<List<Maquina>>("/DameMaquinas/Token/$token",
        metodo: "GET", cadenaResultado: "DameMaquinasResult", parser: (datos) {
      List<dynamic> maquinas = datos;

      for (var i = 0; i < maquinas.length; i++) {
        misMaquinas.add(Maquina.fromJson(maquinas[i] as Map<String, dynamic>));
      }

      return misMaquinas;
    });
  }

  Future<RespuestaHTTP> modificaMaquina(
      String? tipo, String? codigoFisico, String? codigoMaquina) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;

    codigoFisico = encryptar(codigoFisico!);
    codigoMaquina = encryptar(codigoMaquina!);
    tipo = encryptar(tipo!);

    return _http.respuesta(
        "/ModificaMaquina/Token/$token/Tipo/$tipo/codigoFisico/$codigoFisico/codigoMaquina/$codigoMaquina",
        metodo: "GET",
        cadenaResultado: "ModificaMaquinaResult");
  }

  Future<RespuestaHTTP<List<Inventario>>> dameInventarioUtiles(
      {String? tipo,
      String? codigoUtil,
      String? codigoAlmacen,
      String? codigoZona}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Inventario> misUtiles = <Inventario>[];

    tipo = encryptar(tipo!);
    codigoUtil = encryptar(codigoUtil!);
    codigoAlmacen = encryptar(codigoAlmacen!);
    codigoZona = encryptar(codigoZona!);

    return _http.respuesta<List<Inventario>>(
        "/DameInventarioUtilesAPP/Token/$token/Tipo/$tipo/CodigoUtil/$codigoUtil/CodigoAlmacen/$codigoAlmacen/CodigoZona/$codigoZona",
        metodo: "GET",
        cadenaResultado: "DameInventarioUtilesAPPResult", parser: (datos) {
      List<dynamic> utiles = datos;

      for (var i = 0; i < utiles.length; i++) {
        misUtiles.add(Inventario.fromJson(utiles[i] as Map<String, dynamic>));
      }

      return misUtiles;
    });
  }
}
