// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solucionutiles/src/api/BBDD.dart';
import 'package:solucionutiles/src/modelos/usuario.dart';
import 'package:solucionutiles/src/utils/responsive.dart';
import 'package:solucionutiles/src/widgets/dialogos.dart';
import 'package:solucionutiles/src/widgets/input_text.dart';

import '../helpers/RespuestaHTTP.dart';
import '../modelos/sesion.dart';
import 'contenedorIcono.dart';

class FormularioLogin extends StatefulWidget {
  const FormularioLogin({Key? key}) : super(key: key);

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _sUsuario = '', _sclave = '';
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  String sCodigoVersion = "";
  bool bDescargaFichero = false;
  bool _ocultarClave = true;
  IconData icono = Icons.visibility_off;

  _FormularioLoginState() {
    comprobarUsuario();
  }

  void comprobarUsuario() async {
    //Guardamos el último usuario que haya iniciado sesión
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    String? sUsuario = miConfiguracion.getString("Usuario");

    if (sUsuario != null) {
      if (sUsuario.trim().isNotEmpty) {
        setState(() {
          _sUsuario = sUsuario;
        });
      }
    } else {
      setState(() {
        _sUsuario = "";
      });
    }
  }

  void _toggle() {
    //Cambio de icono segun la visibilidad de la contraseña
    setState(() {
      _ocultarClave = !_ocultarClave;
      if (_ocultarClave) {
        icono = Icons.visibility_off;
      } else {
        icono = Icons.visibility;
      }
    });
  }

  Future<void> _validar() async {
    //Validamos el usuario
    final isOK = _formKey.currentState!.validate();

    if (isOK) {
      if (_sUsuario.trim().isEmpty || _sclave.trim().isEmpty) {
        Dialogs.alert(
            context: context,
            titulo: "ERROR",
            descripcion: "Debe introducir un usuario y clave validos");
      } else {
        ProgressDialog.show(context);

        final RespuestaHTTP miRespuesta =
            await _miBBDD.login(usuario: _sUsuario, clave: _sclave);

        ProgressDialog.dissmiss(context);

        if (miRespuesta.data != null) {
          Sesion miSesion;

          if (!GetIt.instance.isRegistered<Sesion>()) {
            //hacemos de la sesion que sea singleton
            GetIt.instance.registerSingleton<Sesion>(miRespuesta.data);
          }

          miSesion = GetIt.instance<Sesion>();
          miSesion.token = miRespuesta.data.token;
          miSesion.saveSession();

          //Obtenemos información del usuario
          final RespuestaHTTP miUsuario =
              await _miBBDD.dameInformacionUsuario();

          if (miUsuario.data != null) {
            if (bDescargaFichero == false) {
              if (!GetIt.instance.isRegistered<Usuario>()) {
                //hacemos de la sesion que sea singleton
                GetIt.instance.registerSingleton<Usuario>(miUsuario.data);
              }

              SharedPreferences miConfiguracion =
                  await SharedPreferences.getInstance();

              miConfiguracion.setString("Usuario", _sUsuario);
            }
          }
          //Navegamos al home si todos los datos son correctos
          Navigator.pushNamedAndRemoveUntil(context, "home", (_) => false);
        } else {
          //Nos muestra un mensaje si los datos del registro no son correctos
          Dialogs.alert(
              context: context,
              titulo: "ERROR",
              descripcion: miRespuesta.error!.mensaje);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Positioned(
      bottom: 30,
      child: Container(
        constraints: BoxConstraints(
          //daremos un tamaño maximo dependiendo si es tablet o no
          maxWidth: responsive.isTablet ? 600 : 300,
        ),
        child: Column(children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputText(
                  label: 'Usuario',
                  fontSize: responsive.dp(1.7),
                  controlador: TextEditingController(text: _sUsuario),
                  onChanged: (text) {
                    _sUsuario = text;
                  },
                  validator: (text) {
                    if (text!.trim().isEmpty) {
                      return 'Usuario incorrecto';
                    }
                    return null;
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InputText(
                        suffixIcon: IconButton(
                          icon: Icon(icono),
                          onPressed: () {
                            //cambiamos el icono de visibilidad de la contraseña
                            _toggle();
                          },
                        ),
                        label: 'Contraseña',
                        //segun lo marcado en el icono ocultamos la contraseña o no
                        obscureText: _ocultarClave,
                        fontSize: responsive.dp(1.7),
                        onChanged: (text) {
                          _sclave = text;
                        },
                        validator: (text) {
                          if (text!.trim().isEmpty) {
                            return 'Contraseña incorrecta';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    onPressed: () {
                      _alerta(context);
                    },
                    child: Text(
                      'Recordar contraseña',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.dp(1.5),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                SizedBox(
                  height: responsive.dp(5),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    onPressed: _validar,
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.dp(1.5),
                      ),
                    ),
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: responsive.dp(3.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ContenedorIcono(
                  size: responsive.wp(15), imagen: 'recursos/logo.svg'),
              ContenedorIcono(
                  size: responsive.wp(20),
                  imagen: 'recursos/ClGrupoIndustrial.svg'),
              ContenedorIcono(
                  size: responsive.wp(20), imagen: 'recursos/Ondupet.svg'),
            ],
          ),
          SizedBox(height: responsive.dp(2))
        ]),
      ),
    );
  }

  void _alerta(BuildContext context) {
    if (_sUsuario.isEmpty) {
      showDialog(
        context: context,
        //Si clickamos fuera del cuadro este no se cerrara
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Envio de credenciales'),
            content: const Text(
                'Introduzca el nombre de usuario para solicitar nuevas credenciales'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        //Si clickamos fuera del cuadro este no se cerrara
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Envio de credenciales'),
            content: const Text(
                'Hemos enviado una solicitud de recuperación de credenciales.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }
}
