import 'package:ahorradora/providers/SqlProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class CasillaCard extends StatefulWidget{

  CasillaCard({@required this.onPressed,@required this.casilla});

  GestureTapCallback onPressed;
  final Casilla casilla;

  @override
  CasilllaState createState() => CasilllaState();
}

class CasilllaState extends State<CasillaCard>{

  @override
  Widget build(BuildContext context) {
    final FlutterMoneyFormatter formatter=FlutterMoneyFormatter(amount: widget.casilla.valor.ceilToDouble());
    return  Padding(
        padding: const EdgeInsets.all(4.0),
        child:  RawMaterialButton(
            onPressed:widget.onPressed,
            splashColor: Color.fromRGBO(71,68,196,1),
            fillColor: (!widget.casilla.marcada)?Color.fromRGBO(39,53,73,1):Color.fromRGBO(71,68,196,1),
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
              alignment: Alignment.center,
              child: Text(formatter.output.withoutFractionDigits.toString(),
                style: TextStyle(fontSize: 21,color:(widget.casilla.marcada)?Colors.white:Colors.white70),
              ),
            )
        )
    );
  }
}