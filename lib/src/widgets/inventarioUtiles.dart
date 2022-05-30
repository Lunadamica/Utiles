import 'package:flutter/material.dart';
import 'package:solucionutiles/src/modelos/inventario.dart';

class InventarioUtiles extends StatelessWidget {
  final String? zona;
  final String? rango;
  final List<Inventario>? listaInventario;
  final String? totalUtiles;
  final double? porcentaje;
  const InventarioUtiles({
    Key? key,
    required this.zona,
    required this.rango,
    required this.listaInventario,
    required this.totalUtiles,
    required this.porcentaje,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text('Zona:', style: TextStyle(fontWeight: FontWeight.bold)),
        Positioned(
          right: 5,
          child: Text(
            zona!,
          ),
        ),
        Positioned(
          top: 30,
          child: Text(
            'Rango:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          top: 30,
          right: 5,
          child: Text(
            rango!,
          ),
        ),
        Positioned(
          top: 60,
          child: Text(
            'T. útiles:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          top: 60,
          right: 5,
          child: Text(
            totalUtiles!,
          ),
        ),
        Positioned(
          top: 90,
          child: Text(
            'P. libre:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          top: 90,
          right: 5,
          child: Text(
            porcentaje.toString() + '%',
          ),
        ),
      ],
    );
  }
}
