import 'package:flutter/material.dart';
import 'package:solucionutiles/src/modelos/zona.dart';
import 'package:solucionutiles/src/widgets/inventarioUtiles.dart';

import '../modelos/inventario.dart';
import '../utils/utils.dart';

class ListaInventario extends StatefulWidget {
  final List<Zona> lista;
  final List<Inventario>? miInventario;
  final String tipo;
  final String? opcionSeleccionada;
  const ListaInventario(
      {Key? key,
      required this.lista,
      required this.tipo,
      required this.miInventario,
      required this.opcionSeleccionada})
      : super(key: key);

  @override
  State<ListaInventario> createState() => _ListaInventarioState();
}

class _ListaInventarioState extends State<ListaInventario> {
  String? codigoAlmacen;
  String? codigoZona;
  int? rangoMax = 0;
  int? rangoIni = 0;
  Map<String?, int?> mapMin = Map<String?, int?>();
  Map<String?, int?> mapMax = Map<String?, int?>();

  @override
  Widget build(BuildContext context) {
    setState(() {
      rangoIni = 0;
      rangoMax = 0;
    });
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: GridView.count(
        //Capacidad de encoger envoltura
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          for (int i = 0; i < widget.lista.length; i++)
            Card(
              color: Color.fromARGB(255, 212, 171, 110),
              child: Padding(
                padding: EdgeInsets.all(10),
                //inkwell es el botón para seleccionar
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.pushNamed(context, 'listado',
                        //argumentos que manda los datos desde la lista de inventario
                        arguments: {
                          'opcionSeleccionada': widget.opcionSeleccionada,
                          'miInventario': widget.miInventario,
                          'miZona': widget.lista[i],
                          'mapMin': mapMin,
                          'mapMax': mapMax,
                        });
                  },
                  child: InventarioUtiles(
                    zona: widget.lista[i].nombreZona,
                    rango: obtenerRango(i),
                    listaInventario: widget.miInventario,
                    totalUtiles: widget.lista[i].totalUtiles.toString(),
                    porcentaje: obtenerPorcentaje(i),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double? obtenerPorcentaje(int i) {
    double? porcentaje = 0;
    porcentaje = 100 -
        ((widget.lista[i].numeroCasilleros! *
                int.parse(widget.lista[i].totalUtiles.toString())) /
            100);
    return porcentaje;
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  String obtenerRango(int i) {
    String resultado;
    rangoIni = rangoIni! + 1;
    mapMin.addAll({widget.lista[i].nombreZona: rangoIni});
    rangoMax =
        rangoMax! + int.parse(widget.lista[i].numeroCasilleros.toString());

    resultado = rangoIni.toString() + "-" + rangoMax.toString();
    mapMax.addAll({widget.lista[i].nombreZona: rangoMax});
    rangoIni = rangoMax;

    return resultado;
  }
}
