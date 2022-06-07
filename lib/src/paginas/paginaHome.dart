import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/TarjetaNavegacion.dart';
import 'package:solucionutiles/src/widgets/menuNavegacion.dart';
import '../api/BBDD.dart';
import '../helpers/RespuestaHTTP.dart';
import '../modelos/almacen.dart';
import '../modelos/maquina.dart';
import '../widgets/background.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({Key? key}) : super(key: key);

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  List<Almacen>? misAlmacenes = <Almacen>[];
  List<Maquina>? misMaquinas = <Maquina>[];
  String? opcionSeleccionadaAl;
  String? opcionSeleccionadaMa;

  //Asignamos un valor por defecto
  String? opcionSeleccionada = TCliche;

  final List<String> _tipo = [TCliche, TTroquel];
  String? valorUtil;

  @override
  void initState() {
    super.initState();
    cargarAlmacenes();
    cargarMaquinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuNavegacion(
        opcionSeleccionada: opcionSeleccionada,
        misAlmacenes: misAlmacenes,
        misMaquinas: misMaquinas,
      ),
      appBar: dameAppBar('Ondupack', context),
      body: Stack(
        children: [
          Background(),
          SingleChildScrollView(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Tipo:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
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
              ),
              const SizedBox(
                height: 10,
              ),
              TarjetaNavegacion(
                  opcionSeleccionada: opcionSeleccionada,
                  misAlmacenes: misAlmacenes,
                  misMaquinas: misMaquinas),
            ]),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = <DropdownMenuItem<String>>[];
    for (var util in _tipo) {
      lista.add(DropdownMenuItem(
        child: Text(util),
        value: util,
      ));
    }
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
                hint: const Text('Elige un tipo de útil'),
                value: opcionSeleccionada,
                iconSize: 36,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                items: getOpcionesDropdown(),
                //Muestra la opción seleccionada en el dropdown
                onChanged: (opt) {
                  setState(() {
                    opcionSeleccionada = opt as String;
                    cargarAlmacenes();
                  });
                }),
          ),
        )
      ],
    );
  }

  //Metodo para conseguir la lista de almacenes segun el tipo
  Future<void> cargarAlmacenes() async {
    if (opcionSeleccionada == TCliche) {
      valorUtil = tipoCliche;
    } else if (opcionSeleccionada == TTroquel) {
      valorUtil = tipoTroquel;
    }
    final RespuestaHTTP<List<Almacen>> miRespuesta =
        await _miBBDD.dameAlmacenesUtiles(tipo: valorUtil);

    if (miRespuesta.data != null) {
      misAlmacenes = miRespuesta.data;

      setState(() {
        if (misAlmacenes!.isNotEmpty) {
          opcionSeleccionadaAl = misAlmacenes![0].nombreAlmacen;
        }
      });
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }

  Future<void> cargarMaquinas() async {
    final RespuestaHTTP<List<Maquina>> miRespuesta =
        await _miBBDD.dameMaquinas();

    if (miRespuesta.data != null) {
      misMaquinas = miRespuesta.data;
      setState(() {
        if (misMaquinas!.isNotEmpty) {
          opcionSeleccionadaMa = misMaquinas![0].nombreMaquina;
        }
      });
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dameSnackBar(titulo: texto, error: error));
  }
}
