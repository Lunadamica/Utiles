import 'package:flutter/material.dart';
import 'package:solucionutiles/src/utils/responsive.dart';

abstract class Dialogs {
  static alert(
      {required BuildContext context,
      required String titulo,
      required String? descripcion}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(titulo),
              content: Text(descripcion!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(_);
                    },
                    child: const Text("OK")),
              ],
            ));
  }
}

abstract class ProgressDialog {
  static show(BuildContext context) {
    Responsive responsive = Responsive(context);
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.7),
              child: Center(
                child: SizedBox(
                  child: const CircularProgressIndicator(),
                  height: responsive.hp(7),
                  width: responsive.hp(7),
                ),
              ),
            ),
            onWillPop: () async => false,
          );
        });
  }

  static dissmiss(BuildContext context) {
    Navigator.pop(context);
  }
}
