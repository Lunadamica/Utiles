class DatosPtes {
  late int? codMaquina;
  late String? maquina;
  late int? orden;
  late int? codCliche;
  late bool? enMaquina;

  DatosPtes.origin() {
    codMaquina = 0;
    maquina = "";
    orden = 0;
    codCliche = 0;
    enMaquina = false;
  }

  DatosPtes(
      {this.codMaquina,
      this.maquina,
      this.orden,
      this.codCliche,
      this.enMaquina});

  factory DatosPtes.fromJson(Map<String, dynamic> json) {
    return DatosPtes(
      codMaquina: json['Codigo'] as int,
      maquina: json['Nombre'] as String,
      orden: json['Orden'] as int,
      codCliche: json['CodCliche'] as int,
      enMaquina: json['EnMaquina'] as bool,
    );
  }
}
