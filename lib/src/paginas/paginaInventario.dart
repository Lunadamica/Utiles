import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/modelos/almacen.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/background.dart';

import '../api/BBDD.dart';
import '../helpers/RespuestaHTTP.dart';
import '../modelos/inventario.dart';
import '../modelos/zona.dart';
import '../widgets/listaInventario.dart';
import '../widgets/menuNavegacion.dart';

class PaginaInventario extends StatefulWidget {
  PaginaInventario({Key? key}) : super(key: key);

  @override
  State<PaginaInventario> createState() => _PaginaInventarioState();
}

class _PaginaInventarioState extends State<PaginaInventario> {
  String opcionSeleccionada = 'Cliche';
  String? opcionSeleccionadaAl;
  List<Almacen>? misAlmacenes;
  List<Inventario>? miInventario;
  bool isVisible = false;

  late String tipoUtil;
  String codAlmacen = '0';

  final BBDD _miBBDD = GetIt.instance<BBDD>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String casillero = '', piso = '';
  List<Zona>? misZonas = <Zona>[];

  @override
  Widget build(BuildContext context) {
    //Recibo el tipo de util desde el home
    Map<dynamic, dynamic>? parametros =
        ModalRoute.of(context)!.settings.arguments as Map?;
    opcionSeleccionada = parametros!['opcionSeleccionada'] ?? 'Cliche';
    misAlmacenes = parametros['misAlmacenes'];

    if (opcionSeleccionada == 'Cliche') {
      tipoUtil = tipoCliche;
    } else {
      tipoUtil = tipoTroquel;
    }

    return Scaffold(
      drawer: MenuNavegacion(),
      appBar: dameAppBar('Inventario', context),
      body: Stack(children: [
        Background(),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Almacén:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.brown,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _crearDropdown(),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isVisible,
                  child: Column(
                    children: [
                      ListaInventario(
                        lista: misZonas!,
                        tipo: tipoUtil,
                        miInventario: miInventario,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = <DropdownMenuItem<String>>[];
    misAlmacenes?.forEach((almacen) {
      lista.add(DropdownMenuItem(
        child: Text(almacen.nombreAlmacen!),
        value: almacen.nombreAlmacen,
      ));
    });
    return lista;
  }

  Widget _crearDropdown() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        //Si no queremos que nuestro dropdown se expanda ocupando todo el espacio
        //simplemente lo sacamos fuera y eliminamos el widget
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                hint: Text('Selecciona un Almacén'),
                value: opcionSeleccionadaAl,
                iconSize: 36,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                items: getOpcionesDropdown(),
                onChanged: (opt) {
                  setState(() {
                    opcionSeleccionadaAl = opt as String;
                  });
                  cargarZonas();
                }),
          ),
        )
      ],
    );
  }

  //Metodo para conseguir la lista de zonas segun el tipo
  Future<void> cargarZonas() async {
    for (int i = 0; i < misAlmacenes!.length; i++) {
      if (misAlmacenes![i].nombreAlmacen == opcionSeleccionadaAl) {
        codAlmacen = misAlmacenes![i].codigoAlmacen.toString();
      }
    }
    final RespuestaHTTP<List<Zona>> miRespuesta = await _miBBDD.dameZonasUtiles(
        tipo: tipoUtil, codigoAlmacen: codAlmacen, ancho: "0");

    if (miRespuesta.data != null) {
      misZonas = miRespuesta.data;
      isVisible = true;
      cargarInventario();
      setState(() {});
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }

  //Metodo que usamos para traer los datos de la base de datos y guardarlos en la lista
  Future<void> cargarInventario() async {
    for (int i = 0; i < misAlmacenes!.length; i++) {
      if (misAlmacenes![i].nombreAlmacen == opcionSeleccionadaAl) {
        codAlmacen = misAlmacenes![i].codigoAlmacen.toString();
      }
    }
    final RespuestaHTTP<List<Inventario>> miRespuesta =
        await _miBBDD.dameInventarioUtiles(
            tipo: tipoUtil,
            codigoUtil: "0",
            codigoAlmacen: codAlmacen,
            codigoZona: "0");

    if (miRespuesta.data != null) {
      miInventario = miRespuesta.data;
      setState(() {});
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }
}
