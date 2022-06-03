import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PaginaUsuario extends StatelessWidget {
  final String name;
  String urlImage;
  PaginaUsuario({Key? key, required this.name, required this.urlImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dameAppBar('Usuario', context),
      body: Image.network(urlImage,
          width: double.infinity, height: double.infinity, fit: BoxFit.cover),
    );
  }
}
