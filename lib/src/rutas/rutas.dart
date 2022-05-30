import 'package:flutter/material.dart';
import 'package:solucionutiles/src/paginas/paginaBuscarUtil.dart';
import 'package:solucionutiles/src/paginas/paginaHome.dart';
import 'package:solucionutiles/src/paginas/paginaInventario.dart';
import 'package:solucionutiles/src/paginas/paginaListado.dart';
import 'package:solucionutiles/src/paginas/paginaLogin.dart';
import 'package:solucionutiles/src/paginas/paginaRetirada.dart';
import 'package:solucionutiles/src/paginas/paginaSplash.dart';
import 'package:solucionutiles/src/paginas/paginaVisual.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => PaginaSplash(),
    'login': (BuildContext context) => PaginaLogin(),
    'home': (BuildContext context) => PaginaHome(),
    'buscador': (BuildContext context) => PaginaBuscarUtil(),
    'inventario': (BuildContext context) => PaginaInventario(),
    'retirada': (BuildContext context) => PaginaRetirada(),
    'visual': (BuildContext context) => PaginaVisual(),
    'listado': (BuildContext context) => PaginaListado()
  };
}
