import 'package:flutter/material.dart';
import 'package:solucionutiles/src/modelos/zona.dart';
import 'package:solucionutiles/src/utils/responsive.dart';

import '../modelos/inventario.dart';
import '../utils/utils.dart';
import '../widgets/background.dart';
import '../widgets/input_text.dart';
import '../widgets/menuNavegacion.dart';

class PaginaListado extends StatefulWidget {
  PaginaListado({Key? key}) : super(key: key);

  @override
  State<PaginaListado> createState() => _PaginaListadoState();
}

class _PaginaListadoState extends State<PaginaListado> {
  String casillero = '', util = '';
  List<Inventario>? miInventario;
  Zona? miZona;
  Map<String?, int?> mapMin = Map<String?, int?>();
  Map<String?, int?> mapMax = Map<String?, int?>();

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive(context);
    //Recibo el tipo de util desde el home
    Map<dynamic, dynamic>? parametros =
        ModalRoute.of(context)!.settings.arguments as Map?;
    miInventario = parametros!['miInventario'];
    miZona = parametros['miZona'];
    mapMin = parametros['mapMin'];
    mapMax = parametros['mapMax'];

    return Scaffold(
      drawer: MenuNavegacion(),
      appBar: dameAppBar('Lista de datos', context),
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
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
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
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
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.topRight,
                child: RaisedButton(
                    shape: Border.all(
                      color: Colors.black38,
                      width: 2,
                    ),
                    color: Color.fromARGB(255, 194, 140, 78),
                    onPressed: () {
                      print('Casillero: ' + casillero);
                      // cargarDatos();
                    },
                    child: Text(
                      'Buscar',
                      style: TextStyle(color: Colors.black87),
                    )),
              ),
              Divider(),
              Expanded(
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
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          ListTile(
                            onTap: () {
                              if (miInventario![i - 1].estadoUtil! > -1) {
                                Navigator.pushNamed(context, 'buscador',
                                    //argumentos que manda los datos desde la lista de inventario
                                    arguments: {
                                      'codUtil': miInventario![i - 1]
                                          .codigoUtil
                                          .toString(),
                                    });
                              }

                              print('Soy el casillero ' + i.toString());
                            },
                            title: Text(
                              'Casillero: ' + i.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Código Cliché: ' +
                                  miInventario![i - 1].codigoUtil.toString() +
                                  '\n\nParte: ' +
                                  miInventario![i - 1]
                                      .codigoParteUtil
                                      .toString()),
                            ),
                            trailing: Text('Estado: ' + obtenerEstado(i)),
                          ),
                        ]),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color obtenerColor(int i) {
    switch (miInventario![i - 1].estadoUtil) {
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

  String obtenerEstado(int i) {
    switch (miInventario![i - 1].estadoUtil) {
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
