// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class MapaPocoUso extends StatefulWidget {
  const MapaPocoUso({Key? key}) : super(key: key);

  @override
  State<MapaPocoUso> createState() => _MapaPocoUsoState();
}

class _MapaPocoUsoState extends State<MapaPocoUso> {
  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive(context);
    return Container(
      color: Colors.white,
      height: size.height * 3,
      margin: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          //numero de secciones en una misma zona
          for (int i = 0; i < 5; i++)
            Container(
              margin: const EdgeInsets.all(6),
              width: 50,
              child: SafeArea(
                child: GridView.count(
                  //Espacio entre los cuadros
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  //numero de filas juntas
                  crossAxisCount: 2,
                  children: [
                    //cantidad de cuadritos
                    for (int j = 0; j < 134; j++)
                      Container(
                        color: Colors.grey,
                        child: FlatButton(
                          onPressed: () {
                            _alerta(context,
                                'Contenedor(columna): $i Posición: $j');
                            // print('Contenedor(columna):' +
                            //     i.toString() +
                            //     ' Posición:' +
                            //     j.toString());
                          },
                          child: const Text(
                            'num',
                            style: TextStyle(fontSize: 6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _alerta(BuildContext context, String posicion) {
    showDialog(
      context: context,
      //Si clicamos fuera del cuadro este no se cerrara
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Posicion del útil'),
          content: Text(posicion),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        );
      },
    );
  }
}
