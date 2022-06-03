import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:solucionutiles/src/utils/responsive.dart';
import 'package:solucionutiles/src/utils/utils.dart';
import 'package:solucionutiles/src/widgets/background.dart';
import 'package:solucionutiles/src/widgets/mostrarDatosCliche.dart';

import '../modelos/cliche.dart';
import '../modelos/troquel.dart';
import 'VisorPdf.dart';

class DatosBusqueda extends StatelessWidget {
  final List<Cliche>? listaCliche;
  final List<Troquel>? listaTroquel;

  final context;
  const DatosBusqueda({
    Key? key,
    this.listaCliche,
    this.listaTroquel,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return datos();
  }

  Widget datos() {
    Responsive size = Responsive(context);
    final f = DateFormat('dd-MM-yyyy');

    if (listaCliche != null && listaCliche!.isNotEmpty) {
      return MostrarDatosCliche(
        listaCliche: listaCliche,
      );
    } else if (listaTroquel != null && listaTroquel!.isNotEmpty) {
      bool conLlegada = preLlegada(listaTroquel![0].codEstado!);
      return GestureDetector(
        onTap: () {
          _alerta(context, listaTroquel!);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(10),
          width: size.width,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  const Text(
                    'Código troquel: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    listaTroquel![0].codUtil.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text(
                    'Número de tejas: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    listaTroquel!.length.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text(
                    'Ancho bruto: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    listaTroquel![0].anchoUtil.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text(
                    'Estado: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${listaTroquel![0].codEstado}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    ' - ${listaTroquel![0].nomEstado}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text(
                    'Código pieza: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${listaTroquel![0].codPieza}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text(
                    'Código subpieza: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${listaTroquel![0].codSubpieza}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Text(
                    'Fecha cambio: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    f.format(
                        DateTime.parse('${listaTroquel![0].fechaCambioUtil}')),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Visibility(
                visible: conLlegada,
                child: Column(
                  children: [
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          'Fecha prevista de llegada: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          f.format(DateTime.parse(
                              '${listaTroquel![0].fechaPrLlegada}')),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text(
                      'Causa: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${listaTroquel![0].causa}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Text(
                'Nombre del cliente: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                '${listaTroquel![0].nomCliente}',
                style: const TextStyle(fontSize: 15),
              ),
              const Divider(),
              const Text(
                'Referencia: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                '${listaTroquel![0].referencia}',
                style: const TextStyle(fontSize: 15),
              ),
              const Divider(),
              const Text(
                'Observaciones: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                '${listaTroquel![0].observaciones}',
                style: const TextStyle(fontSize: 15),
              ),
              const Divider(),
              //Mostramos un PDF
              VisorPdf(
                codigo: listaTroquel![0].codUtil.toString(),
                tipo: tipoTroquel,
              ),
            ],
          ),
        ),
      );
    }
    return const Text('No se encuentran datos');
  }

  bool preLlegada(int estado) {
    bool conLlegada = false;
    if (estado == pendienteLlegar) {
      conLlegada = true;
    }
    return conLlegada;
  }

  void _alerta(BuildContext context, List<Troquel> lista) {
    showDialog(
        context: context,
        //Si clicamos fuera del cuadro este no se cerrara
        barrierDismissible: false,
        builder: (context) {
          return Scaffold(
            // drawer: MenuNavegacion(),
            appBar: dameAppBar('Lista de datos', context),
            body: Stack(children: [
              Background(),
              ListView(
                children: <Widget>[
                  for (int i = 0; i < lista.length; i++)
                    Card(
                      //Creación de sombra de la tarjeta
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(children: <Widget>[
                        const Padding(padding: EdgeInsets.all(5)),
                        ListTile(
                          title: Text(
                            'Datos ${lista[i].codUtil.toString()}:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                'Código físico: ${lista[i].codFisico}\nCódigo parte: ${lista[i].codParte}\nLargo parte: ${lista[i].largo}\n\nCódigo Almacén: ${lista[i].codAlmacen}\nNombre almacén: ${lista[i].nombreAl}\nTipo almacén: ${lista[i].tipoAl}\n\nCódigo zona: ${lista[i].codZona}\nNombre zona: ${lista[i].codZona}\nAncho zona: ${lista[i].anchoZo}\n\nCódigo casillero: ${lista[i].codCasillero}\nNombre casillero: ${lista[i].nombreCa}\nAncho casillero: ${lista[i].anchoCa}\nTipo casillero: ${lista[i].tipoCa}\n\nCódigo máquina: ${lista[i].codMaquina}'),
                          ),
                        ),
                      ]),
                    )
                ],
              ),
            ]),
          );
        });
  }
}
