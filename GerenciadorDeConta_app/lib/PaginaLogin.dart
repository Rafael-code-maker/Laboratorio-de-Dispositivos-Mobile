import 'package:flutter/material.dart';
//import 'package:listatarefas_app/PaginaLogin.dart';
import 'package:listatarefas_app/PaginaInicial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaLogin extends StatefulWidget{
  PaginaLogin({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin>{

  //Variaveis
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gerenciador de Contas"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh),
              onPressed: _resetFields)
          ],
        ),
        body: _body(),
    );
  }

  _body(){
    return Form(
      key: _formKey,  //estado do formulário
      child: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextFormField(
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Login:",
                hintText: "Digite o login"
            ),
            controller: _controllerLogin,
            validator: (String text){
              if(text.isEmpty){
                return "Digite o texto";
              }
              return null;
            },
          ),
          SizedBox(height: 10,),
          TextFormField(
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Senha:",
                hintText: "Digite a senha"
            ),
            obscureText: true,
            controller: _controllerSenha,
            validator: (String text){
              if(text.isEmpty){
                return "Digite a senha ";
              }//fim if
              if(text.length < 4){
                return "A senha tem pelo menos 4 dígitos";
              }//fim if
              return null;
            },
          ),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            height: 46,
            child: RaisedButton(
                color: Colors.deepPurple,
                child: Text("Fazer Login",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),),
                onPressed: () async{
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  final String login = await prefs.getString("_controllerLogin");
                  final String senha = await prefs.getString("_controllerSenha");
                  bool formOk = _formKey.currentState.validate();
                  if(! formOk){
                    return;
                  }else{
                      if(login == _controllerLogin.text && senha == _controllerSenha.text) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaginaInicial()
                          ),
                        );
                      }else{
                          setState(() {
                            _infoText = "Usuário não enontrado \n Login e/ou senha incorretos \n Tente novamente!";
                            _textInfo();
                          });
                      }//fim if
                  }//fim if
                  print("Login "+_controllerLogin.text);
                  print("Senha "+_controllerSenha.text);
                }
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            height: 46,
            child: RaisedButton(
              color: Colors.deepPurple,
              child: Text("Cadastrar",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
              onPressed: () async{
                String entrada = _controllerLogin.text;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("_controllerLogin", entrada);
                entrada = _controllerSenha.text;
                await prefs.setString("_controllerSenha", entrada);
                setState(() {
                  _infoText = "Cadastro realizado com sucesso!";
                  _textInfo();
                });
              },
            ),
          ),
          _textInfo(),
        ],
      ),
    );
  }

  _textInfo() {
      return Text(
        _infoText,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.deepPurple, fontSize: 20),
      );
  }

  //PROCEDIMENTO PARA LIMPAR CAMPOS
  void _resetFields(){
    _controllerLogin.text = "";
    _controllerSenha.text = "";
    setState(() {
      _infoText = "Entre com suas credencias de acesso!";
    });
  }
}