class Zona {
  late int? codZona;
  late int? codSociedad;
  late int? codAlmacen;
  late String? nombreZona;
  late int? ancho;
  late String? nombreAlmacen;
  late int? numeroCasilleros;
  late int? totalUtiles;

  Zona.origin() {
    codZona = 0;
    codSociedad = 0;
    codAlmacen = 0;
    nombreZona = "";
    ancho = 0;
    nombreAlmacen = "";
    numeroCasilleros = 0;
    totalUtiles = 0;
  }

  Zona(
      {this.codZona,
      this.codSociedad,
      this.codAlmacen,
      this.nombreZona,
      this.ancho,
      this.nombreAlmacen,
      this.numeroCasilleros,
      this.totalUtiles});

  factory Zona.fromJson(Map<String, dynamic> json) {
    return Zona(
      codZona: json['codigo'] as int,
      codSociedad: json['codigoSociedad'] as int,
      codAlmacen: json['codigoAlmacen'] as int,
      nombreZona: json['nombre'] as String,
      ancho: json['ancho'] as int,
      nombreAlmacen: json['nombreAlmacen'] as String,
      numeroCasilleros: json['numeroCasilleros'] as int,
      totalUtiles: json['totalUtiles'] as int,
    );
  }
}
