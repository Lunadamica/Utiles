// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:solucionutiles/src/modelos/almacen.dart';
import 'package:solucionutiles/src/modelos/maquina.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/menuNavegacion.dart';

class PaginaRetirada extends StatefulWidget {
  const PaginaRetirada({Key? key}) : super(key: key);

  @override
  State<PaginaRetirada> createState() => _PaginaRetiradaState();
}

class _PaginaRetiradaState extends State<PaginaRetirada> {
  String? opcionSeleccionada;
  List<Almacen>? misAlmacenes;
  List<Maquina>? misMaquinas;
  List<String> opciones = [
    'Uno',
    'Dos',
    'Tres',
    'Cuatro',
    'Cinco',
    'Seis',
    'Siete',
    'Ocho',
    'Nueve',
    'Diez',
    'Once',
    'Doce',
  ];
  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? parametros =
        ModalRoute.of(context)!.settings.arguments as Map?;
    opcionSeleccionada = parametros!['opcionSeleccionada'] ?? TCliche;
    misAlmacenes = parametros['misAlmacenes'];
    misMaquinas = parametros['misMaquinas'];
    return Scaffold(
      drawer: MenuNavegacion(
        opcionSeleccionada: opcionSeleccionada,
        misAlmacenes: misAlmacenes,
        misMaquinas: misMaquinas,
      ),
      appBar: dameAppBar('Pediente de retirada', context),
      body: ListView(children: _crearItems()),
    );
  }

  List<Widget> _crearItems() {
    return opciones.map((item) {
      return Column(
        children: <Widget>[
          ListTile(
            title: Text(item),
            subtitle: const Text('Subtitulos'),
            trailing: const Text('P: 4 C:330'),
            //Al hacer click que salga un dialogo que nos pregunte si deseamos eliminar de la lista el elemento
            onTap: () {
              _alerta(context, item);
            },
          ),
          const Divider()
        ],
      );
    }).toList();
  }

  void _alerta(BuildContext context, String item) {
    showDialog(
      context: context,
      //Si clicamos fuera del cuadro este no se cerrara
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Eliminar elemento'),
          content: Text(
              '¿Esta seguro de que desea eliminar el elemento $item de la lista?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                opciones.remove(item);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Borrar'),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
