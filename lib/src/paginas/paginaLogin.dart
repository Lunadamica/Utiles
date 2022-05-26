import 'package:flutter/material.dart';
import 'package:solucionutiles/src/utils/responsive.dart';
import 'package:solucionutiles/src/widgets/contenedorIcono.dart';
import 'package:solucionutiles/src/widgets/formularioLogin.dart';

class PaginaLogin extends StatefulWidget {
  PaginaLogin({Key? key}) : super(key: key);

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  @override
  Widget build(BuildContext context) {
    //Llamamos a la clase prediseñada para crear diseños responsivos
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      //minimizamos el teclado al pinchar fuera del teclado
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: responsive.width,
            height: responsive.height,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: responsive.wp(20),
                  child: Column(
                    children: <Widget>[
                      ContenedorIcono(
                        imagen: 'recursos/icono2.svg',
                        size: responsive.wp(40),
                      ),
                      Text(
                        "Bienvenido",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                FormularioLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
