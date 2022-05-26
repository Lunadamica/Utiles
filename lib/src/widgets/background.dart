import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class Background extends StatelessWidget {
  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
          //Cambiamos la dirección de nuestro lineargradient
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          //damos mas intensidad a los colores
          stops: [
        0.2,
        0.8
      ],
          colors: [
        Color.fromARGB(255, 112, 65, 36),
        Color.fromARGB(255, 196, 155, 102),
      ]));

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Stack(
      children: [
        Container(
          decoration: boxDecoration,
        ),
        //forma
        Positioned(
          top: responsive.dp(-10),
          left: responsive.dp(-5),
          child: _Forma(),
        )
      ],
    );
  }
}

class _Forma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    //Rotamos la figura
    return Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        width: responsive.wp(90),
        height: responsive.wp(90),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 238, 161, 74),
              Color.fromARGB(255, 243, 222, 194)
            ])),
      ),
    );
  }
}
