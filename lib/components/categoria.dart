import 'package:ahorradora/providers/DataProvider.dart';
import 'package:ahorradora/providers/SqlProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'CasillaCard.dart';

class Categoria extends StatefulWidget {
  Categoria({Key key, this.index}) : super(key: key);
  final int index;

  @override
  CategoriaPageState createState() => CategoriaPageState();
}

class CategoriaPageState extends State<Categoria> {
  static DataProvider dataProvider;
  List<Casilla> casillas = new List();
  int indexAnterior = -1;
  String ahorrado = '0';

  @override
  initState() {
    super.initState();
  }

  _loadData() async {
    if (indexAnterior == widget.index) return;
    if (indexAnterior == -1)
      setState(() {
        indexAnterior = widget.index;
      });
    dataProvider = new DataProvider();
    await dataProvider.sqlProvider.open();
    List<Casilla> c = await dataProvider.sqlProvider.getCasillas(widget.index);
    List<Map<dynamic, dynamic>> a =
        await dataProvider.sqlProvider.sumatoriaCasilla();
    if (a != null && a.first != null) {
      final FlutterMoneyFormatter formatter =
          FlutterMoneyFormatter(amount: a.first['suma'].ceilToDouble());
      setState(() {
        ahorrado = formatter.output.withoutFractionDigits.toString();
      });
    }
    setState(() {
      casillas = c;
      indexAnterior = widget.index;
    });
  }

  _updateCasilla(Casilla c) async {
    print(c.valor);
    await dataProvider.sqlProvider.open();
    await dataProvider.sqlProvider.updateEstadoCasilla(c);
    List<Map<dynamic, dynamic>> a =
        await dataProvider.sqlProvider.sumatoriaCasilla();
    if (a != null && a.first != null) {
      final FlutterMoneyFormatter formatter =
          FlutterMoneyFormatter(amount: a.first['suma'].ceilToDouble());
      setState(() {
        ahorrado = formatter.output.withoutFractionDigits.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: <Widget>[
        Container(
          constraints: BoxConstraints(
            maxHeight: 420,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.8],
              colors: [
                Color.fromRGBO(29, 42, 55, 1),
                Color.fromRGBO(22, 32, 42, 1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: casillas.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return CasillaCard(
                      onPressed: () {
                        setState(() {
                          casillas[index].marcada = !casillas[index].marcada;
                        });
                        _updateCasilla(casillas[index]);
                      },
                      casilla: casillas[index]);
                }),
          ),
        ),
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text('\u0024',style: TextStyle(color: Colors.white)),
          ),
          label: Text(
            ahorrado,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ]),
    );
  }
}
