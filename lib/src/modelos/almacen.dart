class Almacen {
  late int? codigoSociedad;
  late int? codigoAlmacen;
  late String? nombreAlmacen;
  late int? tipo;

  Almacen.origin() {
    codigoSociedad = 0;
    codigoAlmacen = 0;
    nombreAlmacen = "";
    tipo = 0;
  }

  Almacen(
      {this.codigoSociedad, this.codigoAlmacen, this.nombreAlmacen, this.tipo});

  factory Almacen.fromJson(Map<String, dynamic> json) {
    return Almacen(
      codigoSociedad: json['codigoSociedad'] as int,
      codigoAlmacen: json['codigo'] as int,
      nombreAlmacen: json['nombre'] as String,
      tipo: json['tipo'] as int,
    );
  }
}
