class AuthenticationResponse {
  final String token;
  final String usuario;
  final int segundosExpiracion;

  AuthenticationResponse({
    required this.token,
    required this.usuario,
    required this.segundosExpiracion,
  });

  static AuthenticationResponse fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
        token: json['Token'],
        usuario: json['Usuario'],
        segundosExpiracion: json['SegundosExpiracion']);
  }
}
