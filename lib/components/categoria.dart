import 'package:ahorradora/providers/DataProvider.dart';
import 'package:ahorradora/providers/SqlProvider.dart';
import 'package:flutter/material.dart';

import 'CasillaCard.dart';


class Categoria extends StatefulWidget {

  Categoria({Key key, this.index}) : super(key: key);
  final int index;
  List<Casilla> casillas=new List();


  @override
  CategoriaPageState createState() => CategoriaPageState();
}

class CategoriaPageState extends State<Categoria>{

  DataProvider dataProvider;

  CategoriaPageState(){
    _loadData();
  }

  _loadData() async{
    dataProvider=new DataProvider();
    await dataProvider.sqlProvider.open();
    List<Casilla> c= await dataProvider.sqlProvider.getCasillas(widget.index);
    setState(() {
      widget.casillas=c;
    });
  }

  _updateCasilla(Casilla c) async{
    print(c.valor);
    await dataProvider.sqlProvider.open();
    await dataProvider.sqlProvider.updateEstadoCasilla(c.id);
    List<Map<dynamic, dynamic>> a= await dataProvider.sqlProvider.sumatoriaCasilla();
    if(a!=null && a.first!=null){
      print(a.first['suma']);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.8],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Color.fromRGBO(29,42,55, 1),
            Color.fromRGBO(22,32,42,1),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
        child: GridView.builder(
            itemCount: widget.casillas.length,
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context,index){
              return CasillaCard(onPressed: (){
                setState(() {
                widget.casillas[index].marcada= !widget.casillas[index].marcada;
                });
                _updateCasilla(widget.casillas[index]);
              },casilla: widget.casillas[index]);
            }),
      ),
    );
  }

}
