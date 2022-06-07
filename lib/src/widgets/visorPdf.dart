import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/api/BBDD.dart';
import 'package:solucionutiles/src/api/apiPdf.dart';
import 'package:solucionutiles/src/helpers/RespuestaHTTP.dart';
import 'package:solucionutiles/src/paginas/imagenCompleta.dart';
import 'package:solucionutiles/src/utils/responsive.dart';

import '../utils/utils.dart';

class VisorPdf extends StatefulWidget {
  final String codigo;
  final String tipo;

  const VisorPdf({
    Key? key,
    required this.codigo,
    required this.tipo,
  }) : super(key: key);

  @override
  State<VisorPdf> createState() => _VisorPdfState();
}

class _VisorPdfState extends State<VisorPdf> {
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  final ApiService _apiService = ApiService();
  String? url;
  String? localFile;

  @override
  void initState() {
    super.initState();
    obtenerUri();
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive(context);
    return SizedBox(
      height: size.isTablet ? size.height / 2 : size.height / 3,
      child: GestureDetector(
        child: Center(
          child: localFile != null
              ? GestureDetector(
                  onDoubleTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagenCompleta(
                          url: url ?? "",
                          codigo: widget.codigo,
                        ),
                      ),
                    );
                  },
                  child: PDFView(
                    filePath: localFile,
                  ),
                )
              : SizedBox(
                  child: const CircularProgressIndicator(),
                  height: size.hp(7),
                  width: size.hp(7),
                ),
        ),
      ),
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dameSnackBar(titulo: texto, error: error));
    //scaffoldKey.currentState.showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  //Metodo que obtiene el URL de la BBDD
  Future<void> obtenerUri() async {
    final RespuestaHTTP<String> miRespuesta =
        await _miBBDD.dameRutaFichero(codigo: widget.codigo, tipo: widget.tipo);

    if (miRespuesta.data != null) {
      url = miRespuesta.data;
      _apiService.pdfUrl = url;
      _apiService.loadPDF().then((value) {
        setState(() {
          localFile = value;
        });
      });
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);
      comprobarTipoError(context, miRespuesta.error!);
    }
  }
}
