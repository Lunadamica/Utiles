class Inventario {
  late int? codigoParteUtil;
  late int? codigoZona;
  late String? nombreZona;
  late int? codigoCasillero;
  late int? nombreCasillero;
  late int? codigoUtil;
  late int? codigoUtilFisico;
  late int? estadoUtil;

  Inventario.origin() {
    codigoParteUtil = 0;
    codigoZona = 0;
    nombreZona = "";
    codigoCasillero = 0;
    nombreCasillero = 0;
    codigoUtil = 0;
    codigoUtilFisico = 0;
    estadoUtil = 0;
  }

  Inventario(
      {this.codigoParteUtil,
      this.codigoZona,
      this.nombreZona,
      this.codigoCasillero,
      this.nombreCasillero,
      this.codigoUtil,
      this.codigoUtilFisico,
      this.estadoUtil});

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      codigoParteUtil: json['codigoParteUtil'] as int,
      codigoZona: json['codigoZona'] as int,
      nombreZona: json['nombreZona'] as String,
      codigoCasillero: json['codigoCasillero'] as int,
      nombreCasillero: json['nombreCasillero'] as int,
      codigoUtil: json['codigoUtil'] as int,
      codigoUtilFisico: json['codigoUtilFisico'] as int,
      estadoUtil: json['estadoUtil'] as int,
    );
  }
}
