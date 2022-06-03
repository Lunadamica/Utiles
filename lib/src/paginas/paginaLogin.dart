import 'package:flutter/material.dart';
import 'package:solucionutiles/src/utils/responsive.dart';
import 'package:solucionutiles/src/widgets/contenedorIcono.dart';
import 'package:solucionutiles/src/widgets/formularioLogin.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({Key? key}) : super(key: key);

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  @override
  Widget build(BuildContext context) {
    //Llamamos a la clase prediseñada para crear diseños responsivos
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      //minimizamos el teclado al pinchar fuera de el
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        //Permitimos que la pantalla sea adaptable y no fija añadiendo scroll
        child: SingleChildScrollView(
          child: Container(
            width: responsive.width,
            height: responsive.height,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: responsive.isTablet
                      ? responsive.wp(10)
                      : responsive.wp(20),
                  child: Column(
                    children: <Widget>[
                      //Logo de la app
                      ContenedorIcono(
                        imagen: 'recursos/icono2.svg',
                        size: responsive.isTablet
                            ? responsive.wp(40)
                            : responsive.wp(50),
                      ),
                      Text(
                        "Bienvenido",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: responsive.dp(1.7)),
                      )
                    ],
                  ),
                ),
                const FormularioLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
