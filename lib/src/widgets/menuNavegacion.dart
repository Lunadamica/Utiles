import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solucionutiles/src/modelos/almacen.dart';
import 'package:solucionutiles/src/paginas/paginaUsuario.dart';

import '../datos/autentificacionCliente.dart';

class MenuNavegacion extends StatefulWidget {
  String? opcionSeleccionada;
  List<Almacen>? misAlmacenes;
  MenuNavegacion(
      {Key? key, required this.opcionSeleccionada, required this.misAlmacenes})
      : super(key: key);

  @override
  State<MenuNavegacion> createState() => _MenuNavegacionState();
}

class _MenuNavegacionState extends State<MenuNavegacion> {
  final _autentificacionCliente = GetIt.instance<AutentificacionCliente>();
  String _sUsuario = '';
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  void initState() {
    super.initState();
    comprobarUsuario();
  }

  void comprobarUsuario() async {
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    String? sUsuario = miConfiguracion.getString("Usuario");

    if (sUsuario != null) {
      if (sUsuario.trim().isNotEmpty) {
        setState(() {
          _sUsuario = sUsuario;
        });
      }
    } else {
      setState(() {
        _sUsuario = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombre = _sUsuario;
    //La imagen del usuario la estoy cogiendo directamente desde internet
    const urlImage =
        'https://d500.epimg.net/cincodias/imagenes/2016/07/04/lifestyle/1467646262_522853_1467646344_noticia_normal.jpg';
    return Drawer(
      child: Material(
        color: Colors.brown,
        child: ListView(
          children: <Widget>[
            buildHeader(
                urlImage: urlImage,
                nombre: nombre,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaginaUsuario(
                          name: nombre,
                          urlImage: urlImage,
                        )))),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
              text: 'Buscar útil',
              icon: Icons.search,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
              text: 'Inventario',
              icon: Icons.all_inbox,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
              text: 'Visualizar inventario',
              icon: Icons.map_sharp,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
              text: 'Pendiente de retirada',
              icon: Icons.auto_delete,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(
              height: 24,
            ),
            const Divider(
              color: Colors.white70,
            ),
            const SizedBox(
              height: 24,
            ),
            buildMenuItem(
              text: 'Cerrar sesión',
              icon: Icons.exit_to_app,
              onClicked: () => selectedItem(context, 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  //Metedo donde definimos nuestros onpressed
  Future<void> selectedItem(BuildContext context, int index) async {
    switch (index) {
      case 0:
        await _autentificacionCliente.signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          'login',
          (_) => false,
        );
        break;
      case 1:
        Navigator.pushNamed(
          context, 'buscador',
          //argumentos que pasamos con los datos traidos del home
          arguments: {
            'opcionSeleccionada': widget.opcionSeleccionada ?? 'Cliche',
            'misAlmacenes': widget.misAlmacenes,
          },
        );
        break;
      case 2:
        Navigator.pushNamed(
          context,
          'inventario',
          //argumentos que pasamos con los datos traidos del home
          arguments: {
            'opcionSeleccionada': widget.opcionSeleccionada ?? 'Cliche',
            'misAlmacenes': widget.misAlmacenes ?? [],
          },
        );
        break;
      case 3:
        Navigator.pushNamed(
          context,
          'visual',
          //argumentos que pasamos con los datos traidos del home
          arguments: {
            'opcionSeleccionada': widget.opcionSeleccionada ?? 'Cliche',
            'misAlmacenes': widget.misAlmacenes ?? [],
          },
        );
        break;
      case 4:
        Navigator.pushNamed(
          context,
          'retirada',
        );
        break;
    }
  }

  //Cabecera
  buildHeader(
          {required String urlImage,
          required String nombre,
          required Future Function() onClicked}) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(urlImage),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      );
}
