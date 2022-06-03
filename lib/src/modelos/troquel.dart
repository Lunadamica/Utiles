class Troquel {
  late int? codSociedad;
  late int? codUtil;
  late int? codFisico;
  late int? codParte;
  late int? codAlmacen;
  late String? nombreAl;
  late int? tipoAl;
  late int? codZona;
  late String? nombreZo;
  late int? anchoZo;
  late int? codCasillero;
  late int? nombreCa;
  late int? anchoCa;
  late int? tipoCa;
  late int? codMaquina;
  late int? largo;
  late int? anchoUtil;
  late int? codEstado;
  late String? nomEstado;
  late int? fechaCambioUtil;
  late int? fechaPrLlegada;
  late String? causa;
  late int? codCliente;
  late String? nomCliente;
  late int? codPieza;
  late int? codSubpieza;
  late String? referencia;
  late String? observaciones;
  Troquel.origin() {
    codSociedad = 0;
    codUtil = 0;
    codFisico = 0;
    codParte = 0;
    codAlmacen = 0;
    nombreAl = "";
    tipoAl = 0;
    codZona = 0;
    nombreZo = "";
    anchoZo = 0;
    codCasillero = 0;
    nombreCa = 0;
    anchoCa = 0;
    tipoCa = 0;
    codMaquina = 0;
    largo = 0;
    anchoUtil = 0;
    codEstado = 0;
    nomEstado = "";
    fechaCambioUtil = 0;
    fechaPrLlegada = 0;
    causa = "";
    codCliente = 0;
    nomCliente = "";
    codPieza = 0;
    codSubpieza = 0;
    referencia = "";
    observaciones = "";
  }
  Troquel({
    this.codSociedad,
    this.codUtil,
    this.codFisico,
    this.codParte,
    this.codAlmacen,
    this.nombreAl,
    this.tipoAl,
    this.codZona,
    this.nombreZo,
    this.anchoZo,
    this.codCasillero,
    this.nombreCa,
    this.anchoCa,
    this.tipoCa,
    this.codMaquina,
    this.largo,
    this.anchoUtil,
    this.codEstado,
    this.nomEstado,
    this.fechaCambioUtil,
    this.fechaPrLlegada,
    this.causa,
    this.codCliente,
    this.nomCliente,
    this.codPieza,
    this.codSubpieza,
    this.referencia,
    this.observaciones,
  });

  factory Troquel.fromJson(Map<String, dynamic> json) {
    return Troquel(
      codSociedad: json['CodSociedad'] as int,
      codUtil: json['CodUtil'] as int,
      codFisico: json['CodFisico'] as int,
      codParte: json['CodPartes'] as int,
      codAlmacen: json['CodAlmacen'] as int,
      nombreAl: json['NombreAlmacen'] as String,
      tipoAl: json['CodigoTipo'] as int,
      codZona: json['CodZona'] as int,
      nombreZo: json['NombreZona'] as String,
      anchoZo: json['AnchoZona'] as int,
      codCasillero: json['CodCasillero'] as int,
      nombreCa: json['NombreCasillero'] as int,
      anchoCa: json['AnchoCasillero'] as int,
      tipoCa: json['CasilleroTipo'] as int,
      codMaquina: json['CodMaquina'] as int,
      largo: json['Largo'] as int,
      anchoUtil: json['AnchoUtil'] as int,
      codEstado: json['EstadoUtil'] as int,
      nomEstado: json['EstadoNombre'] as String,
      fechaCambioUtil: json['FechaCambioU'] as int,
      fechaPrLlegada: json['FechaPrLlegada'] as int,
      causa: json['Causa'] as String,
      codCliente: json['CodigoCliente'] as int,
      nomCliente: json['NombreCliente'] as String,
      codPieza: json['CodigoPieza'] as int,
      codSubpieza: json['CodigoSubpieza'] as int,
      referencia: json['Referencia'] as String,
      observaciones: json['Observaciones'] as String,
    );
  }
}
