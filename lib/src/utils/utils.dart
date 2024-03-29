import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as AES;

import '../../main.dart';
import '../helpers/RespuestaHTTP.dart';

final int segundosMinimosConexion = 300;
final String sNombreAPP = 'pistolaBobinas';
final Color miColorGris = Color.fromARGB(-17, 209, 221, 230);
final Color miColorFondo = Color.fromARGB(-17, 155, 203, 235);
final Color miColorBotones = Color.fromARGB(-10, 0, 38, 58);
final Color? miColorFuente = Colors.grey[800];

final apiKey = "ondupackondupets";
final apiIV = "rpaSPvIvVLlrcmtz";

const int EstadoMateriaPrima_SinLeer = 0;
const int EstadoMateriaPrima_Activa = 1;
const int EstadoMateriaPrima_Ubicada = 2;
const int EstadoMateriaPrima_ConsumidaPulmon = 3;
const int EstadoMateriaPrima_ConsumidaMaquina = 4;
const int EstadoMateriaPrima_BajaInventario = 5;
const int EstadoMateriaPrima_Bloqueado = 6;
const int EstadoMateriaPrima_Perdida = 9;
const int EstadoMateriaPrima_BloqueadoParaConsumo = -3;
const int EstadoMateriaPrima_Devuelta = 10;
const int EstadoMateriaPrima_ARevisar = -2;
const int EstadoMateriaPrima_Todas = -2;

const String TipoMovimientoMateriaPrima_EntradaVariacionExistencias = "EV";
const String TipoMovimientoMateriaPrima_SalidaConsumoMaquina = "SM";
const String TipoMovimientoMateriaPrima_SalidaTirarCabo = "ST";
const String TipoMovimientoMateriaPrima_SalidaConsumidaPulmon = "SB";

final miEstiloMenuCabecera = new TextStyle(
    color: miColorBotones, fontSize: 25, backgroundColor: miColorGris);

final miEstiloTextFormField = new TextStyle(fontSize: 20.0);
final miEstiloTextNormal = new TextStyle(fontSize: 20.0, color: miColorBotones);
final miEstiloTextButton = new TextStyle(fontSize: 15.0, color: miColorBotones);

const String tipoCodigoServicioCorrecto = "0";
const String tipoCodigoServicioSesionCaducada = "1";
const String tipoCodigoServicioError = "2";
const String tipoCodigoServicioSinConexion = "-1";

//Tipo Util
final String tipoCliche = '0';
final String tipoTroquel = '1';
final String sinTipo = '';

//Estados
final String ningunoE = 'Vacío';
final String pendienteLlegarE = 'Pendiente';
final String activoE = 'Activo';
final String inactivoE = 'Inactivo';

//Estados
final String ningunoN = '-1';
final String pendienteLlegarN = '2';
final String activoN = '1';
final String inactivoN = '0';

//Color estados
final Color ninguno = Color.fromARGB(255, 211, 209, 209);
final Color activo = Color.fromARGB(255, 151, 243, 154);
final Color pendienteLlegar = Color.fromARGB(255, 233, 220, 106);
final Color inactivo = Color.fromARGB(255, 250, 153, 146);

//maximos
final int maximoCaracteresGRUPO = 3;
final int maximoCaracteresCodigoBarras = 8;
final int maximoCaracteresZona = 2;
final int maximoCaracteresClave = 10;
final int maximoCaracteresCasillero = 3;
final int maximoCaracteresArticulo = 7;
final int maximoCaracteresUsuario = 15;
final int maximoCaracteresGrupoArticulo = 9;
//minimos
final int minimoCaracteresUsuario = 4;

final Color colorBloqueadoLeyendaUbicacion = Colors.orange;
final Color colorLlenaLeyendaUbicacion = Colors.blueGrey;
final Color colorCapacidadMaximaLeyendaUbicacion = Colors.red;
final Color colorVaciaLeyendaUbicacion = Colors.lightGreen;
final Color colorNormalLeyendaUbicacion = miColorGris;

enum OpcionesElegirBobinas { BobinasTipo }

enum OpcionesFocus { Grupo, CodigoBarras, Radio, Zona, Casillero, Articulo }

enum OpcionesInterfaz {
  Ninguna,
  ColocarBobina,
  RetirarBobina,
  RecuperarUltimaBobina,
  ConsultarBobina,
  RetirarBobinaCompleta,
  ReimprimirEtiqueta,
  RetirarBobinaRadio
}

String encryptar(String texto) {
  try {
    if (texto.trim().length > 0) {
      final key = AES.Key.fromUtf8(apiKey); //.fromLength(32);
      final iv = AES.IV.fromUtf8(apiIV);
      final encrypter = AES.Encrypter(AES.AES(key, mode: AES.AESMode.cbc));

      texto = encrypter.encrypt(texto.trim(), iv: iv).base64;
      texto = Uri.encodeComponent(texto).replaceAll('%', '-');
    }

    return texto;
  } catch (error) {
    return '';
    // throw new TipoError("-2", error.toString());
  }
}

String desencryptar(String texto) {
  try {
    final key = AES.Key.fromUtf8(apiKey); //.fromLength(32);
    final iv = AES.IV.fromUtf8(apiIV);
    final encrypter = AES.Encrypter(AES.AES(key, mode: AES.AESMode.cbc));
    texto = texto.replaceAll('-', '%');
    texto = Uri.decodeComponent(texto);
    texto = encrypter.decrypt64(texto, iv: iv);

    return texto;
  } catch (error) {
    return '';
    //throw new TipoError("-2", error.toString());
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

void mostrarNotificacion(BuildContext context, String titulo, String mensaje) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(mensaje),
      );
    },
  );
}

void comprobarTipoError(BuildContext context, HttpError error) {
  switch (error.codigo.toString()) {
    case tipoCodigoServicioSesionCaducada:
      {
        RestartWidget.restartApp(context);
      }
      break;
    case tipoCodigoServicioSinConexion:
      {
        Navigator.pushNamed(context, "/login");
      }
      break;
    default:
      {}
      break;
  }
}

void ocultarTeclado(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

Widget textBox(String texto, double sizeText) {
  return Container(
    padding: EdgeInsets.all(2),
    margin: EdgeInsets.fromLTRB(0, 2, 2, 2),
    child: Flexible(
      child: Text(texto,
          style: new TextStyle(fontSize: sizeText),
          overflow: TextOverflow.ellipsis),
    ),
    decoration: new BoxDecoration(border: Border.all(color: miColorBotones)),
  );
}

Widget labelBox(String textoCabecera, String texto, double ancho,
    double sizeText, Alignment alineacion) {
  return Container(
    // width: ancho,
    child: Row(children: <Widget>[
      Container(
          width: 65,
          child: RichText(
              text: TextSpan(
                  text: textoCabecera,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: miColorBotones,
                      fontSize: sizeText)))),
      SizedBox(
        width: 5,
      ),
      Container(
          width: ancho,
          alignment: alineacion,
          color: Colors.black,
          child: Flexible(
              child: Text(texto,
                  style: TextStyle(color: Colors.green, fontSize: sizeText),
                  overflow: TextOverflow.ellipsis))),
      SizedBox(
        width: 5,
      ),
    ]),
  );
}

String pasarSegundosAHoras(int segundos) {
  try {
    String sHoras;
    String sMinutos;
    String sSegundos;

    int iMinutos;
    int iHoras;
    int iSegundos;
    int iSegundosHora = 3600;

    iHoras = (segundos ~/ iSegundosHora).round();
    iMinutos = ((segundos % iSegundosHora) ~/ 60).round();
    iSegundos = ((segundos % iSegundosHora) % 60);

    if (iHoras < 10) {
      sHoras = '0' + iHoras.toString();
    } else {
      sHoras = iHoras.toString();
    }

    if (iMinutos < 10) {
      sMinutos = '0' + iMinutos.toString();
    } else {
      sMinutos = iMinutos.toString();
    }

    if (iSegundos < 10) {
      sSegundos = '0' + iSegundos.toString();
    } else {
      sSegundos = '0' + iSegundos.toString();
    }

    return sHoras + ":" + sMinutos + ":" + sSegundos;
  } catch (err) {
    return "00:00:00";
  }
}

String formatearEntero(int numero) {
  List<String> parts = numero.toString().split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, '.');

  return parts[0];
}

String formatearDecimales(double numero) {
  List<String> parts = numero.toString().split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, '.');
  if (parts.length == 1) {
    parts.add('00');
  } else {
    parts[1] = parts[1].padRight(2, '0').substring(0, 2);
  }
  return parts.join(',');
}

AppBar dameAppBar(String titulo, dynamic context) {
  return AppBar(
    title: Text(titulo),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(
          Icons.home,
        ),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'home',
            (_) => false,
          );
        },
      )
    ],
    //le ponemos una elevacion/sombra
    elevation: 20,
    //Damos los colores a nuestra appbar
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 194, 140, 78),
          Colors.brown,
        ], begin: Alignment.bottomRight, end: Alignment.topLeft),
      ),
    ),
  );
}

SnackBar dameSnackBar({String? titulo, bool? error}) {
  Color miColor = Colors.red;
  if (error == false) {
    miColor = Colors.blueGrey;
  }
  return new SnackBar(
      backgroundColor: miColor,
      content: Container(
          height: 50.0,
          child: new Text(
            titulo!,
            style: TextStyle(fontSize: 20),
          )));
}
