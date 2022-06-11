// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/modelos/maquina.dart';
import 'package:solucionutiles/src/modelos/zona.dart';
import 'package:solucionutiles/src/utils/responsive.dart';

import '../api/BBDD.dart';
import '../helpers/RespuestaHTTP.dart';
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
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  String casillero = '', util = '';
  String? opcionSeleccionada;
  List<Inventario>? miInventario;
  List<Inventario>? miBusqueda = [];
  Zona? miZona;
  Map<String?, int?> mapMin = <String?, int?>{};
  Map<String?, int?> mapMax = <String?, int?>{};
  List<Maquina>? misMaquinas;
  String? opcionSeleccionadaMa;
  Maquina? miMaquina;
  int? miCodigoFisico;
  final textControllerCasillero = TextEditingController();
  final textControllerUtil = TextEditingController();

  @override
  void initState() {
    super.initState();
    // cargarMaquinas();
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive(context);
    //Recibo los datos de parametros
    Map<dynamic, dynamic>? parametros =
        ModalRoute.of(context)!.settings.arguments as Map?;
    opcionSeleccionada = parametros!['opcionSeleccionada'] ?? 'Cliche';
    miInventario = parametros['miInventario'];
    misMaquinas = parametros['misMaquinas'];
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
                          //Controlador del texto
                          controlador: textControllerCasillero,
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
                          controlador: textControllerUtil,
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
                                textControllerCasillero.clear();
                                textControllerUtil.clear();
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
                                textControllerCasillero.clear();
                                textControllerUtil.clear();
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
                                textControllerCasillero.clear();
                                textControllerUtil.clear();
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
                                textControllerCasillero.clear();
                                textControllerUtil.clear();
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
        //Widget para refrescar y traer de vuelta todos los resultados
        child: RefreshIndicator(
          onRefresh: () async {
            textControllerCasillero.clear();
            textControllerUtil.clear();
            setState(() {
              miBusqueda!.clear();
              cargarDatos();
            });
          },
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
                      onLongPress: () {
                        miCodigoFisico = miInventario![i - 1].codigoUtilFisico;
                        _maquina(context);
                      },
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
                        'Casillero: ' +
                            miInventario![i - 1].codigoCasillero.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('Código $opcionSeleccionada: ' +
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
        ),
      );
      //Si hemos realizado un filtrado
    } else {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            textControllerCasillero.clear();
            textControllerUtil.clear();
            setState(() {
              miBusqueda!.clear();
              cargarDatos();
            });
          },
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
                      onLongPress: () {
                        miCodigoFisico = miInventario![i - 1].codigoUtilFisico;
                        _maquina(context);
                      },
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
                        'Casillero: ' +
                            miBusqueda![i].codigoCasillero.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('Código $opcionSeleccionada: ' +
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

  void _funcionDesabilitada(BuildContext context, String texto) {
    showDialog(
      context: context,
      //Si clicamos fuera del cuadro este no se cerrara
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Función deshabilitada'),
          content: Text(
              'Función deshabilitada por cambios de diseño en la app, no obtante los cambios serían: \n\n$texto'),
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

  void _maquina(BuildContext context) {
    showDialog(
      context: context,
      //Si clicamos fuera del cuadro este no se cerrara
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Envio a máquina'),
          content: SizedBox(
            height: 100,
            child: Column(
              children: <Widget>[
                const Text(
                    'Introduzca el número de la máquina al que se va a enviar:'),
                const SizedBox(
                  height: 10,
                ),
                _crearDropdown(),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                for (int i = 0; i < misMaquinas!.length; i++) {
                  if (misMaquinas![i].nombreMaquina == opcionSeleccionadaMa) {
                    miMaquina = misMaquinas![i];
                  }
                }
                // modificarMaquinas();
                String texto =
                    'Pasamos el util: $miCodigoFisico a la maquina con cod: ${miMaquina!.codMaquina} de nombre: ${miMaquina!.nombreMaquina}';

                Navigator.of(context).pop();
                _funcionDesabilitada(context, texto);
              },
              child: const Text('Aceptar'),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        );
      },
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = <DropdownMenuItem<String>>[];
    misMaquinas?.forEach((maquina) {
      lista.add(DropdownMenuItem(
        child: Text(maquina.nombreMaquina!),
        value: maquina.nombreMaquina,
      ));
    });
    return lista;
  }

  Widget _crearDropdown() {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 20,
        ),
        //Si no queremos que nuestro dropdown se expanda ocupando todo el espacio
        //simplemente lo sacamos fuera y eliminamos el widget
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                hint: const Text('Selecciona una máquina'),
                value: opcionSeleccionadaMa,
                iconSize: 36,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                items: getOpcionesDropdown(),
                onChanged: (opt) {
                  setState(() {
                    opcionSeleccionadaMa = opt as String;
                    Navigator.of(context).pop();
                    _maquina(context);
                  });
                }),
          ),
        )
      ],
    );
  }

  // Future<void> PasarAMaquina() async {
  //   String? valorUtil;
  //   if (opcionSeleccionada == TCliche) {
  //     valorUtil = tipoCliche;
  //   } else if (opcionSeleccionada == TTroquel) {
  //     valorUtil = tipoTroquel;
  //   }
  //   final RespuestaHTTP miRespuesta = await _miBBDD.PasarAMaquina(
  //       valorUtil, miCodigoFisico.toString(), miMaquina!.codMaquina.toString(),);

  //   if (miRespuesta.data != null) {
  //     print(miRespuesta.data);
  //   } else {
  //     mostrarMensaje(true, miRespuesta.error!.mensaje!);

  //     comprobarTipoError(context, miRespuesta.error!);
  //   }
  // }
}
