import 'package:shared_preferences/shared_preferences.dart';
import 'package:solucionutiles/src/modelos/sociedadUsuario.dart';

class Usuario {
  late int? iCodigo;
  late String? sUsuario;
  late String? sNombre;
  late String? sEmail;
  late int? iCodigoComercial;
  late int? iCodigoCliente;
  late int? iCodigoAlmacen;
  late String? sMensajeError;
  late String? sNombreCliente;
  late String? sNombreComercial;
  late String? sNombreCentroMontaje;
  late int? iVersionAPP;
  late String? sRutaActualizacionAPP;

  late SociedadUsuario? miSociedadSeleccionada;

  late List<SociedadUsuario>? misSociedades;
  late List<String>? misImpresoras;
  late String? sImpresoraSeleccionada;
  late bool? bCreado;

  Usuario.origin() {
    iCodigo = 0;
    sUsuario = "";
    sNombre = "";
    sEmail = "";
    iCodigoComercial = 0;
    iCodigoCliente = 0;
    iCodigoAlmacen = 0;
    sMensajeError = "";
    sNombreCliente = "";
    sNombreComercial = "";
    sNombreCentroMontaje = "";
    iVersionAPP = 0;
    miSociedadSeleccionada = SociedadUsuario();
    misSociedades = <SociedadUsuario>[];
    misImpresoras = <String>[];
    sImpresoraSeleccionada = "";
    sRutaActualizacionAPP = "";
    bCreado = false;
  }

  Usuario(
      {this.iCodigo,
      this.sUsuario,
      this.sNombre,
      this.iCodigoComercial,
      this.iCodigoCliente,
      this.iCodigoAlmacen,
      this.sMensajeError,
      this.misSociedades,
      this.sNombreCliente,
      this.sNombreComercial,
      this.sNombreCentroMontaje,
      this.sEmail,
      this.misImpresoras,
      this.sImpresoraSeleccionada,
      this.miSociedadSeleccionada,
      this.iVersionAPP,
      this.sRutaActualizacionAPP,
      this.bCreado});

  // void setImpresoraSeleccionada(String impresora) async {
  //   if (misImpresoras!.where((imp) => imp == impresora).toList().isNotEmpty) {
  //     sImpresoraSeleccionada =
  //         misImpresoras!.where((imp) => imp == impresora).toList().first;

  //     SharedPreferences miConfiguracion = await SharedPreferences.getInstance();
  //     miConfiguracion.setString("Impresora", sImpresoraSeleccionada!);
  //   } else {
  //     sImpresoraSeleccionada = "";
  //   }
  // }

  void setSociedadSeleccionada(int sociedad) {
    if (misSociedades!
        .where((soc) => soc.codigo == sociedad)
        .toList()
        .isNotEmpty) {
      miSociedadSeleccionada =
          misSociedades!.where((soc) => soc.codigo == sociedad).toList().first;
    } else {
      miSociedadSeleccionada = SociedadUsuario();
    }
  }

  bool get usuarioNormal {
    if (iCodigoCliente == 0 && iCodigoComercial == 0 && iCodigoAlmacen == 0) {
      return true;
    } else {
      return false;
    }
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    List<SociedadUsuario> sociedades = <SociedadUsuario>[];
    List<String> impresoras = <String>[];

    List<dynamic> sociedadesJson = json['Sociedades'];
    List<dynamic> impresorasJson = json['Impresoras'];

    for (var i = 0; i < impresorasJson.length; i++) {
      impresoras.add(impresorasJson[i]['Nombre']);
    }

    for (var i = 0; i < sociedadesJson.length; i++) {
      sociedades.add(SociedadUsuario.fromJson(sociedadesJson[i]));
    }

    return Usuario(
      iCodigo: json['Codigo'] as int,
      sUsuario: json['Usuario'] as String,
      sNombre: json['Nombre'] as String,
      iCodigoComercial: json['CodigoComercial'] as int,
      iCodigoCliente: json['CodigoCliente'] as int,
      iCodigoAlmacen: json['CodigoCentroMontaje'] as int,
      misSociedades: sociedades,
      sNombreCliente: json['NombreCliente'] as String,
      sNombreComercial: json['NombreComercial'] as String,
      sNombreCentroMontaje: json['NombreCentroMontaje'] as String,
      sEmail: json['Email'] as String,
      misImpresoras: impresoras,
      bCreado: true,
      sImpresoraSeleccionada: "",
      iVersionAPP: json['VersionAPP'] as int,
      sRutaActualizacionAPP: json['RutaActualizacion'] as String,
      miSociedadSeleccionada: new SociedadUsuario(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Usuario": sUsuario,
      "Codigo": iCodigo,
      "Nombre": sNombre,
      "CodigoComercial": iCodigoComercial,
      "CodigoCliente": iCodigoCliente,
      "CodigoCentroMontaje": iCodigoAlmacen,
      "Sociedades": misSociedades,
      "NombreCliente": sNombreCliente,
      "NombreComercial": sNombreComercial,
      "NombreCentroMontaje": sNombreCentroMontaje,
      "Email": sEmail,
      "ImpresoraSeleccionada": sImpresoraSeleccionada,
      "VersionAPP": iVersionAPP,
      "RutaActualizacion": sRutaActualizacionAPP
    };
  }

  int? get codigo => iCodigo;
  String? get username => sUsuario;
  String? get nombre => sNombre;
  int? get codigoComercial => iCodigoComercial;
  int? get codigoCliente => iCodigoCliente;
  int? get codigoCentroMontaje => iCodigoAlmacen;
  String? get nombreCliente => sNombreCliente;
  String? get nombreComercial => sNombreComercial;
  String? get nombreCentroMontaje => sNombreCentroMontaje;
  String? get email => sEmail?.trim();
  String? get mensajeError => sMensajeError;

  SociedadUsuario? get sociedadSeleccionada {
    if (miSociedadSeleccionada!.codigo == null) {
      if (misSociedades == null) {
        return SociedadUsuario.origin();
      } else {
        return misSociedades!.first;
      }
    } else {
      return miSociedadSeleccionada;
    }
  }

  int? get versionAPPActual => iVersionAPP;
  String? get rutaActualizacionAPP => sRutaActualizacionAPP;

  List<String>? get getImpresoras {
    if (misImpresoras == null) {
      return <String>[];
    } else {
      return misImpresoras;
    }
  }

  List<SociedadUsuario>? get getSociedades => misSociedades;

  /*void addImpresora(String impresora) {
    misImpresoras.add(impresora);
  }

  void addSociedad(SociedadUsuario sociedad) {
    misSociedades.add(sociedad);
  }*/

  /*Widget asociado() {
    if (this.iCodigoCliente > 0) {
      return labelBox("Cliente", this.nombreCliente, 100, 25, Alignment.centerLeft);
    } else {
      if (this.iCodigoComercial > 0) {
        return labelBox("Comercial", this.nombreComercial, 20, 20, Alignment.centerLeft);
      } else {
        if (this.iCodigoAlmacen > 0) {
          return labelBox("Almacen", this.nombreCentroMontaje, 20, 20, Alignment.centerLeft);
        } else {
          return Text("");
        }
      }
    }
  }*/
}
