import 'package:flutter/material.dart';
import 'package:solucionutiles/src/paginas/paginaBuscarUtil.dart';
import 'package:solucionutiles/src/paginas/paginaHome.dart';
import 'package:solucionutiles/src/paginas/paginaInventario.dart';
import 'package:solucionutiles/src/paginas/paginaListado.dart';
import 'package:solucionutiles/src/paginas/paginaLogin.dart';
import 'package:solucionutiles/src/paginas/paginaRetirada.dart';
import 'package:solucionutiles/src/paginas/paginaSplash.dart';

import '../paginas/paginaListaMaquina.dart';
import '../paginas/paginaVisual.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const PaginaSplash(),
    'login': (BuildContext context) => const PaginaLogin(),
    'home': (BuildContext context) => const PaginaHome(),
    'buscador': (BuildContext context) => const PaginaBuscarUtil(),
    'inventario': (BuildContext context) => const PaginaInventario(),
    'retirada': (BuildContext context) => const PaginaRetirada(),
    'visual': (BuildContext context) => const PaginaVisual(),
    'listado': (BuildContext context) => const PaginaListado(),
    'maquina': (BuildContext context) => const PaginaListaMaquina()
  };
}
