import 'package:flutter/material.dart';

class Celda extends StatelessWidget {
  const Celda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
          )),
    );
  }
}
