import 'package:flutter/material.dart';
import 'package:solucionutiles/src/utils/utils.dart';

import '../widgets/menuNavegacion.dart';

class PaginaRetirada extends StatefulWidget {
  PaginaRetirada({Key? key}) : super(key: key);

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
      drawer: MenuNavegacion(),
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
            subtitle: Text('Subtitulos'),
            trailing: Text('P: 4 C:330'),
            //Al hacer click que salga un dialogo que nos pregunte si deseamos eliminar de la lista el elemento
            onTap: () {
              _alerta(context);
            },
          ),
          Divider()
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
        title: Text('Eliminar elemento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                '¿Esta seguro de que desea eliminar este elemento de la lista?')
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text('Borrar'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
