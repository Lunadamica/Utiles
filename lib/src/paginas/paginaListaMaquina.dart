import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/modelos/almacen.dart';
import 'package:solucionutiles/src/modelos/datosPtes.dart';
import 'package:solucionutiles/src/modelos/maquina.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/background.dart';

import '../api/BBDD.dart';
import '../helpers/RespuestaHTTP.dart';
import '../widgets/contenedorMaquina.dart';
import '../widgets/menuNavegacion.dart';

class PaginaListaMaquina extends StatefulWidget {
  const PaginaListaMaquina({Key? key}) : super(key: key);

  @override
  State<PaginaListaMaquina> createState() => _PaginaListaMaquinaState();
}

class _PaginaListaMaquinaState extends State<PaginaListaMaquina> {
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  List<DatosPtes>? lista;
  String opcionSeleccionada = 'Cliche';
  String? opcionSeleccionadaMa;
  List<Almacen>? misAlmacenes;
  List<Maquina>? misMaquinas;
  bool isVisible = false;
  Maquina? miMaquina;

  late String tipoUtil;

  @override
  Widget build(BuildContext context) {
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
                  height: 20,
                ),
                Visibility(
                  visible: isVisible,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      if (isVisible)
                        for (int i = 0; i < lista!.length; i++)
                          ContenedorMaquina(
                              codigoUtil: lista![i].codCliche.toString(),
                              checked: lista![i].enMaquina!,
                              color: pocoUsado),
                    ],
                  ),
                )
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

  Future<void> cargarLista() async {
    String? valorUtil;
    if (opcionSeleccionada == TCliche) {
      valorUtil = tipoCliche;
    } else if (opcionSeleccionada == TTroquel) {
      valorUtil = tipoTroquel;
    }
    final RespuestaHTTP<List<DatosPtes>> miRespuesta =
        await _miBBDD.dameUtilesMaquina(
            codigoMaquina: miMaquina!.codMaquina.toString(), tipo: valorUtil);

    if (miRespuesta.data != null) {
      lista = miRespuesta.data;
      isVisible = true;
      setState(() {});
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
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
                    for (int i = 0; i < misMaquinas!.length; i++) {
                      if (opcionSeleccionadaMa ==
                          misMaquinas![i].nombreMaquina) {
                        miMaquina = misMaquinas![i];
                      }
                    }
                  });
                  cargarLista();
                }),
          ),
        )
      ],
    );
  }
}
