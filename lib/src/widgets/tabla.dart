import 'package:flutter/material.dart';
import 'package:solucionutiles/src/widgets/celda.dart';

class Tabla extends StatelessWidget {
  const Tabla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: [
            Column(
              children: [Celda(), Celda(), Celda()],
            ),
            Column(
              children: [Celda(), Celda(), Celda()],
            ),
            Column(
              children: [Celda(), Celda(), Celda()],
            ),
          ],
        ),
      ],
    );
  }
}
