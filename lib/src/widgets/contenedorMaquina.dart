import 'package:flutter/material.dart';

class ContenedorMaquina extends StatefulWidget {
  String codigoUtil;
  bool checked;
  Color color;
  String opcionSeleccionada;

  ContenedorMaquina(
      {Key? key,
      required this.codigoUtil,
      required this.checked,
      required this.color,
      required this.opcionSeleccionada})
      : super(key: key);

  @override
  State<ContenedorMaquina> createState() => _ContenedorMaquinaState();
}

class _ContenedorMaquinaState extends State<ContenedorMaquina> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.color,
        ),
        child: CheckboxListTile(
          title: Text(widget.codigoUtil,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          value: widget.checked,
          onChanged: (bool? value) {
            setState(() {
              widget.checked = value!;
            });
          },
          secondary: TextButton(
            child: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, 'buscador',
                  //argumentos que manda los datos desde la lista de inventario
                  arguments: {
                    'opcionSeleccionada': widget.opcionSeleccionada,
                    'codUtil': widget.codigoUtil,
                  });
            },
          ),
        ),
      ),
    );
  }
}
