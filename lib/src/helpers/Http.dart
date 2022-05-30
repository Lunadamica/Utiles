import 'dart:convert';

import 'package:dio/dio.dart';

import '../utils/utils.dart';
import 'RespuestaHTTP.dart';

class Http {
  late Dio _dio;

  Http({required Dio dio}) {
    _dio = dio;
  }

  Future<RespuestaHTTP<T>> respuesta<T>(String path,
      {String metodo = "GET",
      String? cadenaResultado,
      Map<String, dynamic>? parametros,
      Map<String, dynamic>? datos,
      Map<String, String>? cabeceras,
      T Function(List<dynamic> datos)? parser}) async {
    String texto = '';
    try {
      final response = await _dio.request(
        path,
        options: Options(method: metodo, headers: cabeceras),
        queryParameters: parametros,
        data: datos,
      );

      texto = desencryptar(response.data[cadenaResultado]);
      Map<String, dynamic> _miRespuesta = json.decode((texto));
      if (_miRespuesta['Codigo'] != tipoCodigoServicioCorrecto) {
        return RespuestaHTTP.inCorrecto(
            codigo: _miRespuesta['Codigo'],
            mensaje: _miRespuesta['Nombre'],
            datos: _miRespuesta);
      } else {
        if (parser != null) {
          List<dynamic> _misDatos = json.decode(_miRespuesta['Nombre']);
          return RespuestaHTTP.correcto<T>(parser(_misDatos));
        } else {
          return RespuestaHTTP.correcto(_miRespuesta['Nombre']);
        }
      }
    } catch (error) {
      String? codigoError = '0';
      String? mensajeError = error.toString();
      dynamic datosError;

      if (error is DioError) {
        mensajeError = error.message;
        codigoError = '-1';
        if (error.response != null) {
          codigoError = error.response?.statusCode.toString();
          mensajeError = error.response?.statusMessage;
          datosError = error.response?.data;
        }

        return RespuestaHTTP.inCorrecto(
            codigo: codigoError, mensaje: mensajeError, datos: datosError);
      } else {
        return RespuestaHTTP.inCorrecto(
            codigo: codigoError, mensaje: mensajeError, datos: datosError);
      }
    }
  }
}
