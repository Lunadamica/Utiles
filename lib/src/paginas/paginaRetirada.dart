// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:solucionutiles/src/utils/utils.dart';

class PaginaRetirada extends StatefulWidget {
  const PaginaRetirada({Key? key}) : super(key: key);

  @override
  State<PaginaRetirada> createState() => _PaginaRetiradaState();
}

class _PaginaRetiradaState extends State<PaginaRetirada> {
  final opciones = [
    'Uno',
    'Dos',
    'Tres',
    'Cuatro',
    'Uno',
    'Dos',
    'Tres',
    'Cuatro',
    'Uno',
    'Dos',
    'Tres',
    'Cuatro',
    'Uno',
    'Dos',
    'Tres',
    'Cuatro'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MenuNavegacion(),
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
              _alerta(context);
            },
          ),
          const Divider()
        ],
      );
    }).toList();
  }
}

void _alerta(BuildContext context) {
  showDialog(
    context: context,
    //Si clickamos fuera del cuadro este no se cerrara
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Eliminar elemento'),
        content: const Text(
            '¿Esta seguro de que desea eliminar este elemento de la lista?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
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
