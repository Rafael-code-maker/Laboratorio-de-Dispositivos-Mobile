import 'dart:io';

import 'package:educativo_app/pages/Quiz2.dart';
import 'package:educativo_app/pages/Quiz.dart';
import 'package:flutter/material.dart';


class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  void _abrirSobreApp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            //builder: (context) => PaginaSobreApp())
            builder: (context) => Quiz())
    );
  }

  void _abrirSobreApp2() {
    Navigator.push(
        context,
        MaterialPageRoute(
          //builder: (context) => PaginaSobreApp())
            builder: (context) => Quiz2())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("O quê deseja aprender ?"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Aprendizado das letras :"),
                  GestureDetector(
                    onTap: _abrirSobreApp,
                    child: Image.asset("assets/abc.png"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Aprendizado dos números :"),
                  GestureDetector(
                    onTap: _abrirSobreApp2, //deve ser criada a função e página e alterado
                    child: Image.asset("assets/coruja.png"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
