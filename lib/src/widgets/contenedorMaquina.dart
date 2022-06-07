import 'package:flutter/material.dart';

class ContenedorMaquina extends StatefulWidget {
  String codigoUtil;
  bool checked;
  ContenedorMaquina({Key? key, required this.codigoUtil, required this.checked})
      : super(key: key);

  @override
  State<ContenedorMaquina> createState() => _ContenedorMaquinaState();
}

class _ContenedorMaquinaState extends State<ContenedorMaquina> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: CheckboxListTile(
        title: Text(widget.codigoUtil),
        value: widget.checked,
        onChanged: (bool? value) {
          setState(() {
            widget.checked = value!;
          });
        },
        secondary: const Icon(Icons.hourglass_empty),
      ),
    );
  }
}
