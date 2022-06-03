// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';

import '../modelos/almacen.dart';

class TarjetaNavegacion extends StatelessWidget {
  //Datos que requerimos para pasar por argumentos
  String? opcionSeleccionada;
  List<Almacen>? misAlmacenes;
  TarjetaNavegacion(
      {Key? key, required this.opcionSeleccionada, this.misAlmacenes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            _SingleCard(
              color: Colors.white,
              icon: Icons.search,
              text: 'Buscar útil',
              onPressed: () {
                Navigator.pushNamed(context, 'buscador',
                    //argumentos que manda los datos desde el Home
                    arguments: {
                      'opcionSeleccionada': opcionSeleccionada,
                      'misAlmacenes': misAlmacenes
                    });
              },
            ),
            _SingleCard(
                color: Colors.white,
                icon: Icons.all_inbox,
                text: 'Inventario',
                onPressed: () {
                  Navigator.pushNamed(context, 'inventario',
                      //argumentos que manda los datos desde el Home
                      arguments: {
                        'opcionSeleccionada': opcionSeleccionada,
                        'misAlmacenes': misAlmacenes
                      });
                }),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
                color: Colors.white,
                icon: Icons.map,
                text: 'Visualizar Inventario',
                onPressed: () {
                  Navigator.pushNamed(context, 'visual',
                      //argumentos que manda los datos desde el Home
                      arguments: {
                        'opcionSeleccionada': opcionSeleccionada,
                        'misAlmacenes': misAlmacenes
                      });
                }),
            _SingleCard(
              color: Colors.white,
              icon: Icons.auto_delete,
              text: 'Pendiente de retirada',
              onPressed: () {
                Navigator.pushNamed(context, 'retirada');
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final void Function()? onPressed;

  const _SingleCard(
      {Key? key,
      required this.icon,
      required this.color,
      required this.text,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        //Difuminamos el fondo de la caja
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color.fromARGB(175, 65, 34, 22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FlatButton(
              onPressed: onPressed,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    child: Icon(
                      icon,
                      size: 40,
                    ),
                    radius: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color, fontSize: 18))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
