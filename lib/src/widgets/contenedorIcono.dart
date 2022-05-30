import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContenedorIcono extends StatelessWidget {
  //variable para un tamaño responsivo
  final double size;
  final String imagen;

  const ContenedorIcono({Key? key, required this.size, required this.imagen})
      : assert(size != null && size > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //Tamaño de la caja
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(this.size * 0.15),
      ),
      child: Center(
        child: SvgPicture.asset(
          imagen,
          //Tamaño del icono
          height: this.size * 0.8,
          width: this.size * 0.8,
        ),
      ),
    );
  }
}
