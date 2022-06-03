import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiService {
  String? pdfUrl = '';

  Future<String?> loadPDF() async {
    var response = await http.get(Uri.parse(pdfUrl!));

    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/data.pdf");

    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file.path;
  }
}
