import 'package:cloud_firestore/cloud_firestore.dart';

import 'SqlProvider.dart';

class DataProvider{

  SqlProvider sqlProvider;

  DataProvider(){
      sqlProvider=new SqlProvider();
      for(int i=0;i<5;i++){
        _genData(i);
      }

  }

  _genData(int tipo) async{
    await sqlProvider.open();
    List<Casilla> v= await sqlProvider.getCasillas(tipo);
    if(v==null){
      Stream<DocumentSnapshot> snap = Firestore.instance.collection('categorias').document(tipo.toString()).snapshots();
      snap.listen((onData){
        List<dynamic> numbers=onData.data["valores"];
        numbers.forEach((f){
          int n=f as int;
          sqlProvider.insertCasilla(new Casilla(0,tipo,n,false));
        });
      });
    }
  }
}

