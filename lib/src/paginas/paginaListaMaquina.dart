import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:solucionutiles/src/modelos/almacen.dart';
import 'package:solucionutiles/src/modelos/maquina.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/background.dart';
import 'package:solucionutiles/src/widgets/contenedorMaquina.dart';

import '../widgets/menuNavegacion.dart';

class PaginaListaMaquina extends StatefulWidget {
  const PaginaListaMaquina({Key? key}) : super(key: key);

  @override
  State<PaginaListaMaquina> createState() => _PaginaListaMaquinaState();
}

class _PaginaListaMaquinaState extends State<PaginaListaMaquina> {
  String opcionSeleccionada = 'Cliche';
  String? opcionSeleccionadaMa = 'PLANA';
  List<Almacen>? misAlmacenes;
  List<Maquina>? misMaquinas;
  bool isVisible = false;

  late String tipoUtil;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool _checked = false;
    //Recibo el tipo de util desde el home
    Map<dynamic, dynamic>? parametros =
        ModalRoute.of(context)!.settings.arguments as Map?;
    opcionSeleccionada = parametros!['opcionSeleccionada'] ?? 'Cliche';
    misAlmacenes = parametros['misAlmacenes'];
    misMaquinas = parametros['misMaquinas'];

    return Scaffold(
      //pasamos los parametros básicos por si se desea viajar a otra página
      drawer: MenuNavegacion(
        opcionSeleccionada: opcionSeleccionada,
        misAlmacenes: misAlmacenes,
        misMaquinas: misMaquinas,
      ),
      appBar: dameAppBar('Útiles en máquina', context),
      body: Stack(children: [
        Background(),
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Máquinas:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
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
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ContenedorMaquina(codigoUtil: '30003130', checked: false),
                    const SizedBox(
                      height: 10,
                    ),
                    ContenedorMaquina(codigoUtil: '30003131', checked: false),
                    const SizedBox(
                      height: 10,
                    ),
                    ContenedorMaquina(codigoUtil: '30003132', checked: false),
                    const SizedBox(
                      height: 10,
                    ),
                    ContenedorMaquina(codigoUtil: '30003133', checked: false),
                    const SizedBox(
                      height: 10,
                    ),
                    ContenedorMaquina(codigoUtil: '30003134', checked: false),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
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
                  });
                }),
          ),
        )
      ],
    );
  }
}

class Incon {}
