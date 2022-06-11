// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucionutiles/src/api/BBDD.dart';

import '../helpers/RespuestaHTTP.dart';
import '../modelos/cliche.dart';
import '../modelos/maquina.dart';
import '../modelos/troquel.dart';
import '../utils/utils.dart';

class ContenedorMaquina extends StatefulWidget {
  String codigoUtil;
  String orden;
  String idFabricacion;
  bool checked;
  Color color;
  String opcionSeleccionada;
  Maquina miMaquina;
  List<Maquina> misMaquinas;

  ContenedorMaquina(
      {Key? key,
      required this.codigoUtil,
      required this.checked,
      required this.color,
      required this.opcionSeleccionada,
      required this.miMaquina,
      required this.misMaquinas,
      required this.orden,
      required this.idFabricacion})
      : super(key: key);

  @override
  State<ContenedorMaquina> createState() => _ContenedorMaquinaState();
}

class _ContenedorMaquinaState extends State<ContenedorMaquina> {
  final BBDD _miBBDD = GetIt.instance<BBDD>();
  int selectedRadio = 0;
  Map<int?, dynamic?> _fisicos = <int?, dynamic?>{};
  String? nombreMaquina;
  List<Cliche>? _misCliches = [];
  List<Troquel>? _misTroqueles = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.color,
        ),
        child: CheckboxListTile(
          title: Text(
              '${widget.orden} - ${widget.codigoUtil} - ${widget.idFabricacion}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          value: widget.checked,
          onChanged: (bool? value) {
            setState(() {
              widget.checked = value!;

              if (widget.opcionSeleccionada == TCliche) {
                cargarCliches();
              } else {
                cargarTroqueles();
              }
              _enviarMaquina(context);
            });
          },
          secondary: TextButton(
            child: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, 'buscador',
                  //argumentos que manda los datos desde la lista de inventario
                  arguments: {
                    'opcionSeleccionada': widget.opcionSeleccionada,
                    'codUtil': widget.codigoUtil,
                    'misMaquinas': widget.misMaquinas,
                  });
            },
          ),
        ),
      ),
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  //Cargamos los cliches que tenemos con ese codigo de cliche
  Future<void> cargarCliches() async {
    final RespuestaHTTP<List<Cliche>> miRespuesta =
        await _miBBDD.dameCliches(codigoCliche: widget.codigoUtil);

    if (miRespuesta.data != null) {
      _misCliches = miRespuesta.data;
      _fisicos.clear();
      //Recorremos nuestra lista de cliches para crear una lista con los fisicos y la maquina a la que esta asociada
      for (int i = 0; i < _misCliches!.length; i++) {
        //si mi lista de fisicos no contiene ya ese fisico lo añadimos
        if (!_fisicos.keys.contains(_misCliches![i].codFisico!)) {
          _fisicos
              .addAll({_misCliches![i].codFisico!: _misCliches![i].codMaquina});
        }
      }
      setState(() {});
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }

  Future<void> cargarTroqueles() async {
    final RespuestaHTTP<List<Troquel>> miRespuesta =
        await _miBBDD.dameTroqueles(codigoTroquel: widget.codigoUtil);

    if (miRespuesta.data != null) {
      _misTroqueles = miRespuesta.data;
      //Recorremos nuestra lista de cliches para crear una lista con los fisicos y la maquina a la que esta asociada
      for (int i = 0; i < _misTroqueles!.length; i++) {
        //si mi lista de fisicos no contiene ya ese fisico lo añadimos
        if (!_fisicos.keys.contains(_misTroqueles![i].codFisico!)) {
          _fisicos.addAll(
              {_misTroqueles![i].codFisico!: _misTroqueles![i].codMaquina});
        }
      }
      setState(() {});
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }

//Una vez que tenemos nuestra lista de cliches cargada con los fisicos y
//la maquina correspondiente abrimos una pantalla emergente
  Future<bool> _enviarMaquina(BuildContext context) async {
    //Ponemos un delayed para que espere 50 milisegundos para que carguen los datos
    await Future.delayed(const Duration(milliseconds: 100), () {});
    //Si el check es true
    if (widget.checked) {
      //Si tenemos varios utiles con el mismo codigo
      if (_fisicos.length > 1) {
        showDialog(
          context: context,
          //Si clicamos fuera del cuadro este no se cerrara
          barrierDismissible: false,
          builder: (context) {
            return FittedBox(
              child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text('Envio a máquina'),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                            'Partes del ${widget.opcionSeleccionada} nº ${widget.codigoUtil}:'),
                        const SizedBox(
                          height: 10,
                        ),
                        //Nos aseguramos de que la lista de cliches tenga datos
                        if (_misCliches!.isNotEmpty ||
                            _misTroqueles!.isNotEmpty)
                          Column(
                            children: [
                              for (var fisico in _fisicos.keys)
                                _cargarDatos(fisico),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              onPressed: () {
                                pasarAMaquina(widget.miMaquina.codMaquina!);
                                Navigator.of(context).pop();
                                widget.checked = true;
                                _fisicos.clear;
                                setState(() {});
                              },
                              child: const Text('Aceptar'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                widget.checked = false;
                                selectedRadio = 0;
                                setState(() {});
                              },
                              child: const Text('Volver'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
            );
          },
        );
      } else {
        //Si solo tiene un fisico asigno el codFisico y lo paso directamente a maquina
        for (var fisico in _fisicos.keys) {
          selectedRadio = fisico!;
        }
        pasarAMaquina(widget.miMaquina.codMaquina!);
        widget.checked = true;
        _fisicos.clear;
        setState(() {});
      }
    }
    //si el check es false
    else {
      cargarCliches();
      for (var fisico in _fisicos.keys) {
        //Busco el fisico que esta en maquina
        if (_fisicos[fisico] != 0) {
          selectedRadio = fisico!;
        }
      }
      //Le pasamos la maquina a 0
      pasarAMaquina(0);
      // _fisicos[selectedRadio] = 0;
      _fisicos.clear;
      setState(() {});
    }

    return widget.checked;
  }

  Future<void> pasarAMaquina(int codMaquina) async {
    String? valorUtil;
    if (widget.opcionSeleccionada == TCliche) {
      valorUtil = tipoCliche;
    } else if (widget.opcionSeleccionada == TTroquel) {
      valorUtil = tipoTroquel;
    }
    final RespuestaHTTP miRespuesta = await _miBBDD.pasarAMaquina(
        valorUtil,
        selectedRadio.toString(),
        codMaquina.toString(),
        widget.idFabricacion.toString(),
        widget.codigoUtil.toString());

    if (miRespuesta.data != null) {
      print(miRespuesta.data);
      selectedRadio = 0;
    } else {
      mostrarMensaje(true, miRespuesta.error!.mensaje!);

      comprobarTipoError(context, miRespuesta.error!);
    }
  }

//Recibimos por parametro la clave de nuestro map que es el codigo del fisico
  Widget _cargarDatos(int? fisico) {
    //recorremos la lista de mis maquinas
    for (int i = 0; i < widget.misMaquinas.length; i++) {
      //Cuando el codigo de maquina de mi fisico sea igual al de la lista asignamos a ese valor un nombre de maquina
      if (_fisicos[fisico] == widget.misMaquinas[i].codMaquina) {
        nombreMaquina = widget.misMaquinas[i].nombreMaquina;
      }
    }
    //Si nuestro fisico esta asignado a una maquina
    if (_fisicos[fisico] != 0) {
      return ListTile(
        //Mostramos el codigo fisico y el nombre de la maquina
        title: Text('$fisico - $nombreMaquina'),
        leading: Radio(
          value: fisico!,
          groupValue: selectedRadio,
          activeColor: Colors.blue,
          onChanged: (int? valor) {
            setState(() {
              //FUTURA IMPLEMENTACIÓN PARA PODER UN ÚTIL DE UNA MÁQUINA A OTRA
              // print(valor); //Valor es el codigo fisico que ha sido seleccionado
              // //debido a problemas de estado de los cuadros de dialogo cerramos y volvemos a abrir cuando cambiemos el estado
              // selectedRadio = valor!;
              // Navigator.of(context).pop();
              // _enviarMaquina(context);
            });
          },
        ),
      );
      //si nuestro fisico NO esta asignado a una maquina
    } else {
      return ListTile(
        //mostramos solo el fisico
        title: Text(fisico.toString()),
        leading: Radio(
          value: fisico!,
          groupValue: selectedRadio,
          activeColor: Colors.blue,
          onChanged: (int? valor) {
            setState(() {
              //debido a problemas de estado de los cuadros de dialogo cerramos y volvemos a abrir cuando cambiemos el estado
              selectedRadio = valor!;

              Navigator.of(context).pop();
              _enviarMaquina(context);
            });
          },
        ),
      );
    }
  }
}
