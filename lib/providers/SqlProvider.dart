import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlProvider{

  Database db;

  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Ahorradora.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
                create table usuario ( 
                  id integer primary key autoincrement, 
                  token text not null,
                  email text not null)
                ''');
          await db.execute('''
                create table casilla ( 
                  id integer primary key autoincrement, 
                  tipo integer not null,
                  valor integer not null,
                  marcada integer not null)
                ''');
        });
  }

  Future<Usuario> insertUser(Usuario user) async {
    user.id = await db.rawInsert('INSERT INTO usuario (token,email) VALUES(?,?)',[user.token,user.email]);
    return user;
  }

  Future<Casilla> insertCasilla(Casilla casilla) async {
    casilla.id = await db.rawInsert('INSERT INTO casilla (tipo,valor,marcada) VALUES(?,?,?)',[casilla.tipo,casilla.valor,casilla.marcada?1:0]);
    return casilla;
  }

  Future<dynamic> updateEstadoCasilla(Casilla casilla) async {
    await db.rawUpdate('UPDATE casilla  SET  marcada=? WHERE id=?', [casilla.marcada?1:0,casilla.id]);
  }

  Future<List<Map>> sumatoriaCasilla() async {
    return await db.query('casilla',columns:['SUM(valor) AS suma'],where: 'marcada=?',whereArgs: ['1']);
  }

  Future<List<Casilla>> getCasillas(int tipo) async {
    List<Map> maps = await db.query('casilla',
        columns: ['id', 'tipo', 'valor','marcada'],
        where: 'tipo = ?',
        whereArgs: [tipo]);
    if (maps.length > 0) {
      List<Casilla> casillas=new List();
      maps.forEach((e){
        casillas.add(Casilla.fromMap(e));
      });
      return casillas;
    }
    return null;
  }

  Future<Usuario> getUser(int id) async {
    List<Map> maps = await db.query('usuario',
        columns: ['id', 'token', 'email'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<Usuario> getUserUnique() async {
    List<Map> maps = await db.query('usuario');
    if (maps.length > 0) {
      print(maps.first);
      print(Usuario.fromMap(maps.first).email);
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future close() async => db.close();
}

class Usuario{
  int id;
  String token;
  String email;

  Usuario(id,email,token){
    this.id=id;
    this.token=token;
    this.email=email;
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    token = map['token'];
    email = map['email'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      token: token,
      email: email
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

}

class Casilla{
  int id;
  int tipo;
  int valor;
  bool marcada;

  Casilla(int id, this.tipo, this.valor, this.marcada);

  Casilla.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tipo = map['tipo'];
    valor = map['valor'];
    marcada=map['marcada']==1;
  }

}