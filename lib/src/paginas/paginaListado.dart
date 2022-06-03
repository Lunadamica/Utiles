// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:solucionutiles/src/modelos/zona.dart';
import 'package:solucionutiles/src/utils/responsive.dart';

import '../modelos/inventario.dart';
import '../utils/utils.dart';
import '../widgets/background.dart';
import '../widgets/input_text.dart';

class PaginaListado extends StatefulWidget {
  const PaginaListado({Key? key}) : super(key: key);

  @override
  State<PaginaListado> createState() => _PaginaListadoState();
}

class _PaginaListadoState extends State<PaginaListado> {
  String casillero = '', util = '';
  String? opcionSeleccionada;
  List<Inventario>? miInventario;
  List<Inventario>? miBusqueda = [];
  Zona? miZona;
  Map<String?, int?> mapMin = <String?, int?>{};
  Map<String?, int?> mapMax = <String?, int?>{};

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive(context);
    //Recibo los datos de parametros
    Map<dynamic, dynamic>? parametros =
        ModalRoute.of(context)!.settings.arguments as Map?;
    opcionSeleccionada = parametros!['opcionSeleccionada'] ?? 'Cliche';
    miInventario = parametros['miInventario'];
    miZona = parametros['miZona'];
    mapMin = parametros['mapMin'];
    mapMax = parametros['mapMax'];

    //Con gestureDetector hacemos que siempre se guarde el teclado cuando pinchemos fuera
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // drawer: MenuNavegacion(),
        appBar: dameAppBar('Lista de datos', context),
        body: Stack(
          children: [
            Background(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        width: size.width / 2.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.brown,
                            width: 2,
                          ),
                        ),
                        child: InputText(
                          keyboardType: TextInputType.number,
                          label: 'Casillero',
                          onChanged: (text) {
                            casillero = text;
                          },
                          //Función al hacer enter en el filtrado de casillero
                          onFieldSubmitted: (_) {
                            //Limpiamos de busquedas anteriores
                            miBusqueda!.clear();
                            //recorro mi inventario y guardo en una lista los resultados de mis busqueda
                            for (int i = 0; i < miInventario!.length; i++) {
                              if (miInventario![i]
                                      .codigoCasillero
                                      .toString()
                                      .contains(casillero) &&
                                  miInventario![i].nombreZona ==
                                      miZona!.nombreZona &&
                                  miInventario![i]
                                      .codigoUtil
                                      .toString()
                                      .contains(util)) {
                                miBusqueda!.add(miInventario![i]);
                              }
                            }
                            if (miBusqueda!.isEmpty) {
                              _alerta(context);
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        width: size.width / 2.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.brown,
                            width: 2,
                          ),
                        ),
                        child: InputText(
                          keyboardType: TextInputType.number,
                          label: 'Código útil',
                          onChanged: (text) {
                            util = text;
                          },
                          //Función de buscar con enter
                          onFieldSubmitted: (_) {
                            //Limpiamos de busquedas anteriores
                            miBusqueda!.clear();
                            //recorro mi inventario y guardo en una lista los resultados de mis busqueda
                            for (int i = 0; i < miInventario!.length; i++) {
                              if (miInventario![i]
                                      .codigoUtil
                                      .toString()
                                      .contains(util) &&
                                  miInventario![i].nombreZona ==
                                      miZona!.nombreZona &&
                                  miInventario![i]
                                      .codigoCasillero
                                      .toString()
                                      .contains(casillero)) {
                                miBusqueda!.add(miInventario![i]);
                              }
                            }
                            if (miBusqueda!.isEmpty) {
                              _alerta(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                cargarDatos(),
                //Botonera de filtrado
                SizedBox(
                  height: size.hp(10),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(size.dp(1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //Boton de busqueda estado activo
                            FlatButton(
                              onPressed: () {
                                miBusqueda!.clear();
                                for (int i = 0; i < miInventario!.length; i++) {
                                  if (miInventario![i].estadoUtil.toString() ==
                                          activoN &&
                                      miInventario![i].nombreZona ==
                                          miZona!.nombreZona) {
                                    miBusqueda!.add(miInventario![i]);
                                  }
                                }
                                if (miBusqueda!.isEmpty) {
                                  _alerta(context);
                                }
                                setState(() {});
                              },
                              child: Text(activoE),
                              color: activo,
                            ),
                            //Boton de busqueda estado pendiente
                            FlatButton(
                              onPressed: () {
                                miBusqueda!.clear();
                                for (int i = 0; i < miInventario!.length; i++) {
                                  if (miInventario![i].estadoUtil.toString() ==
                                          pendienteLlegarN &&
                                      miInventario![i].nombreZona ==
                                          miZona!.nombreZona) {
                                    miBusqueda!.add(miInventario![i]);
                                  }
                                }
                                if (miBusqueda!.isEmpty) {
                                  _alerta(context);
                                }
                                setState(() {});
                              },
                              child: Text(pendienteLlegarE),
                              color: pendienteLlegar,
                            ),
                            //Boton de busqueda estado inactivo
                            FlatButton(
                              onPressed: () {
                                miBusqueda!.clear();
                                for (int i = 0; i < miInventario!.length; i++) {
                                  if (miInventario![i].estadoUtil.toString() ==
                                          inactivoN &&
                                      miInventario![i].nombreZona ==
                                          miZona!.nombreZona) {
                                    miBusqueda!.add(miInventario![i]);
                                  }
                                }
                                if (miBusqueda!.isEmpty) {
                                  _alerta(context);
                                }
                                setState(() {});
                              },
                              child: Text(inactivoE),
                              color: inactivo,
                            ),
                            //Boton de busqueda estado ninguno
                            FlatButton(
                              onPressed: () {
                                miBusqueda!.clear();
                                for (int i = 0; i < miInventario!.length; i++) {
                                  if (miInventario![i].estadoUtil.toString() ==
                                          ningunoN &&
                                      miInventario![i].nombreZona ==
                                          miZona!.nombreZona) {
                                    miBusqueda!.add(miInventario![i]);
                                  }
                                }
                                if (miBusqueda!.isEmpty) {
                                  _alerta(context);
                                }
                                setState(() {});
                              },
                              child: Text(ningunoE),
                              color: ninguno,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cargarDatos() {
    //Si no hemos realizado un filtrado
    if (miBusqueda!.isEmpty) {
      return Expanded(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            for (int i = mapMin[miZona!.nombreZona]!;
                i <= mapMax[miZona!.nombreZona]!;
                i++)
              Card(
                color: obtenerColor(i),
                //Creación de sombra de la tarjeta
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  ListTile(
                    onTap: () {
                      if (miInventario![i - 1].estadoUtil! > -1) {
                        Navigator.pushNamed(context, 'buscador',
                            //argumentos que manda los datos desde la lista de inventario
                            arguments: {
                              'opcionSeleccionada': opcionSeleccionada,
                              'codUtil':
                                  miInventario![i - 1].codigoUtil.toString(),
                            });
                      }
                    },
                    title: Text(
                      'Casillero: ' + i.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Código Cliché: ' +
                          miInventario![i - 1].codigoUtil.toString() +
                          '\n\nParte: ' +
                          miInventario![i - 1].codigoParteUtil.toString()),
                    ),
                    trailing: Text('Estado: ' + obtenerEstado(i)),
                  ),
                ]),
              )
          ],
        ),
      );
      //Si hemos realizado un filtrado
    } else {
      return Expanded(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            for (int i = 0; i < miBusqueda!.length; i++)
              Card(
                color: obtenerColor(i),
                //Creación de sombra de la tarjeta
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  ListTile(
                    onTap: () {
                      if (miBusqueda![i].estadoUtil! > -1) {
                        Navigator.pushNamed(context, 'buscador',
                            //argumentos que manda los datos desde la lista de inventario
                            arguments: {
                              'opcionSeleccionada': opcionSeleccionada,
                              'codUtil': miBusqueda![i].codigoUtil.toString(),
                            });
                      }
                    },
                    title: Text(
                      'Casillero: ' + miBusqueda![i].codigoCasillero.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Código útil: ' +
                          miBusqueda![i].codigoUtil.toString() +
                          '\n\nParte: ' +
                          miBusqueda![i].codigoParteUtil.toString()),
                    ),
                    trailing: Text('Estado: ' + obtenerEstado(i)),
                  ),
                ]),
              )
          ],
        ),
      );
    }
  }

  Color obtenerColor(int? i) {
    if (miBusqueda!.isEmpty) {
      switch (miInventario![i! - 1].estadoUtil) {
        case 1:
          return activo;
        case 2:
          return pendienteLlegar;
        case -1:
          return ninguno;
        case 0:
          return inactivo;
        default:
          return ninguno;
      }
    } else {
      switch (miBusqueda![i!].estadoUtil) {
        case 1:
          return activo;
        case 2:
          return pendienteLlegar;
        case -1:
          return ninguno;
        case 0:
          return inactivo;
        default:
          return ninguno;
      }
    }
  }

  String obtenerEstado(int? i) {
    if (miBusqueda!.isEmpty) {
      switch (miInventario![i! - 1].estadoUtil) {
        case 1:
          return activoE;
        case 2:
          return pendienteLlegarE;
        case -1:
          return ningunoE;
        case 0:
          return inactivoE;
        default:
          return ningunoE;
      }
    } else {
      switch (miBusqueda![i!].estadoUtil) {
        case 1:
          return activoE;
        case 2:
          return pendienteLlegarE;
        case -1:
          return ningunoE;
        case 0:
          return inactivoE;
        default:
          return ningunoE;
      }
    }
  }

  void _alerta(BuildContext context) {
    showDialog(
      context: context,
      //Si clicamos fuera del cuadro este no se cerrara
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Busqueda fallida'),
          content:
              const Text('En esta zona no existen datos para esa busqueda'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        );
      },
    );
  }
}
