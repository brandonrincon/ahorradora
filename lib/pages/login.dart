import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:ahorradora/providers/SqlProvider.dart';
class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SqlProvider  sqlProvider= new SqlProvider();
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  @override
  initState()  {
    super.initState();
    _verificarLogin();
  }

  _verificarLogin() async{
    await sqlProvider.open();
    Usuario s= await sqlProvider.getUserUnique();
    print(s);
    if(s!=null){
      Navigator.pushNamed(context, '/menu');
    }
  }



   _handleSignIn() async {
    _formKey.currentState.save();
    FirebaseUser user;
    try{
        user = await _auth.signInWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );
    }catch(error){
      if(error.code=='ERROR_USER_NOT_FOUND'){
        Toast.show('Ingreso exitoso',context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        user= await _handleRegistro();
      }
      Toast.show(error.message,context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
    if(user!=null){
      Usuario u=new Usuario(1,email,user.uid);
      await sqlProvider.open();
      u = await sqlProvider.insertUser(u);
      print(u.email);
      Navigator.pushNamed(context, '/menu');
    }
  }

  Future<FirebaseUser> _handleRegistro() async {
    try {
      final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );
      return user;
    }catch(error){
      Toast.show(error.message,context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(39,53,73, 1),

      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.3, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color.fromRGBO(29,42,55, 1),
              Color.fromRGBO(22,32,42,1),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                            labelStyle: TextStyle(
                                decorationColor: Color.fromRGBO(255,160,4,1),
                                color: Color.fromRGBO(255,160,4,1),
                            ),
                            hintStyle: TextStyle(
                              decorationColor: Color.fromRGBO(255,160,4,1),
                              color: Color.fromRGBO(255,160,4,1),
                            ),
                            hintText: 'Email',
                            labelText: 'Ingrese su email'),
                            style: TextStyle(
                              color: Color.fromRGBO(255,160,4,1),
                              decorationColor: Color.fromRGBO(255,160,4,1),
                            ),
                            cursorColor: Color.fromRGBO(255,160,4,1),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email';
                          }
                        },
                        onSaved: (String value) {
                          this.email = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:25),
                        child: TextFormField(
                          style: TextStyle(
                            color: Color.fromRGBO(255,160,4,1),
                            decorationColor: Color.fromRGBO(255,160,4,1),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: new InputDecoration(
                              labelStyle: TextStyle(
                                decorationColor: Color.fromRGBO(255,160,4,1),
                                color: Color.fromRGBO(255,160,4,1),
                              ),
                              hintStyle: TextStyle(
                                decorationColor: Color.fromRGBO(255,160,4,1),
                                color: Color.fromRGBO(255,160,4,1),
                              ),
                              hintText: 'Password',
                              labelText: 'Ingrese su contraseña'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingrese su contraseña';
                            }
                          },
                            onSaved: (String value) {
                              this.password = value;
                            },
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            onPressed: () {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState.validate()) {
                                this._handleSignIn();
                              }
                            },
                            child: Text('Ingresar'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
