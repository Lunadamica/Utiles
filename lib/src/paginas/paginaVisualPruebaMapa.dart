import 'package:flutter/material.dart';
import 'package:solucionutiles/src/utils/responsive.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/background.dart';
import 'package:solucionutiles/src/widgets/mapaPocoUso.dart';

class PaginaVisualP extends StatefulWidget {
  const PaginaVisualP({Key? key}) : super(key: key);

  @override
  State<PaginaVisualP> createState() => _PaginaVisualPState();
}

class _PaginaVisualPState extends State<PaginaVisualP> {
  //Asignamos un valor por defecto
  String _opcionSeleccionada = 'Almacén Cliche';

  final List<String> _tipo = [
    'Almacén Cliche',
    'Al. Mayor Uso',
    'Al. Poco Uso',
    'Al. Plana'
  ];
  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive(context);
    return Scaffold(
      // drawer: MenuNavegacion(),
      appBar: dameAppBar('Mapa inventario', context),
      body: Stack(
        children: [
          Background(),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.brown,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _crearDropdown(),
                ),
                if (_opcionSeleccionada == 'Al. Poco Uso') const MapaPocoUso(),
                Container(
                  //contenedor de datos del hueco elegido
                  color: Colors.white,
                  height: size.height / 3,
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    'DATOS:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = <DropdownMenuItem<String>>[];
    for (var poder in _tipo) {
      lista.add(DropdownMenuItem(
        child: Text(poder),
        value: poder,
      ));
    }
    return lista;
  }

  Widget _crearDropdown() {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 20,
        ),
        //Si no queremos que nuestro dropdawn se expanda ocupando todo el espacio
        //simplemente lo sacamos fuera y eliminamos el widget
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                value: _opcionSeleccionada,
                iconSize: 36,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                items: getOpcionesDropdown(),
                onChanged: (opt) {
                  setState(() {
                    print(opt);
                    _opcionSeleccionada = opt as String;
                  });
                }),
          ),
        )
      ],
    );
  }
}
