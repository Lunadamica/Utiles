class UtilMaquina {
  late int? codMaquina;
  late String? maquina;
  late int? orden;
  late int? codUtil;
  late bool? enMaquina;
  late double? porcentaje;
  late int? idFabricacion;

  UtilMaquina.origin() {
    codMaquina = 0;
    maquina = "";
    orden = 0;
    codUtil = 0;
    enMaquina = false;
    porcentaje = 0;
    idFabricacion = 0;
  }

  UtilMaquina(
      {this.codMaquina,
      this.maquina,
      this.orden,
      this.codUtil,
      this.enMaquina,
      this.porcentaje,
      this.idFabricacion});

  factory UtilMaquina.fromJson(Map<String, dynamic> json) {
    return UtilMaquina(
        codMaquina: json['Codigo'] as int,
        maquina: json['Nombre'] as String,
        orden: json['Orden'] as int,
        codUtil: json['CodUtil'] as int,
        enMaquina: json['EnMaquina'] as bool,
        porcentaje: json['Porcentaje'] as double,
        idFabricacion: json['IdFabricacion'] as int);
  }
}
