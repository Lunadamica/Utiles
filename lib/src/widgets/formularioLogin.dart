import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solucionutiles/src/api/BBDD.dart';
import 'package:solucionutiles/src/datos/autentificacionCliente.dart';
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
  GlobalKey<FormState> _formKey = new GlobalKey();
  String _sUsuario = '', _sclave = '';
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  final _autentificacionCliente = GetIt.instance<AutentificacionCliente>();
  String sCodigoVersion = "";
  bool bDescargaFichero = false;
  bool _ocultarClave = true;
  IconData icono = Icons.visibility_off;

  _FormularioLoginState() {
    comprobarUsuario();
  }

  void comprobarUsuario() async {
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    String? sUsuario = miConfiguracion.getString("Usuario");

    if (sUsuario != null) {
      if (sUsuario.trim().length > 0) {
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
    final isOK = _formKey.currentState!.validate();

    if (isOK) {
      if (_sUsuario.trim().length == 0 || _sclave.trim().length == 0) {
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

          final RespuestaHTTP miUsuario =
              await _miBBDD.dameInformacionUsuario();

          if (miUsuario.data != null) {
            // await _autentificacionCliente.saveSession(miRespuesta.data);
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

          Navigator.pushNamedAndRemoveUntil(context, "home", (_) => false);
        } else {
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
                  controlador: TextEditingController(text: '$_sUsuario'),
                  onChanged: (text) {
                    _sUsuario = text;
                  },
                  validator: (text) {
                    if (text?.trim().length == 0) {
                      return 'Usuario incorrecto';
                    }
                    return null;
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(),
                  ),
                  child: Row(
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
                            if (text?.trim().length == 0) {
                              return 'Contraseña incorrecta';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Recordar contraseña',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.dp(1.5),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                SizedBox(
                  height: responsive.dp(5),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: this._validar,
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
}
