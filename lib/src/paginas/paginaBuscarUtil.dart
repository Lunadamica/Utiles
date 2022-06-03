// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/helpers/RespuestaHTTP.dart';
import 'package:solucionutiles/src/modelos/almacen.dart';
import 'package:solucionutiles/src/utils/responsive.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/background.dart';
import 'package:solucionutiles/src/widgets/input_text.dart';

import '../api/BBDD.dart';
import '../modelos/cliche.dart';
import '../modelos/troquel.dart';
import '../widgets/datosBusqueda.dart';
import '../widgets/menuNavegacion.dart';

class PaginaBuscarUtil extends StatefulWidget {
  const PaginaBuscarUtil({Key? key}) : super(key: key);

  @override
  State<PaginaBuscarUtil> createState() => _PaginaBuscarUtilState();
}

class _PaginaBuscarUtilState extends State<PaginaBuscarUtil> {
  bool isVisible = true;
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  //Creamos un contador aux que ayude a la hora de traer los datos de la busqueda
  //desde el inventario porque si trabajamos con estado tiende a hacer un bucle
  //infinito mientras que de esta manera nos aseguramos de que entre una sola vez
  int contador = 0;

  //Asignamos un valor por defecto
  String opcionSeleccionada = 'Cliche';

  String codigoUtil = '';
  List<Cliche>? _misCliches = <Cliche>[];
  List<Troquel>? _misTroqueles = <Troquel>[];
  List<Almacen>? misAlmacenes;

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    //Recibo el tipo de util desde el home
    Map<dynamic, dynamic>? parametros =
        ModalRoute.of(context)!.settings.arguments as Map?;
    opcionSeleccionada = parametros!['opcionSeleccionada'] ?? 'Cliche';
    misAlmacenes = parametros['misAlmacenes'];

    //Controlamos que esto solo se ejecute una vez y si se cumplen las condiciones deseadas
    if (contador == 0) {
      codigoUtil = parametros['codUtil'] ?? '';
      if (codigoUtil != "") {
        if (opcionSeleccionada == 'Cliche') {
          cargarCliches();
        } else {
          cargarTroqueles();
        }
        isVisible = !isVisible;
      }
      contador++;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        drawer: MenuNavegacion(
            opcionSeleccionada: opcionSeleccionada, misAlmacenes: misAlmacenes),
        appBar: dameAppBar('Buscador ' + opcionSeleccionada, context),
        body: Stack(children: [
          Background(),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: isVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Número:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.brown,
                                  width: 2,
                                ),
                              ),
                              child: InputText(
                                label: 'Introduzca el código útil',
                                fontSize: 17,
                                //Cargamos los datos haciendo uso del boton del teclado
                                onFieldSubmitted: (_) {
                                  if (opcionSeleccionada == 'Cliche') {
                                    cargarCliches();
                                  } else {
                                    cargarTroqueles();
                                  }
                                  isVisible = !isVisible;
                                },
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  codigoUtil = text;
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  //Botón de nueva consulta
                  Visibility(
                    visible: !isVisible,
                    child: Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: RaisedButton(
                          shape: Border.all(
                            color: Colors.black38,
                            width: 2,
                          ),
                          color: const Color.fromARGB(255, 194, 140, 78),
                          onPressed: () {
                            setState(() {
                              _misCliches = null;
                              _misTroqueles = null;
                              isVisible = !isVisible;
                            });
                          },
                          child: Text(
                            'Nueva consulta',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: responsive.hp(1.7)),
                          )),
                    ),
                  ),
                  if (opcionSeleccionada == 'Cliche')
                    DatosBusqueda(
                      listaCliche: _misCliches ?? [],
                      context: context,
                    )
                  else
                    DatosBusqueda(
                      listaTroquel: _misTroqueles ?? [],
                      context: context,
                    )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  //Metodo que usamos para traer los datos de la base de datos y guardarlos en la lista
  Future<void> cargarCliches() async {
    final RespuestaHTTP<List<Cliche>> miRespuesta =
        await _miBBDD.dameCliches(codigoCliche: codigoUtil);

    if (miRespuesta.data != null) {
      _misCliches = miRespuesta.data;
      setState(() {});
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }

  //Metodo que usamos para traer los datos de la base de datos y guardarlos en la lista
  Future<void> cargarTroqueles() async {
    final RespuestaHTTP<List<Troquel>> miRespuesta =
        await _miBBDD.dameTroqueles(codigoTroquel: codigoUtil);

    if (miRespuesta.data != null) {
      _misTroqueles = miRespuesta.data;
      setState(() {});
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }
}
