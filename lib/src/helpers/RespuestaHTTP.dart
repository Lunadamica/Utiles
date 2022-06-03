// T hace que sea generico
class RespuestaHTTP<T> {
  //Variable en la que guardamos los datos si el registro ha sido existoso
  final T? data;
  //variable donde guardamos los errores
  final HttpError? error;

  RespuestaHTTP(this.data, this.error);

  static RespuestaHTTP<T> correcto<T>(T data) => RespuestaHTTP(data, null);
  static RespuestaHTTP<T> inCorrecto<T>(
          {required String? codigo,
          required String? mensaje,
          required dynamic datos}) =>
      RespuestaHTTP(
          null, HttpError(codigo: codigo, mensaje: mensaje, datos: datos));
}

class HttpError {
  final String? codigo;
  final String? mensaje;
  final dynamic datos;

  HttpError({required this.codigo, required this.mensaje, required this.datos});
}
