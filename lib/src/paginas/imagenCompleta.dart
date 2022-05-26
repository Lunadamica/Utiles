import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/menuNavegacion.dart';

import '../api/apiPdf.dart';

class ImagenCompleta extends StatefulWidget {
  String codigo;
  String url;
  ImagenCompleta({Key? key, required this.url, required this.codigo})
      : super(key: key);

  @override
  State<ImagenCompleta> createState() => _ImagenCompletaState();
}

class _ImagenCompletaState extends State<ImagenCompleta> {
  ApiService _apiService = new ApiService();
  String? _localFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiService.pdfUrl = widget.url;
    _apiService.loadPDF().then((value) {
      setState(() {
        _localFile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuNavegacion(),
      appBar: dameAppBar(widget.codigo, context),
      body: Center(
        child: _localFile != null
            ? RotatedBox(
                quarterTurns: 3,
                child: Container(
                  child: PDFView(
                    filePath: _localFile,
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
