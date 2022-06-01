import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/responsive.dart';

class MapaPocoUso extends StatefulWidget {
  MapaPocoUso({Key? key}) : super(key: key);

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
      margin: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          //numero de secciones en una misma zona
          for (int i = 0; i < 5; i++)
            Container(
              margin: EdgeInsets.all(6),
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
                            print('Contenedor(columna):' +
                                i.toString() +
                                ' Posición:' +
                                j.toString());
                          },
                          child: Text(
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
}
