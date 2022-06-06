class Maquina {
  late int? codMaquina;
  late String? nombreMaquina;

  Maquina.origin() {
    codMaquina = 0;
    nombreMaquina = "";
  }

  Maquina({this.codMaquina, this.nombreMaquina});

  factory Maquina.fromJson(Map<String, dynamic> json) {
    return Maquina(
      codMaquina: json['CodigoMaquina'] as int,
      nombreMaquina: json['NombreMaquina'] as String,
    );
  }
}
